"""
THIS FUNCTION WILL START OR STOP ECS TASKS IN YOUR REGION WHENEVER TRIGGERED, EXAMPLE USECASE
WILL BE FOR COST SAVING.
TO MAKE COMPLETE AUTOMATION TO START OR STOP YOUR ECS TASKS HAVE THE FLOW AS -
1] EVENTBRIDGE RULE WITH CRON OR SOME CONDITION AS PER REQUIREMENT.
2] SET THE LAMBDA AS TARGET TO EVENTBRIDGE RULE.
3] ADD THE "timer" TAG TO THE ECS CLUSTERS WITH VALUE "TIMER_ON", ONLY ECS CLUSTERS WITH THIS
TAG WILL BE AFFECTED BY THIS FUNCTION.
4] YOU CAN CUSTOMIZE THE DESIRED COUNT AND AUTOSCALING CONFIGS AS PER YOUR REQUIREMENT.

NOTE - SETTING THE DESIRED COUNT AND AUTOSCALING MAXCOUNT & MINCOUNT VALUES TO "0" WILL MAKE THE
FUNCTION TO STOP ALL ELIGIBLE ECS TASKS, SO YOU CAN MAKE TWO DIFFERENT FUNCTIONS WITH 2 DIFFERNET
CRON EXPRESSION EVENTBRIDGE RULES TO START & STOP YOUR ECS TASKS AUTOMATICALLY !!

"""

import boto3

ecs_client = boto3.client('ecs')
autoscaling_client = boto3.client('application-autoscaling')
def lambda_handler(event, context):
    """Lambda function python boto3    """
    paginator = ecs_client.get_paginator('list_clusters')
    response_iterator = paginator.paginate(
        PaginationConfig={
            'PageSize':50
        })
    for page in response_iterator:
        for arn in page['clusterArns']:
            ClusterTagsList = ecs_client.list_tags_for_resource(resourceArn=arn)
            timer = ""

            for tags in ClusterTagsList['tags']:
                if tags["key"] == 'timer':
                    timer = tags["value"]
            if timer == 'TIMER_ON':
                serviceresponse = ecs_client.list_services(cluster=arn)
                print("Service ARN :", serviceresponse["serviceArns"])
                for serviceName in serviceresponse["serviceArns"]:
                    update_service(serviceName, arn=arn)

def update_service(serviceName, arn):
    """Update function"""
    clustername = arn.split("/")[1]
    occurence = serviceName.count('/')
    ServiceNameModified = ''
    if int(occurence) == 2:
        ServiceNameModified = serviceName.split("/")[2]
    else:
        ServiceNameModified = serviceName.split("/")[1]
    describe_response_autoscaling = autoscaling_client.describe_scaling_policies(
        ServiceNamespace='ecs',
        ResourceId='service/{0}/{1}'.format(clustername, ServiceNameModified))
    response_autoscaling = describe_response_autoscaling.get('ScalingPolicies')
    response_autoscaling_dictionary = not bool(response_autoscaling)
    if str(response_autoscaling_dictionary) == 'False':
        update_response = ecs_client.update_service(
            cluster=arn,
            service=serviceName,
            desiredCount=2
            # change desired cnt to 0 for task stopping
        )
        deregister_response_autoscaling_new = autoscaling_client.register_scalable_target(
            MaxCapacity=3,    # Change max & Min to 0 for stopping tasks
            MinCapacity=2,
            ResourceId='service/{0}/{1}'.format(clustername, ServiceNameModified),
            ScalableDimension='ecs:service:DesiredCount',
            ServiceNamespace='ecs',
        )
        print('Started task of service: \t' +ServiceNameModified)
    else:
        update_response = ecs_client.update_service(
            cluster=arn,
            service=serviceName,
            desiredCount=2
            # change desired cnt to 0 for task stopping
        )
        print('Started task of service: \t' +ServiceNameModified)

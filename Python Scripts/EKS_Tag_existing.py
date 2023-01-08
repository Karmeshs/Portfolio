"""
This function adds some fixed and some conditional tags based on EKS Cluster's first subnet id
to the EKS cluster and the associated nodegroups. Nodes can be tagged through launch template.

Function can be run manually or could be triggered based on cron expression through eventbridge.
"""
import json
import logging
import boto3
import botocore

logging.getLogger().setLevel(logging.INFO)
log = logging.getLogger(__name__)

# Instantiate Boto3 clients & resources for every AWS service API called
eks_client = boto3.client('eks')

# Apply resource tags to EC2 instances & attached EBS volumes
def set_eks_tags(resource_arn, resource_tags):
#     """Applies a list of passed resource tags to the Amazon EKS/Nodegroup.

#     Args:
#         reource_arn: EKS/Nodegroup identifier
#         resource_tags: a dictionary of key:value resource tags

#     Returns:
#         Returns True if tag application successful and False if not

#     Raises:
#         AWS Python API "Boto3" returned client errors """

    try:
        response = eks_client.tag_resource(
            resourceArn=resource_arn,tags=resource_tags
            )
        return True
        
    except botocore.exceptions.ClientError as error:
        log.error(f"Boto3 API returned error: {error}")
        log.error(f"No Tags Applied To: {resource_arn}")
        return False

###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
def lambda_handler(event, context):
    """Making a dictionary of tags "resource_tags" to be applied to resources"""
    #Finding arn and first subnet of all clusters and tagging them
    clusters=eks_client.list_clusters()
    for cluster in clusters['clusters']:
        #Adding fixed tags  
        resource_tags = {}
        resource_tags.update({"Backup" : "No"})
        resource_tags.update({"Service": "Kubernetes"})
        cluster_arn = eks_client.describe_cluster(name=cluster)['cluster']['arn']
        subnet=eks_client.describe_cluster(name=cluster)['cluster']['resourcesVpcConfig']['subnetIds'][0]

        #Adding conditional tags based on subnet id
        if subnet== "subnet-12002f8f81f0c344y":
            resource_tags.update({"AppCode" : "UI"})
            resource_tags.update({"Env" : "PR"})
            
        elif subnet== "subnet-10ot46bef3a4d1gps":
            resource_tags.update({"AppCode" : "Batch"})
            resource_tags.update({"Env" : "Dev"})
    
        elif subnet== "subnet-9922355da6d565q23" or subnet== "subnet-1bv77b8c5909e47nm": # Subnets with same tags added in 'or'.
            resource_tags.update({"AppCode" : "Val"})
            resource_tags.update({"Env" : "NP"})
            
        #Function call to add tags     
        if set_eks_tags(cluster_arn,resource_tags):
            log.info("'statusCode': 200")
            log.info(f"'Resource ID': {cluster_arn}")
            log.info(f"'body': {json.dumps(resource_tags)}")
        else:
            log.info("'statusCode': 500")
            log.info(f"'No tags applied to Resource ID': {cluster_arn}")
            log.info(f"'Lambda function name': {context.function_name}")

        #Finding Nodegroup arns and tagging them
        nodegroups = eks_client.list_nodegroups(clusterName=cluster)
        for ng in nodegroups['nodegroups']:
            ng_arn = eks_client.describe_nodegroup(clusterName=cluster,nodegroupName=ng)['nodegroup']['nodegroupArn']
            #Function call to add tags     
            if set_eks_tags(ng_arn,resource_tags):
                log.info("'statusCode': 200")
                log.info(f"'Resource ID': {ng_arn}")
                log.info(f"'body': {json.dumps(resource_tags)}")
            else:
                log.info("'statusCode': 500")
                log.info(f"'No tags applied to Resource ID': {ng_arn}")
                log.info(f"'Lambda function name': {context.function_name}")

#AWS CLI command to untag eks cluster 
# aws eks untag-resource --resource-arn arn:aws:eks:ap-south-1:678966538111:cluster/test --tag-keys AppCode 
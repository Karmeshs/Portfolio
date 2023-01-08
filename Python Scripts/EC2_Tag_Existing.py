"""
This function adds some fixed and some conditional tags based on instance name to the ec2
instances and attached ebs volumes for all the instances or some selective instances.

Function can be run manually or could be triggered based on cron expression through eventbridge.
"""
import json
import logging
import boto3
import botocore

logging.getLogger().setLevel(logging.INFO)
log = logging.getLogger(__name__)

# Instantiate Boto3 clients & resources for every AWS service API called
ec2_client = boto3.client("ec2")
ec2_resource = boto3.resource("ec2")

# Apply resource tags to EC2 instances & attached EBS volumes
def set_ec2_instance_attached_vols_tags(ec2_instance_id, resource_tags):
    """Applies a list of passed resource tags to the Amazon EC2 instance.
       Also applies the same resource tags to EBS volumes attached to instance.

    Args:
        ec2_instance_id: EC2 instance identifier
        resource_tags: a list of key:string,value:string resource tag dictionaries

    Returns:
        Returns True if tag application successful and False if not

    Raises:
        AWS Python API "Boto3" returned client errors
    """
    try:
        response = ec2_client.create_tags(
            Resources=[ec2_instance_id], Tags=resource_tags
        )
        response = ec2_client.describe_volumes(
            Filters=[{"Name": "attachment.instance-id", "Values": [ec2_instance_id]}]
        )
        try:
            for volume in response.get("Volumes"):
                ec2_vol = ec2_resource.Volume(volume["VolumeId"])
                vol_tags = ec2_vol.create_tags(Tags=resource_tags)
            return True
        except botocore.exceptions.ClientError as error:
            log.error(f"Boto3 API returned error: {error}")
            log.error(f"No Tags Applied To: {volume['VolumeId']}")
            return False
    except botocore.exceptions.ClientError as error:
        log.error(f"Boto3 API returned error: {error}")
        log.error(f"No Tags Applied To: {ec2_instance_id}")
        return False


###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
def lambda_handler(event, context):
   """Making a list of tags "resource_tags" to be applied to resources"""
    # Tag EC2 instances        
    for instance in ec2_resource.instances.all():
        resource_tags = []
        flag = 0
        resource_tags.append({"Key": "ResourceType", "Value": "EC2"})

        for tag in instance.tags:
            if tag['Key'] == "Name":
                name = tag['Value']
                env = name[0:2]
                os = name[2:3]
                
                #condition to tag instances only in specific envt or of particular os
                if env != "NP" or os != "R":
                    flag = 1

                if env == "NP":
                    resource_tags.append({"Key": "ENV", "Value": "DEV"})                               
                elif env == "PR":
                    resource_tags.append({"Key": "ENV", "Value": "PROD"})
                    
                if os == "R":
                    resource_tags.append({"Key": "OS", "Value": "RHEL"})
                elif os == "U":
                    resource_tags.append({"Key": "OS", "Value": "Ubuntu"})
        
        if len(resource_tags) > 0 and flag != 1:
            #Function call to add tags to ec3 and ebs        
            if set_ec2_instance_attached_vols_tags(instance.id, resource_tags):
                log.info("'statusCode': 200")
                log.info(f"'Resource ID': {name}")
                log.info(f"'body': {json.dumps(resource_tags)}")
            else:
                log.info("'statusCode': 500")
                log.info(f"'No tags applied to Resource ID': {name}")
                log.info(f"'Lambda function name': {context.function_name}")
                log.info(f"'Lambda function version': {context.function_version}")
        else:
            log.info("'statusCode': 200")
            log.info(f"'No tags to add to Resource ': {name}")    
"""
FLOW - 
1] You create an ec2 with some name 
2] EC2 runinstances API call is registered in cloudtrail which triggers eventbridge
3] Eventbridge then triggers the lambda funtion containing below code.

This function adds some fixed and some conditional tags based on information recieved through event
to the newly created ec2 instance and attached ebs volumes for which the lambda was triggered.

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

def cloudtrail_event_parser(event):
    """Extract list of new EC2 instance attributes, creation date, IAM role name,
    SSO User ID from the AWS CloudTrail resource creation event.

    Args:
        event: a cloudtrail event in python dictionary format

    Returns a dictionary containing these keys and their values:
        iam_user_name: the user name of the IAM user
        instances_set: list of EC2 instances & parameter dictionaries
        resource_date: date the EC2 instance was created
    Raises:
        none
    """
    returned_event_fields = {}

    # Extract the date & time of the EC2 instance creation
    returned_event_fields["resource_date"] = event.get("detail").get("eventTime")

    # Check if an IAM user created these EC2 instances & get that user
    if event.get("detail").get("userIdentity").get("type") == "IAMUser":
        returned_event_fields["iam_user_name"] = (event.get("detail").get("userIdentity").get("userName", ""))

    # Extract & return the list of new EC2 instance(s) and their parameters
    returned_event_fields["instances_set"] = (event.get("detail").get("responseElements").get("instancesSet"))

    return returned_event_fields


def lambda_handler(event, context):
    """Making a list of tags "resource_tags" to be applied to resources"""
    print(event)
    resource_tags = []
    name = ""
    
    resource_tags.append({"Key": "Cloud", "Value": "AWS"})
    resource_tags.append({"Key": "Service", "Value": "EC2"})
   
    # Parse the passed CloudTrail event and extract pertinent EC2 launch fields
    event_fields = cloudtrail_event_parser(event)

    # Check for IAM User initiated event & get any associated resource tags
    if event_fields.get("iam_user_name"):
        resource_tags.append({"Key": "IAM User Name", "Value": event_fields["iam_user_name"]})

    # Check for event date & time in returned CloudTrail event field & append as tag
    if event_fields.get("resource_date"):
        resource_tags.append({"Key": "Date Created", "Value": event_fields["resource_date"]})

    # Finding name and deciding tags based on the instance name
    if event_fields.get("instances_set"):
        for item in event_fields.get("instances_set").get("items"):
            ec2_instance_id = item.get("instanceId")
            
            for instance in ec2_resource.instances.all():
                if ec2_instance_id == instance.id:
                    for tag in instance.tags:
                        if tag['Key'] == "Name":
                            name = tag['Value']
                            env = name[0:2]
                            os = name[2:3]
                            
                            if env == "NP":
                                resource_tags.append({"Key": "ENV", "Value": "DEV"})                               
                            elif env == "PR":
                                resource_tags.append({"Key": "ENV", "Value": "PROD"})
                                
                            if os == "R":
                                resource_tags.append({"Key": "OS", "Value": "RHEL"})
                            elif os == "U":
                                resource_tags.append({"Key": "OS", "Value": "Ubuntu"})
                            
            #Function call to add tags to ec3 and ebs        
            if set_ec2_instance_attached_vols_tags(ec2_instance_id, resource_tags):
                log.info("'statusCode': 200")
                log.info(f"'Resource ID': {ec2_instance_id}")
                log.info(f"'body': {json.dumps(resource_tags)}")
            else:
                log.info("'statusCode': 500")
                log.info(f"'No tags applied to Resource ID': {ec2_instance_id}")
                log.info(f"'Lambda function name': {context.function_name}")
                log.info(f"'Lambda function version': {context.function_version}")
    else:
        log.info("'statusCode': 200")
        log.info(f"'No Amazon EC2 resources to tag': 'Event ID: {event.get('id')}'")

        #Below is AWS CLI command to create instances to test the function
        # aws ec2 run-instances --image-id <ami id for your region> --instance-type t2.micro --key-name <Keypair_name> --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=NPUxyz}]'

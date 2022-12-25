"""
This Python script is for a lambda function which triggers from an S3 put event. Function extracts information from the event and
creates another copy in another folder in same S3 for the triggering object. It also copies the triggering object to an EFS 
mounted on the lambda function. "list_files_from_path" function lists out the files on given path where we can verify if our 
object is copied.
"""
import logging
import boto3
import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)
s3 = boto3.client('s3')

def lambda_handler(event, context):
    
    # retrieve bucket name and file_key from the S3 event
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    file_key = event['Records'][0]['s3']['object']['key']
    environment=file_key.split('/')[0]
    file_name=file_key.split('/')[-1]
    logger.info('Reading {} from {}'.format(file_key, bucket_name))
    
    # RETRIEVE DATE FROM  S3 EVENT 
    date=event['Records'][0]['eventTime'][:10]
    logger.info('Event triggered on date - {}'.format(date))

# COPY TO SAME BUCKET WITHIN  EXTRACTED DATE PREFIX
    response = s3.copy_object(
        CopySource=bucket_name+"/"+file_key,                           # /Bucket-name/path/filename
        Bucket=bucket_name,                                            # Destination bucket
        Key=environment+"/Archived_objects/"+date+"/"+file_name        # Destination path/filename
)

# COPY KEY/FILE/OBJECT TO EFS
    efs_loci = f"/mnt/mountpath/{file_name}"
    result = s3.download_file(bucket_name , file_key, efs_loci)        #copy to EFS 

    list_files_from_path("/mnt/mountpath/")                             # FUNCTION TO CHECK EFS CONTENTS
    return { 'status_code': 200 }

def list_files_from_path(file_path):                           # Returns the files found at the file_path  :param file_path: string
    found_files = []
    for _, _, f in os.walk(file_path):
        found_files.append(f)
    if found_files:
       print('Files on EFS: ', found_files)
    return found_files
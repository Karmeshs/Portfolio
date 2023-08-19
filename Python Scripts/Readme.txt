Have created a lambda function to purge SQS queues on a schedule using python BOTO 3.
Function checks all SQS queues for a particular tag key value pair and purges if intended tag is present.
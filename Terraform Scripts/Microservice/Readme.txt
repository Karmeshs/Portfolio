This is the terraform script for AWS infrastructure of a microservice. 

Main flow 

Scheduler -> Step function -> Lambda 1 -> SQS 1 -> ECS -> SQS 2 -> Lambda 2 

Lambda 1 - Based on the input from Step function decides on the type of load to be handled by application. Lambda puts a json in the SQS 1 which is polled by app through ecs.

Lambda 2 - Stops the ecs tasks, reads the message json from invoking SQS and sends callback token success/fail to step function
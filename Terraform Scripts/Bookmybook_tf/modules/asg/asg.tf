resource "aws_launch_configuration" "ecs_launch_config" {
  image_id             = "ami-0b73bf5492d98d29b"                                           #"ami-00785f4835c6acf64"
  iam_instance_profile = var.instance_profile                                              #aws_iam_instance_profile.ecs_agent.name
  security_groups      = var.sg_id                                                         #[aws_security_group.ecs_sg.id]
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=my-cluster >> /etc/ecs/ecs.config" ######USE this cluster name my-cluster
  instance_type        = "t2.micro"
}

resource "aws_autoscaling_group" "ecs_asg" {
  name                 = "asg"
  vpc_zone_identifier  = ["subnet-0e1b4de3a392bf3b5"] # [aws_subnet.pub_subnet.id]
  launch_configuration = aws_launch_configuration.ecs_launch_config.name

  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
}
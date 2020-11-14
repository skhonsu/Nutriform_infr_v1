# IAM role
resource "aws_iam_role" "s3-mybucket-role" {
  name               = var.prefix_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

# IAM profile for EC2 instances at startup
resource "aws_iam_instance_profile" "s3-mybucket-role-instanceprofile" {
  name = var.prefix_name
  role = aws_iam_role.s3-mybucket-role.name
}


# Role policy
resource "aws_iam_role_policy" "s3-mybucket-role-policy" {
  name   = var.prefix_name
  role   = aws_iam_role.s3-mybucket-role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "s3:*"
            ],
            "Resource": [
              "arn:aws:s3:::${var.bucket_name}",
              "arn:aws:s3:::${var.bucket_name}/*"
            ]
        }
    ]
}
EOF

}
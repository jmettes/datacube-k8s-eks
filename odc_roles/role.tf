data "aws_caller_identity" "current" {
}

resource "aws_iam_role" "role" {
  count = length(var.roles)
  name  = "${var.cluster_name}-${var.roles[count.index].name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/nodes.${var.cluster_name}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "role_policy" {
  count = length(var.roles)
  name  = "${var.cluster_name}-${var.roles[count.index].name}"
  role  = aws_iam_role.role[count.index].id
  policy = var.roles[count.index].policy
}

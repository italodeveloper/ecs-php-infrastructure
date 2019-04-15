resource "aws_iam_group_policy_attachment" "AmazonECS_FullAccess" {
  group      = "${aws_iam_group.terraform_group.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

resource "aws_iam_group_policy_attachment" "AmazonEC2ContainerRegistryFullAccess" {
  group      = "${aws_iam_group.terraform_group.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_group_policy_attachment" "AmazonEC2ContainerServiceFullAccess" {
  group      = "${aws_iam_group.terraform_group.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerServiceFullAccess"
}

resource "aws_iam_group_policy_attachment" "CodeBuildBasePolicy-builder-us-west-2" {
  group      = "${aws_iam_group.terraform_group.name}"
  policy_arn = "arn:aws:iam::461765898217:policy/service-role/CodeBuildBasePolicy-builder-us-west-2"
}

resource "aws_iam_group" "terraform_group" {
  name = "terraform_group"
  path = "/users/"
}

resource "aws_iam_user" "terraform_user" {
  name = "terraform_user"
}

resource "aws_iam_group_membership" "terraform_team" {
  name = "terraform_team"

  users = [
    "${aws_iam_user.terraform_user.name}",
  ]

  group = "${aws_iam_group.terraform_group.name}"
}

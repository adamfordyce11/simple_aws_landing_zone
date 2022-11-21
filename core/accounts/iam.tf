# TODO: Apply TF code to make this run

resource "aws_iam_policy" "policy" {
  name        = "organization_policy"
  path        = "/"
  description = "AWS Organizations Policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "ManageOrganizations",
          "Effect" : "Allow",
          "Action" : [
            "organizations:CreateOrganization",
            "organizations:EnableAWSServiceAccess",
            "organizations:DisableAWSServiceAccess",
            "organizations:DescribeOrganization",
            "organizations:ListRoots",
            "organizations:ListAccounts",
            "organizations:ListAWSServiceAccessForOrganization"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}
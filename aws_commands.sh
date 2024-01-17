# Step 1: Create IAM Users

aws iam create-user --user-name liam
aws iam create-user --user-name michael

aws iam create-login-profile --user-name liam --password SecurePass1 --no-password-reset-required
aws iam create-login-profile --user-name michael --password StrongPass2 --no-password-reset-required

aws iam create-group --group-name pcg-experts
aws iam add-user-to-group --user-name liam --group-name pcg-experts
aws iam add-user-to-group --user-name michael --group-name pcg-experts

aws sts get-caller-identity

# Step 2: Create an S3 bucket and populate it

aws s3api create-bucket --bucket my-new-unique-bucket-name --region us-east-1

mkdir Management Marketing Technology
touch ./Management/project1.xls ./Management/project2.xls
touch ./Marketing/campaign1.pdf ./Marketing/campaign2.pdf
touch ./Technology/code1.txt ./Technology/code2.txt
touch s3-info.txt

aws s3api put-object --bucket my-new-unique-bucket-name --key Management/project1.xls
aws s3api put-object --bucket my-new-unique-bucket-name --key Management/project2.xls
# ... (repeat for other files)

# Step 3: Create GroupPolicy.json

echo '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowGroupToSeeBucketListInTheConsole",
      "Action": ["s3:ListAllMyBuckets"],
      "Effect": "Allow",
      "Resource": ["arn:aws:s3:::*"]
    }
  ]
}' > GroupPolicy.json

aws iam create-policy --policy-name GroupPolicy --policy-document file://GroupPolicy.json
aws iam attach-group-policy --policy-arn arn:aws:iam::123456789101:policy/GroupPolicy --group-name pcg-experts

# Step 4: Update GroupPolicy.json

echo '{
  "Sid": "AllowRootLevelListingOfBucket",
  "Action": ["s3:ListBucket"],
  "Effect": "Allow",
  "Resource": ["arn:aws:s3:::my-new-unique-bucket-name"],
  "Condition": {
    "StringEquals": {
      "s3:prefix": [""],
      "s3:delimiter": ["/"]
    }
  }
}' >> GroupPolicy.json

aws iam create-policy-version --policy-arn arn:aws:iam::123456789010:policy/GroupPolicy --policy-document file://GroupPolicy.json --set-as-default

# Step 5: Create and attach an inline policy for Michael

aws iam put-user-policy --user-name michael --policy-name MichaelPolicy --policy-document '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowListBucketIfSpecificPrefixIsIncludedInRequest",
      "Action": ["s3:ListBucket"],
      "Effect": "Allow",
      "Resource": ["arn:aws:s3:::my-new-unique-bucket-name"],
      "Condition": {
        "StringLike": {"s3:prefix": ["Technology/*"]}
      }
    },
    {
      "Sid": "AllowUserToReadWriteObjectDataInTechnologyFolder",
      "Action": ["S3:ListObject", "s3:GetObject", "s3:PutObject"],
      "Effect": "Allow",
      "Resource": ["arn:aws:s3:::my-new-unique-bucket-name/Technology/*"]
    }
  ]
}'

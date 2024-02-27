# Securing AWS: Practical IAM, Policies, and Role Management for Resource Access Control

## AWS Identity and Access Management (IAM) Overview

In AWS, identities play a crucial role in controlling access to the AWS account and its associated services and resources. Let's explore the key elements:

1. **IAM Users:**
   - IAM users, whether individuals or applications, possess specific permissions for accessing resources.
   - Long-term credentials such as passwords and access keys provide permanent access to designated resources.

2. **Groups:**
   - Groups are logical sets of users, simplifying permission management for a defined set of users.
   - For instance, creating a billing group facilitates cost and usage monitoring for the accounting department.

3. **Roles:**
   - Roles are identity entities with specific permissions but are not directly associated with a user.
   - Temporary in nature, roles are assumed by users for performing specific tasks.
   - Cross-account access is a common use case, enabling users from one account to access resources in another account.

4. **Relationships Between Identities:**
   - The diagram below illustrates the relationships among groups, users, and roles.
   - Policies can be attached to identities, and users can inherit group policies.

   ![Identities Diagram](https://github.com/DimitryZH/securing-AWS/assets/146372946/7e1c69d2-5793-43cd-8ecc-8e8761e84138) 

## IAM Policies and Authentication

5. **IAM Policies:**
   - IAM Policies are documents specifying who, by whom, and under what conditions resources can be accessed.
   - Key terms include:
      - **Sid (Statement ID):** An optional identifier for policy statements.
      - **Principal:** The entity (person or role) authorized to request operations on AWS resources.

6. **Authentication Methods:**
   - IAM users authenticate using account ID, username, and passwords. Using Multi-Factor Authentication (MFA) is recommended.
   - Federated users leverage identity providers (e.g., Amazon, Facebook) for AWS login.
   - While logging in as the root user is discouraged, best practices include using MFA and temporary credentials for enhanced security.

7. **Request Context:**
   - When making AWS API calls, the request context includes the principal (request initiator), environmental data (e.g., IP address), and resource data (e.g., tags).

8. **Resource Actions:**
   - Resources represent objects within a service (e.g., an S3 bucket).
   - Actions define what can be done with a resource, with the type of action specified by the resource (e.g., S3's CreateBucket operation).

### Implementing

### Part 1: Mastering AWS Identities and Policies

## Step 1: Create IAM Users

1. Create two IAM users, Liam and Michael, with passwords and no password reset required.
2. Establish a group named "pcg-experts" and add Liam and Michael to this group.

## Step 2: Set Up an S3 Bucket with Folders and Files

1. Create an S3 bucket with a unique name, e.g., "my-new-unique-bucket-name."
2. Prepare folders and files locally (e.g., Management, Marketing, Technology) and upload them to the S3 bucket.

## Step 3: Create Initial Policy

1. Create a policy allowing the group to list all buckets at the root of the AWS account.
2. Save the policy as "GroupPolicy.json" and attach it to the group.

## Step 4: Update Group Policy for Root-Level Access

1. Add a statement to the GroupPolicy allowing users to list folders and objects at the root of the S3 bucket.
2. Update the policy, version it, and set it as the default policy.

## Step 5: Define Policy for User-Specific Access (e.g., Michael)

1. Create an inline policy for Michael, a developer, allowing him to list, get, and put objects in the Technology folder.
2. Save the policy as "MichaelPolicy.json" and apply it to Michael's IAM user.

### Notes:
- Replace placeholder names and passwords with actual ones.
- Adjust the S3 bucket name and folder structure as needed.
- Test the policies using the AWS Console.

## Part 1. Summary 

**[AWS_commands.sh](https://github.com/DimitryZH/securing-AWS/blob/main/aws_commands.sh):** This script contains essential AWS CLI commands corresponding to the steps outlined above. Execute these commands in your terminal to automate the process.

# Part 2: Securely Access Resources with IAM Service Roles

When we access a resource as a user, our credentials such as passwords and access keys are used to confirm we can use that resource. However, there are instances where we need to access resources belonging to another user or where a resource has to access another resource. This is accomplished with roles which use temporary credentials to provide access. In this part, we will configure an EC2 instance with a service role to securely access an S3 bucket.

## Setting Up Our Working Environment with Cloudformation.

We will create the environment with AWS Cloudformation, which is a service that creates and configures AWS resources. Cloudformation uses a template that describes all the resources that we want to setup. Our environment includes a Virtual Private Cloud (VPC), and EC2 Linux server instance, and an S3 bucket. Setting up these resources with either the AWS console or CLI can take time and effort. We will use Cloudformation to create our  environment rapidly and efficiently so we can  manage access to AWS resources.
 
1. Open the Cloudformation console.
2. Choose Create stack.
3. Upload a Cloudformation template.
   Use this file: ![cloudformation-create-environment.yaml](https://github.com/DimitryZH/AWS-IAM/blob/main/cloudformation-create-environment.yaml)
5. Name the stack and S3 bucket.
6. Accept default values and advance to the next screen.
7. Review the stack details before creating the stack.
8. Choose Submit to create the stack.

![Cloudformation-resources](https://github.com/DimitryZH/AWS-IAM/assets/146372946/868533dd-25fb-4308-88e7-98e41e8c4863)
 The environment diagram  we created from Cloudformation designer tab.
 
## Creating Service Roles
AWS Identities provide access to AWS resources. IAM users are identities that are tied to an individual user and have long term credentials in the form of passwords and access keys. IAM roles are another type of identity but have temporary credentials that provide permission to access resources based on an attached policy.

1. Open the IAM console by using the search bar.
2. Choose Roles to create a role.
3. Choose Create role.
4. Choose AWS Service to create the role.
5. Select EC2 under Common use cases and choose Next.
6. Write a policy using provided JSON file ).
7. 
8. Attach a role to a policy
Review and create the policy.
## Creating Service Roles


- Modify a policy.
- Attach a role to a policy.
...

## Testing the Service Role

Test the service role by connecting to EC2 instance in the stack we created earlier. Like the S3 bucket, we can find the instance id from the Cloudformation output. Navigate to the EC2 Console and select the instance, choose Connect.

1. Choose the EC2 instance by the instance ID and Connect.
2. Use EC2 Instance Connect to open a terminal.
3. List the contents of the S3 bucket. Verify that the EC2 instance lacks S3 access:

```bash
aws s3 ls s3://pcg-s3-service-role-tutorial
# Unable to locate credentials. You can configure credentials by running "aws configure".
```
As expected, the instance doesn’t have permission to access S3. We can fix that by adding the service role to the instance. Go back to the EC2 console and choose the server’s Instance ID to open the summary of details about the instance.
In the summary, we can see that the IAM Role is blank.
We can fix that by choosing Actions > Security > Modify IAM Role.
In the Modify IAM Role screen, select the role we created previously, then choose Update IAM role.
Let's test the role by going back to the terminal and listing the contents of the bucket again.
```bash
aws s3 ls s3://pcg-s3-service-role-tutorial
```
No errors! But we haven’t put anything in the bucket yet. Let’s try that next by creating a file and copying it to the bucket.

4. Test uploading and downloading files.
```bash
echo "Creating roles" > file.txt
aws s3 cp file.txt s3://pcg-s3-service-role-tutorial
# upload: ./file.txt to s3://pcg-s3-service-role-tutorial/file.txt
aws s3 ls s3://pcg-s3-service-role-tutorial
```
 For completeness, we’ll download the file into another directory and display the file contents.
```bash
mkdir download
aws s3 cp s3://pcg-s3-service-role-tutorial/file.txt ./download/
# download: s3://pcg-s3-service-role-tutorial/file.txt to download/file.txt
cat ./download/file.txt
```
You will see: "Creating roles". 
## Clean Up

In the Cloudformation console, select and delete the stack.

## Part 2. Summary 

The focus of this tutorial is how to securely access resources with roles and temporary credentials. We created a role for a service and applied a policy that allowed it to access another resource. In this case, we attached a role to an EC2 instance that lets it access an S3 bucket. We can edit a role and add other statements, such as providing access to a relational database, for instance. The key is to use roles to enable actions without exposing user credentials by placing them in service, such as EC2.

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

   ![Identities Diagram](https://github.com/DimitryZH/securing-AWS/assets/146372946/7e1c69d2-5793-43cd-8ecc-8e8761e84138) <!-- Replace this URL with the actual diagram URL -->

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

## Implementing

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

**[AWS_commands.sh](https://github.com/DimitryZH/securing-AWS/blob/main/aws_commands.sh):** This script contains essential AWS CLI commands corresponding to the steps outlined above. Execute these commands in your terminal to automate the process.

### Part 2: Practical Cloudformation Setup and Role Management

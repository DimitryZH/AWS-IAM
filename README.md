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

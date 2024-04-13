### AWS Certified Solutions Architect Associate 3 ###
### Read the AWS Well Architected Framework Whitepaper

# Chapter 3: IAM
IAM is Universal
# Securing Root Account
    - Enable MFA
    - Create Admin group with appropriate permissions, and use users from the Admin group instead of root account
# Best Practices
    - Setup password rotation policies
    - Minimal required permissions policices
# IAM Federation
    It is possible to sync IAM users with Active Directory using SAML,
    Or OpenID Connect to use Google or Salesforce as Identity Provider.
# Explicit Deny
    If an IAM Policy explicitly denies a certian action, It will override any "Allow" granted to a user for that action. 
    By default all Actions are implicitly denied.



# Chapter 4: S3
S3 is  universal namespace

S3 is object based, objects consist of
    Key:Value pairs where key is the name of the object (filename) and value is the data of the object. 
    VersionID (important for versioning).
    Metadata.
    Subresources:
        Access Contol Lists (ACLs/)
        Torrent.
    File size can range from 0 Bytes to 5TB.
    Unlimited Storage

S3 Features:
    Tiered Storage Available
    Lifecycle Management
    Versioning
    Encryption
    MFA Delete
    Securing using ACLs and Bucker Policies. 

S3 Guarantees from Amazon:
    Built for 99.99% availablity.
    Amazon Guaranteee 99.9% availability
    Amazon guarantees 99.999999..% (11 9s) durability. 

Securing S3 Buckets:
    Object ACLs: Access control list work on an individual object level.
    Bucket Policies: Bucket policies work on an entire bucket level.

S3 Data consistency:
    Strong Read-After-Write Consistencty.
    Strong consistency for list operations.
    <!-- Read after Write consistency for PUTS of new Objects.
    Eventual Consistency for overwrite PUTS and DELETES. -->

Static Content / Websites:
    S3 scales automatically and can be used to host static content and websites, useful when the traffic is unpredictable. 

Versioning Objects in S3:
    All versions of an objects are stored in S3, Even if you delete an object.
    Once enabled, cannot be disabled - only suspended.
    Lifecycle Rules integration is possible.
    MFA supported.

S3 Storage Classes:
    S3 Standard: 99.99% Availability.
                    99.999999999 Durability.
                    Stored redundantly across multiple devices in multiple facilties
                    designed to sustain the loss of 2 facilites concurrently
    S3 Standard IA: For Infrequently Accessed data that requires rapid access when needed, 
            Lower fee than S3 but charges a retrieval fee.
    S3 One Zone IA: Same as IA but without multiple availability zone data resilience and lower cost.
    S3 Intellegent Tiering: Optimizes costs by automatically moving data to the most cost effective access tier.
    S3 Glacier - Useful for archiving, retrieval fee applied:
        Instant Retrieval: Long term archiving with instant retrieval time.
        Flexible Retrieval: low cost, Retrieval times from minutes up  to 12 hours.
        Deep Archive: Lowest cost, standard retrieval times of 12 hours, bulk retrieval times upto 48 hours.

Lifecycle Management:
    Automates moving objects between storage tiers.
    Can be used in conjuction with versioning. 
    Can be applied to current and previous versions.

S3 Object Lock and Glacier Vault lock:
    S3 Object Lock: Used to store objects using a write once, ready many (WORM) model.
    S3 Object can be applied on individual objects or applied across the bucket.
    S3 Object Lock comes in two modes:
        Compliance Mode: A protected object version can't be overwritten or deleted by any user, including root.
        Governance Mode: Users can't overwrite or delete an object unless they have special permissions.

    S3 Glacier Vault Lock:
        Allows easy deployment and enforcement of compliance controls for S3 Glacier Vaults.
        You can specifiy controls such as WORM, in a vault lock policy and lock the policy from future edits.
        Once locked, the policy can no longer be changed.

Encrypting S3 Objects:
    Encryption in Transit: SSL\TLS, HTTPS.
    Client-Side Encryption: The client encrypts the files before uploading to S3.
    Encryption at Rest - Server Side Encryption options (SSE):
        SSE-S3 (AES 256-bit)
        SSE-KMS (KMS provided encryption key)
        SSE-C (Client provided encryption key)
    Enforcing Encryption with a Bucket policy:
        A bucket policy can deny all PUT requests that don't include the x-amz-server-side-encryption parameter in the request header.

S3 Performance optimization:
    Prefixes:
        A prefix is the folder/subfolder path within the S3 backets to your S3 Object.
        There is a limit of requests per prefix:
            3,500 PUT/COPY/POST/DELETE
            5,500 GET/HEAD
        By spereading data and reads across different prefixes you can increase performance.
    SSE-KMS Encryption limits:
        Uploading/Downloading will count towards the KMS limit quota.
        Limits are region-specific, usually 5,500 10,000 or 30,000 requests per second.
        Can not request quota increase for KMS.
    Uploading/Downloading:
        Use multipart uploads to increase upload performance - upload parallization.
            Recommended for any file over 100MB, Enforced for any file over 5GB.
        Use S3 byte-range fetches to increase performance when downloading files from S3.

S3 Replication:
    You can replicate objects from one bucket to another.
    Delete markers are not replicated by default.
    Objects in an existing bucket are not replicated Automatically.
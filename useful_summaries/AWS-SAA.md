### AWS Certified Solutions Architect Associate 3 ###
### Read the AWS Well Architected Framework Whitepaper

# Chapter 3: IAM
IAM is Universal
<!-- # Securing Root Account -->
    - Enable MFA
    - Create Admin group with appropriate permissions, and use users from the Admin group instead of root account
<!-- # Best Practices -->
    - Setup password rotation policies
    - Minimal required permissions policices
<!-- # IAM Federation -->
    It is possible to sync IAM users with Active Directory using SAML,
    Or OpenID Connect to use Google or Salesforce as Identity Provider.
<!-- # Explicit Deny -->
    If an IAM Policy explicitly denies a certian action, It will override any "Allow" granted to a user for that action. 
    By default all Actions are implicitly denied.



# Chapter 4: S3
S3 is  universal namespace

<!-- S3 is object based, objects consist of -->
    Key:Value pairs where key is the name of the object (filename) and value is the data of the object. 
    VersionID (important for versioning).
    Metadata.
    Subresources:
        Access Contol Lists (ACLs/)
        Torrent.
    File size can range from 0 Bytes to 5TB.
    Unlimited Storage

<!-- S3 Features: -->
    Tiered Storage Available
    Lifecycle Management
    Versioning
    Encryption
    MFA Delete
    Securing using ACLs and Bucker Policies. 

<!-- S3 Guarantees from Amazon: -->
    Built for 99.99% availablity.
    Amazon Guaranteee 99.9% availability
    Amazon guarantees 99.999999..% (11 9s) durability. 

<!-- Securing S3 Buckets: -->
    Object ACLs: Access control list work on an individual object level.
    Bucket Policies: Bucket policies work on an entire bucket level.

<!-- S3 Data consistency: -->
    Strong Read-After-Write Consistencty.
    Strong consistency for list operations.

<!-- Static Content / Websites: -->
    S3 scales automatically and can be used to host static content and websites, useful when the traffic is unpredictable. 

<!-- Versioning Objects in S3: -->
    All versions of an objects are stored in S3, Even if you delete an object.
    Once enabled, cannot be disabled - only suspended.
    Lifecycle Rules integration is possible.
    MFA supported.

<!-- S3 Storage Classes: -->
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

<!-- Lifecycle Management: -->
    Automates moving objects between storage tiers.
    Can be used in conjuction with versioning. 
    Can be applied to current and previous versions.

<!-- S3 Object Lock and Glacier Vault lock: -->
    S3 Object Lock: Used to store objects using a write once, ready many (WORM) model.
       can be applied on individual objects or applied across the bucket.
    S3 Object Lock comes in two modes:
        Compliance Mode: A protected object version can't be overwritten or deleted by any user, including root.
        Governance Mode: Users can't overwrite or delete an object unless they have special permissions.

    S3 Glacier Vault Lock:
        Allows easy deployment and enforcement of compliance controls for S3 Glacier Vaults.
        You can specifiy controls such as WORM, in a vault lock policy and lock the policy from future edits.
        Once locked, the policy can no longer be changed.

<!-- Encrypting S3 Objects: -->
    Encryption in Transit: SSL\TLS, HTTPS.
    Client-Side Encryption: The client encrypts the files before uploading to S3.
    Encryption at Rest - Server Side Encryption options (SSE):
        SSE-S3 (AES 256-bit)
        SSE-KMS (KMS provided encryption key)
        SSE-C (Client provided encryption key)
    Enforcing Encryption with a Bucket policy:
        A bucket policy can deny all PUT requests that don't include the x-amz-server-side-encryption parameter in the request header.

<!-- S3 Performance optimization: -->
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

<!-- S3 Replication: -->
    You can replicate objects from one bucket to another.
    Delete markers are not replicated by default.
    Objects in an existing bucket are not replicated Automatically.


# Chapter 5: EC2
<!-- EC2 Instance types: -->
    On-Demand: Pay per the hour/second, great for flexibility.
    Reserved: Reserved capacity for 1 or 3 years, Upto 72% discount on the hourly charge.
                Great if you requirements are fixed and well known.
    Spot: Purchase unused capacity at upto 90% discount. 
            Prices flactuate with supply and demand, good for applications with flexible start and end times.
    Dedicated: A physical EC2 server dedicated for the user.most expensive.
               Giveaways:  compliance requirements and meeting special licensing requirements

<!-- Roles: -->
    The Preferred Option: using roles doesn't store credentials locally, so it is more secure.
    Polices: used to control a role's permissions.
    Updates: updating role's policies take immidiate effect.
    Attaching: roles can be attached and detached from EC2 Instances without stopping the instances.

<!-- EC2 Userdata:  -->
    Basically user defined bootstrap script for the EC2 instane.
<!-- EC2 Metadata:  -->
    data about the EC2 Instance, such as Instance ID, IP address, hostname etc. 

<!-- Network devices in EC2: -->
    ENI: Basic network interface, low cost.
    Enhanced Networking: For speeds between 10Gbps and 100Gbps, used for reliable high-throutput.
                            Comes in 2 Flavours, Elastic Network adapter for speeds upto 100GB (ENA is preferred).
                            And Intel Virtual Funcation (VF) Interface which supports upto 10Gbps (legacy).
    EFA: Elastic Fabric Adapter is used to accelerate High Performance Computing and Machine Learning applications. can bypass OS to reduce latency.

<!-- Optimizing EC2 with Placement Groups -->
    Cluster Placement Groups:
        Groups Instances within a single availability zone, boosts network performance. - available only for certain typs of EC2 Instances (Compute,GPU,Memmory and Storage optimizied)
    Spread Placement Groups:
        Group of instances that each are placed on distinct underlying hardware. good for individual critical EC2 instances.
    Partitinon Placement Groups:
        Each partition placement group has its own "rack", with a power source and network infrastracture.
        Giveaways: HDFS, HBASE, Cassandra.

    Tips:
        AWS recommends homogenous instances within a cluster placement group.
        You can't merge instance groups;.
        An existing EC2 Instance can be moved into a placement group but it first must be stopped.
            It is done using the AWS CLI or CDK, not via the AWS console.
    
<!-- Spot Fleets  -->
    Spot Fleets:
        A collection of Spot instances and (optionally) On-Demand Instances.
        Spot Fleets will try to match the target capacity with the defined price restraints.
        Launch Pools:
            We can set up different launch pools and define thing like instance type, os, and AZ.
        Stategies:
            capacityOpimized: Spot Instances will come from the pool with optimal capacity for number of instances launching.
            diversified: Spot Instances are distributed across all pools.
            lowestPrice (Default): The Spot Instances will come from the poll with the lowest price.
            InstancePoolsToUseCount: The Spot Instances are distributed across a specified nunmber of pools - can be only used with lowestPrice.

    Spot Block:
        You can block stop Spot Instances from terminating using a Spot Block.

<!-- Outposts -->
AWS datacenter deployed on-premise, Useful for Hybrid Cloud.
    Outposts Rack: Available starting with a single 42U rack, up to 96 racks.
        Provides AWS Compute, Storage, database and other services locally.
    Outposts Servers: Individual servers in 1U or 2U form factor.
        Useful for small space requirements. provides local compute and networking.


# EBS and EFS
!!!EBS:
<!-- IOPS VS Throughput  -->
    IOPS:
        - Measures R/W Operations per second.
        - Important metric for low latency, high transaction count workloads.
        - IOPS SSDs are io1 (legacy) and io2 (same price as io1 but better)
    Throughput:
        - Measures number of bits read or written per seconds (MB/s)
        - Important metric for large datasets, large I/O sizes, complex queries.
        - HDD (st1)

    SSD Volumes:
        - gp2/gp3: general purpose, suitable for boot disks and g eneral applications. upto 16,000 IOPS
        - io1/io2: suitable for OLTP and latency-sensitive applications upto 64,000 IOPS. 99.9/99.999% durability.

    HDD Volumes:
        - st1: Throughput optimized HDD, suitable for big data, data warehouses and ETL, upto 500MB/s.
        - sc1: cold storage, for infrequently accessed data, lowest cost.
        * both provied 99.9% durability, neither can be used as boot disks.
    
<!-- Volumes and Snapshots -->
    Volumes exist on EBS and will always be in the same AZ as the EC2 instance.
    Snapshots exist on S3, and are incremental in nature.
    For consistent snapshots, stop the instance and detach the volume.
    Snapshots can be shared between AWS accounts as well as between regions, but must be copied to the target region first.
    EBS Volumes can be resized on the fly, as well as changing the volume types.

<!-- EBS Encryption -->
    Encrypted Volumes:
    - Data at rest is encrypted inside the volume.
    - All data in flight moving between the instance and the volume is encrypted.
    - All snapshots are encrypted.
    - All volumes created from the snapshot are encrypted.
    - Encryption and decryption are handled transparently (no user intervention is required).
    - Encryption has minimal impact on latency.

    Encrypt an existing unencrypted Volume:
    1. Create a snapshot of the unencrypted root device volume
    2. Create a copy of the snapshot and select the encrypt option
    3. Create an AMI from the encrypted snapshot
    4. Use the AMI to launch new encrypted instances

<!-- EBS Hibernation -->
    - Preserves the RAM to the EBS.
    - Allow faster boot times.
    - Instance RAM must be less than 150GB.
    - Supported in GP, Compute, Memory and Storage Optimized groups.
    - Availabel for windows, Amazon Linux 2 AMI and Ubuntu.
    - Instances can't be hibernated for more than 60 days.

!!! EFS:
<!-- EFS Overview -->
    - Basically managed NFSv4 Service
    - Only pay for the storage you use (No pre-provisioning)
    - Can scale up to petabytes
    - Can handle thousands of concurrent connections
    - Data is stored across multiple AZs within a region
    - Read-after-write consistency

    Giveaways: Highly scalabe shared storage using nfs.

!!! FSx:
<!-- FSx for Windows -->
    - A managed windows server that runs Windows Server Message Block (SMB) based file services
    - Designed for Windows
    - Supports AD users, acls, groups and security polices, along with Distributed File System (DFS) namespaces and replication
    - Used as a centralized storage for windows based applicatiosn, such as SharePoint, Microsoft SQL Server, IIS Web Server etc..

<!-- FSx for Lustre -->
    - Used for high-speed, high-capacity distributed storage useful for HPC, AI and ML.
    - Can store files on S3
    - Can process massive datasets at 100's of GBs\s of throughput, millions of IOPS and sub-millisecond latencies.

<!-- AMI's -->
Can be based on:
    - Region
    - OS
    - Architecture (32/64bit)
    - Launch permissions
    - Storage for the root device (root device volume)

All AMIs are categorized as either backed by:
    1. EBS: The root device is launched from the AMI is an EBS volume created from an EBS snapshot
    2. Insttance Store: The root device for an instance launched from the AMI is an instance store volume created from a template stored in S3.

Instance Stores:
    - sometimes caleld ephemeral storage.
    - Instance store volumes cannot be stopped, if the host fails the data is lost.
    - Can be reboot without losing data
    * basically RAM filesystem
EBS-backed instacnes
    - EBS-backed instances can be stopped 
    - Can be reboot without losing data
    - Can be configured to keep root device volume when terminated

<!-- AWS Backup -->
    Consolidation: Can backup AWS services suchg as EC2,EBS,EFS,FSX (Windows\Lustre) and AWS Storage Gateway.
    Organizations: Can be used with AWS Organizations to back up AWS services across multiple AWS accoutns.
    Benefits: Allows centralized control and automation of back ups, definition of lifecycle policies for data.
              Improves compliance as backup policies can be enforced, ensuring backups are encrypted and audit them once complete.


# DATABASES COMPARSION
<!-- Relational databases vs NoSQL (MongoDB) -->
<!-- Database -->
MongoDB: Here, a database is a container for collections and can host multiple collections.

Relational Database: Similarly, a database is a container for tables. It can contain one or more tables.
<!-- Collections vs. Tables -->
MongoDB Collections: Collections in MongoDB are analogous to tables in relational databases. However, collections do not enforce a strict schema.

Tables: In relational databases, tables are where the data is stored. Unlike MongoDB, each table in a relational database follows a strict schema, defining the columns and types of data that can be stored in each row.
<!-- Document vs. Row/Record -->
    MongoDB Document: In MongoDB, data is stored in documents, which are BSON (Binary JSON) formatted. A document can contain nested documents and arrays.

    Row/Record: In relational databases, data is stored in rows within a table. Each row corresponds to a single record and must conform to the schema defined by the table.

<!-- Field vs. Column -->
    MongoDB Field: Fields are the individual data points within a document.

    Column: In relational databases, columns are the equivalent of fields in MongoDB. Each column in a table is designed to hold a specific type of data, like text, date, number, etc.

<!-- Primary Key -->
    MongoDB: MongoDB uses an _id field as a primary key to uniquely identify documents within a collection.

    Relational Database: Relational databases also use a primary key concept to uniquely identify each row within a table. A primary key can consist of one or more columns.

<!-- Foreign Key -->
    MongoDB: MongoDB does not have built-in support for foreign keys. Relationships can be modeled using embedded documents or references, but these are not enforced by the database.

    Relational Database: A foreign key is a column or a group of columns in a table that uniquely identifies a row in another table. Foreign keys are fundamental in establishing relationships between tables.

<!-- Relationship -->
    MongoDB: Relationships between collections are typically modeled using references (manual linking between documents) or embedded documents.

        Relational Database: Relationships are a core concept. There are primarily three types:
    One-to-One: A row in Table A is related to one, and only one, row in Table B.
    One-to-Many: A row in Table A can be related to many rows in Table B.
    Many-to-Many: Many rows in Table A can relate to many rows in Table B. This is usually implemented using a join table.
<!-- Joins -->
    MongoDB: To perform operations that involve multiple collections, you typically use the $lookup aggregation pipeline stage to perform a join-like operation.

    Relational Database: Joins are used to combine rows from two or more tables based on a related column between them. There are various types of joins, like INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL JOIN, each serving different use cases.
<!-- Indexes -->
    Both MongoDB and Relational Databases: Indexes are used to speed up the search queries by allowing the database to find data without scanning every document or row in the database. Both MongoDB and relational databases support indexes, though the implementation details and capabilities may vary.


# AWS DATABASES
<!-- OLTP VS OLAP -->
    OLTP: Manages and processes high volumes of transactions in real-time. Optimized for operational tasks requiring quick data manipulation.

    OLAP: Designed for complex data analysis and queries, supporting decision-making. Optimized for analyzing and aggregating large datasets.

<!-- RDS -->
    Transactional database (OLTP), not suitable for OLAP workloads.
    Database Types: SQL Server, Oracle, MySQL, PostgreSQL, MariaDB and Amazon Aurora.

    MULTI-AZ RDS: AWS creates an exact (standby) copy of the primary database in another AZ, provding redundency using DNS fail-over. only 1 database is active at a time.

    Read Replicas: used to scale performance by creating a Read Replica of the main DB,
    can be deployed in the same AZ or even in a different region. Read Replicas can be promoted
    to become standalone database but that will break the link between the main DB and the read replica.

<!-- Amazon Aurora -->
    Aurora is a relational database that is compatible with MySQL and PostgreSQL while being much faster and cost effective, developed by AWS. storage scales automatically.

    Features:
    - storage range 10GB to 128TB in 10GB increments.
    - Compute resources can scale up to 96vCPUs and 768GB RAM.
    - 2 copies of your data are contained in each AZ, with a min of 3 AZ's, 6 copies total.
    - Aurora Snapshots can be shared with other AWS accounts.
    - 3 Typess for replicas available: Aurora replicas (15 max concurrent), MySQL replicas and PostgreSQL replicas (5 Max for each).
      Automated failover is only available with Aurora replicas.
    - Aurora has automated backups enabled by default.
    - Use Aurora Serverless for simple, cost-effective and scalable solution for intermittent or unpredictable workloads
    - Aurora is designed to self handle loss of upto 2 copies of data without affecting write availability and 3 copies without affecting read availability.
    - Aurora storage is self healing and Data blocks are scanned and repaired automatically.
    - Aurora replicas are in the same region, while Aurora MySQL replicas can be Cross-Region.

<!-- DynamoDB -->
    NoSQL DB by AWS.

    DynamoDB DAX: In-memory cache for DynamoDB for massive performance improvment, sits between the application and the database.
    
    Facts:
    - Stored on SSD storage.
    - Spread across 3 geographically distinct datacenters.
    - Eventually consistent reads by default for better performance (upto ~1 second)
    - Strongly consistent reads for better accuracy.
    - Encryption at rest KMS.
    - Site-to-site VPN.
    - Direct Connect (DX).
    - IAM policies and roles for fine-grained access.
    - CloudWatch and CloudTrail.

    DynamoDB Transactions (ACID)
        Atomic: All changes are either performed successfuly or not at all.
        Consistent: Data must be consistent before and after the transaction.
        Isolated: no other process can change the data while the transaction is running.
        Durable: Changes made by a transaction must persist. 
        * Basically all or nothing

        useful for building applications that require coordinated inserts, deletes or updates to multiple itmes as part of a single logical business operation.

        Giveaways: Question mentions ACID.

    DynamoDB Backups:
        On-Demand Backup and Restore:
        - Full backups at any time
        - No impact on table performance or availability
        - Consistent within seconds and retained until deleted
        - Same region as source table
        
        Point-in-Time Recovery (PITR)
        - Protects against accidental R/W
        - Restore to any point in the last 35 days
        - Incremental backups
        - not enabled by default
        - Newest possible backup is 5 min in the past

    DynamoDB streams:
        Time-ordered sequence (store) of item-level changes in a table, stored for 24 Hours, can be combined with lambda.

    Global Tables:
        By using the underlying DDB streams tech, Global Tables can sync tables globally for multi-region redundancy or DR, latency usually under 1sec.
        Provides Multi-Master, Multi-Region Replication. good for globally distributed application.

<!-- Amazon DocumentDB -->
    Literally MongoDB on the cloud. usefull for moving MongoDB based application to AWS without refactoring.

<!-- Cassandra and Amazon Keyspaces-->
    Cassandra is distirbuted NoSQL database for big data solutions.
    AWS Keyspaces is basically an AWS Managed Cassandra, serverless.

<!-- Amazon Neptune -->
    An AWS managed Graph Database

    Graph databases are useful for:
    - Building connections between identities
    - Build Knowledge Graph Applications
    - Detect Fraud Patterns
    - Security Graphs to improve IT security.

    * Usually a distractor, only relevant when talking about Graph Databases.

<!-- Amazon QLDB -->
    Quantum Ledger Database, A ledger database (think blockchain). 
    * Usuaslly a distractor, only relvant in regards to immutable databases.

<!-- Amazon Timestream -->
    A serverless, fully managed database for time-series data. can be used to analyze trillions of events per day upto 1,000 faster and 90% cheaper than tradition databases.
    * Giveaways: Question about storign large amount of time-series data for analysis

# VPC 
<!-- Overview -->
    VPC is basically a logical data center in AWS.
    Consists of internet gateways, virtual private gateways, route tables , NACLs, subnets and security groups.
    1 Subnet is always in 1 AZ.

<!-- NAT Gateways -->
    Network Address Translation gateway can be used to allow instances in a private subnet to connect to the internet or AWS services while preventing the internet from initiating a connection with those instances.

    Facts:
        - Redundant inside the AZ
        - Starts at 5Gbps and scales upto 45Gbps
        - No need to patch
        - Not associated with security groups
        - Automatically assigned a public IP address

    Instructions: Create a NAT Gateway in your public subnet, create a route from the NAT to the Internet, and make sure the private subnet has a route to the NAT gateway.

<!-- Security Groups -->
    The last line of defences,  sits within a subnet and act as a virtual firewall for an EC2 instance.
    When debugging internet connectivty start with Routing Tables > ACL's > Security groups.

    Stateful: SG's are stateful, if you send a request from your instance then the response traffic is allowed to flow in regardless of inbound security group rules.

<!-- Network ACLs -->
    The first line of defense, stateless if you sned a request then the response traffic is not allowed unless specified in the ACL - Remember to open Ephemeral ports.

    Default Network ACLs: VPC's come with a default network ACL which allow all inbound and outbout traffic.
    Custom Network ACLs: by default Custom NACLs deny all in\out traffic.
    Subnet Associations: Each subnet in the VPC must be associated with a NACL, if not explicitly associated then it is automatically associated with the default NACL.
    Blocking IP addresses: IP blocks can only be done by NACLs and not SGs.
    A NACL can be associated with multiple subnets, however a subnet can only be associated with a single NACL at a time. 

<!-- VPC Endpoints -->
    Basically AWS internal NAT, allows to communicate with AWS services without leaving the AWS network or requireing public IP.
    Allow communication between instances in the VPC and services without availability risks or bandwith constraints.

    2 Types of VPC endpoints:
        Gateway Endspoints: Support S3 and DynamoDB Similar to a NAT
        Interface Endpoints: an ENI with a private IP address that serves as an entrypoint for traffic to a supported service. Supports alot of AWS services. 

<!-- VPC Peering -->
    Allows you to connect 1 VPC with a nother via a direct network route using private IP addresses

    You can peer between regions.
    No overlapping CIDR address ranges.
    
    * Transitive peering is not supported - VPC A cannot talk to VPC C through VPC B, even if VPC's A and C are both connected to VPC B.

<!-- AWS PrivateLink -->
    Allows you to peer VPCs to 1000s of customer VPCs.
    Doesn't require VPC peering; no RTs, NAT gateways, IGWs etc.
    Requires a Network Load Balancer on the service VPC and an ENI on the customer VPC.

<!-- AWS VPN CloudHub -->
    Allows you to connect multiple VPN connections together.
    Low cost and easy to manage.
    Basically Aggregates VPN connections.

<!-- Direct Connect -->
    Directly (Physically) connect your datacenter to AWS.
    - Useful for high-throughput workloads.
    - Helplful when a stable, secure, reliable connection is required.

<!-- Transit Gateway -->
    Allows Transitive peering between thousands of VPCs and on-premises datacenters.
    - works on a hub-and-spoke model.
    - Works on a regional basis but you can have it across multiple regions.
    - Can be used across multiple AWS accounts using RAM (Resource Access Manager)
    - Can use route tables to limit how VPCs talk to each other.
    - Works with Direct Connect, VPN connections.
    - Supports IP multicast (not supported by any other AWS service)
    * Giveaway: Question asks about simplifying network topology.

<!-- AWS Wavelength -->
    Embeds AWS compute and storage services within 5G networks.
    Using 5G to increase application speeds at edge locations using mobile networks.
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
        - io2 Block Express: Highest performance ssd.
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


# Route53
<!-- Top-Level Domain name -->
    Amazon.com
    bbc.co.uk
    Top level domain name is the last word - .com, .uk in our examples.
    Second level domain name is the second level domain name (.co) - optional.

<!-- Common DNS Record Types -->
    SOA Record: Start of Authority, contains:
    - Name of server that supplied the data for the zone.
    - Administrator of the zone.
    - Current version of data file.
    - Default TTL on resource records (TTL on DNS cache).

    A Record: used by a computer to translate domaine name to an IP address.

    NS Record: Name Server record, where the DNS information is stored.

    CNAME:Canonical name can be used to resolve one domain name to another, cannot be used for naked domain names (zone apex record) such as khovic.com, must be used with something like m.khovic.com

    Alias Record: AWS only version of CNAME record and used to map resource record sets in our hosted zone to LBs CloudFront distros or S3 bucket websites, Can be used for a naked domain name. - preferable to CNAME almost always.

<!-- Routing Policies -->
    Health checks: 
    - We can set health checks on individual record sets.
    - If a record set fails a health check it will be removed from Route53 until it passes the health check.
    - We can set SNS notifications to alert us about failed health checks.

    Simple Routing Policy: you can only have one record with multiple IP addresses, if multiple values exist Route53 will retrun all values to the user in a random order (the user will be refeered to an IP address randomly).

    Weighted Routing Policy: Allows you to send traffic to different target IP addresses based on weights. 

    Failover Routing Policy: Allows you to have to sites, Active and Passive. 
    Route53 will direct to the active site until it fails the healthchecks then it will redirect all traffic to the passive site.

    Geolocation Record Policy: Allows you to route traffic based on the geolocation of the end user.

    Geoproximity Routing Policy: lets Route53 to route traffic based on geographic location of users and your resources, Optionally you can all route more or less traffic to a given resource by specifiying a values known as bias. - to use it you must have Route53 traffic flow set up.

    Latency Routing Policy: Route traffic based on the users latency to a specified region.

    Multivalue Routing Policy: Same as simple routing policy but only returns values of endpoints that successfully passed health checks.


# Elastic Load Balancers
<!-- Application Load Balancer -->
    Offers intelligent load balancing and operates on layer 7 of the OSI model. Supports only HTTP/HTTPS - SSL termination is done on the LB.

    Each ALB consists of:
    - Listeners: checks for connection requests from clients using the protocol and port we configure
    - Rules: determines how the LB will route the request to its registered target, each rule consists of a priorty, atleast one action and atleast one condition.
<!-- Network Load Balancer -->
    Offers high performance load balancing and operates on layer 4.
    Supported protocols: TCP, TLS, UDP,TCP_UDP. 
    Ports: 1-65535.
    Can offload TLS encryption/decryption to NLB but requires exactly one SSL server certificate on the listener.
    NLB consist of: Listeners and target groups (no rules).
<!-- Gateway Load Balancer -->
    Used in inline virtual appliances, operate at Layer 3.
<!-- Classic Load Balancer -->
    Legacy, offers HTTP/HTTPS (Layer 7) and strict Layer 4 load balancing.
    Supports the X-Forwarded-For header to forward the client's IP address.
    Error 504: Gateway timeout - application isn't responding.

<!-- Sticky Sesstions -->
    May cause problem when the user's session is tied to an EC2 instance that's no longer available. in that case just disable sticky sessions. 
    This can happen with CLB, but since ALB points to target groups and not individual EC2 instances its less of a problem.

<!-- Deregistration Delay / Connection Draining -->
    Allows you keep existing connections open if the EC2 instance becomes unhealthy.
    if Disabled existing connections will be terminated immediatly once EC2 instances become unhealthy.


# Monitoring
<!-- CloudWatch -->
    Metrics: Metrics are either Cefault or Custom, default are provided out of the box while custom require the Cloudwatch agent to be installed on the host.
    - Default: CPU utilization, Network Throughput. 
    - Custom: EC2 Memory Utilization, EBS Storage Capacity.

    Alarms: we can configure that a metric reaching certain conditions/threshold (<,<=.=>,> than threshold) to trigger an alarm, we can also choose how to treat missing data.
        Actions: We define actions to be performed once an alarm is triggered.
        - Autoscaling Actions: scale up, scale in etc.
        - EC2 Actions: Stop,Terminate,Reboot and Recover instance etc.
        - Systems Manager Actions: Create OpsItem, Create Incident etc.
        * There are no default alarms.
    
    Basic vs Detailed Monitoring:
        - Basic is 5 min intervals.
        - Detailed is 1 min intervals.
    
    * AWS can't see past the Hypervisor level for EC2 Instances by default.
    * The More Managed a service is, The more checks you get out of the box.

<!-- CloudWatch Logs -->
    Terminology:
        Log Event: The actual log, contains log data and timestamp.
        Log Stream: A collection of Log Events from the same sources creates a Log Stream.
        Log Group: A logical grouping of Log Streams.

    Features:
    - Filter Patterns.
    - CloudWatch Logs Insights: Allows you to query all logs using a SQL-Like language.
    - Alarms triggered by specific filter patterns.

    Logs that require processing should go to CloudWatch Logs.
    Logs that do not require processing, should go directly to S3.
    CloudWatch Logs is the preferred logging solution except if there are real-time needs that might fit better Kinesis.

<!-- AWS Prom,Grafana -->
    Prometheus: AWS managed, Prometheus compatibile serverless service, HA and can be used with EKS or even self-managed K8s clusters.
    AWS Grafana: Allows Container metrics/logs/traces visualisation, IoT edge device data streams and operational teams. 
    Grafana Data Sources: Comes with built-in data sources including CloudWatch Logs, AWS Prom, and AWS X-Ray.


# High Availability and Scaling
<!-- The 3 W's of Scaling -->
    What do we scale?
    Where do we scale?
    When do we scale?

<!-- Launch Templates vs Launch Configurations -->
    Templates:  
        - Can leverage all EC2 autoscaling features.
        - Supports versioning
        - More granularity
        - AWS Recommended approach
    Configurations:
        - Only for certain EC2 Auto Scaling features
        - Immutable (no versioning)
        - Limited Configuration options
        - Older and not recommended.

    Launch Tempaltes are made of:
    - AMI
    - EC2 Instance size
    - SGs
    - Networking information (optional)
    - User data (optional)

<!-- Lifecycle Hooks -->
    We can configure lifecycle hooks which are actions to perform during the inital launch of an instance during the Pending: Wait (for exmaple: install monitoring software on the instance) before it moves to the "InService" state. and we can configure lifecycle hooks during the Terminating: Wait state (ex: save all logs to S3) 

<!-- Scaling Types -->
    - Step Scaling: Applies stepped adjustments depending on the size of the alarm breach.
    - Simple Scaling: Relies on metrics for scaling needs, ex: add 1 instance if CPU util > 80%.
    - Target tracking: use a scaling metric target value and have the ASG add/remove Instances to stay within the target range

    - Reactive Scaling: Wait for the load and measure it to determine if scaling is needed.
    - Scheduled Scaling: Scale up/down in a schedule
    - Predictive Scaling: AWS using ML algorithms to scale, they are reevaluated every 24Hrs to forcast for next 48Hrs.

<!-- Instances Warmup and Cooldown -->
    Warmup: Stop instances from being placed behind ELB, failing HCs and being terminated prematurely.
    Cooldown: Pauses Autosacling for a seet amount of time.
    Both are used to avoid Thrashing, we want to scale up quickly and scale down slowly. 

<!-- Additional tips -->
    - Provisioning times: monitor your provisioning times and create custom AMI if needed to reduce the time it takes to provison an instance.
    - Cloudwatch is the main tool for alerting auto-scaling.
    - Auto Scaling is only only scales EC2 Instances.

<!-- 4 Options to scale Relational Databases -->
    - Vertical Scaling
    - Scaling Storage - Can only be scaled up.
    - Read Replicas.
    - Aurora Serverless.

<!-- Scaling Non Relational Databases -->
    DynamoDB Capacity modes (Table Types):
    - Provisioned: Good for predictable workloads, Need set upper and lower scaling bounds, most cost effective when used correctly.
    - On-Demand: Good for sporadic workload, easy to use, pay per read/write, less cost effective.

    Capacity Units for DDB:
        Read (RCU): 1 4kb strongly consistent read per scond, or 2 4kb eventually consistent reads per second.
        Write (WCU): 1 1kb write per second.

    * You can switch DDB capacity mode 2 times per 24 hours per table.

<!-- General Considerations -->
    Even if not asked for, we'd rather choose solutions that offer High-Availability, cost effectivness and sometimes it might be better to switch databases.

<!-- Disaster Recovery Strategies -->
Terminology:
    RPO: To what point in time you want your ENV recovered to. - Recovery Point Objective.
    RTO: How long until the ENV is recovered. - Recovery Time Objective.
    
The 4 Recovery Strategies:
    Backup and Restore: Cheapest but usually slowest.
    Pilot Light: Partially ready second ENV to be fully initialized in case of failover, faster the B&R but has downtime.
    Warm Standby: Fully initialized but scaled down ENV for failover, quciker than pilot but more expensive.
    Active/Active Recovery: Identical ENV for fail-over, fastest and most expensive. 


# Decoupling Workflows
We would always prefer loosely coupled architecture, avoid direct instance-to-instane communication.

<!-- SQS -->
    Settings:
    - Delivery Delay
    - Message Size: upto 256KB of text in any format.
    - Encryption: Messages are encrypted in transit and at rest (SSE).
    - Message Retention: 1 minute to 14 days, by default 4 days.
    - Long vs Short Polling: long is prefered.
    - Queue Depth: more of a value that a setting,   can be a trigger for autoscaling.
    - Visibility timeout: enables you to hide a message when processing it, if not processed within the timeout period the message will become visible again, and if successfuly processed within that period the message will be deleted.

    Dead-Letter Queues:
    an SQS Queue for messages that werent successfuly consumed.
    - make sure  to setup alarms and alerts on DLQ queue depth.
    - DLQs for FIFO SQS must also be FIFO.
    - SQL DLQs can be created for SNS topics.

    FIFO Queues:
    - Allows you ensure messages are consumed in the order they arrived to the queue.
    - Reduced performence and higher cost.
    - Messages contain deduplication ID to ensure messages are consumed only once.
    - There are ways to order a Standard Queue but its more difficult.
    - Message Group ID ensures messages are processed in a strict order base on the group.
        

<!-- SNS -->
Supported Subscribers:
-   Kinesis Data Firehose, SQS, Lambda, email, HTTP(S), SMS and Platform application endpoint
-   Message size 256kb of text in any format MAX.
-   FIFO\Standard: to modes availabe however FIFO Topics only supports SQS FIFO queues as a subscriber.
-   FIFO Topics support ordering and deduplication.
-   Messages that failed delivery can be stored in an SQS DLQ.
-   Encryption: in transit enabled by default, SSE can be enabled with KMS encryption.
-   Large Message Payloads: the SNS Extended Library allows for sending of messages upto 2GB in size, the message data is stored in S3 and then SNS publishes a reference to the object.
-   SNS Fanout: messages published to the SNS topic are replicated to multiple endpoint subscriptions, allows for decoupled parallel asynchronuos processing.
-   Message Filtering: Filter policies use JSON to define which messages get sent to which subscribers.

Giveaways: Scenerios involving alerting, Push-based message applications.

<!-- API Gateway -->
API Endpoint types:
    - Regional
    - Edge-optimizied (global)
    - Private (a VPC endpoint)

API Gateway features:
    - Supports versioning.
    - Can fron API Gateway with a Web Application Firewall (WAF)

* When API Gateway is created via Console it also gives the necessary permissions for accessing the backend (for example Lambda). if API Gateway is created via IaC then you need to take care of the permissions yourself.

<!-- AWS Batch -->
A managed service thats good for long-running (over 15 min) and event-driven workloads.

Terminology:
-   Jobs: Units of work submitted to AWS batch, e.g. shell script, executables and Docker images.
-   Job Definitions: The blue print for the resources in the job.
-   Job Queues
-   Compute Environment: set of Managed or Unmanaged compute resources used to run the jobs. 

Types of supported compute:
-   Fargate: Recommeneded,  start times <30s, upto 16vCPUs, no GPUs, <120GiB ram.
-   ECS EC2 Instances: More Complex, provides access to GPUs, Elastic Fiber Adapter, Custom AMIs, Linux Parameters and allow High levels of concurrency.

Batch vs Lambda:
-   Unlike Lambda, Batch can run for over 15min
-   While Lambda is serverless, it has limited runtime options, batch can run Docker images > any runtime.
-   Lambda has limited disk space.

<!-- Amazon MQ -->
A message queue service designed for easy migration of existing applications to AWS, supports Apache ActiveMQ and RabbitMQ engines.

SNS With SQS or Amazon MQ:
-   Both offer architectures with topics and queues. 
-   Both allow one-to-one or one-to-many messaging.
-   AMQ suitable for migrating existing applications with messaging systems.
-   If desiging new applications, SNS and SQS likely the better option due to simplicity and scalibility.
-   AMQ REQUIRES private networking such as VPC, DirectConnect or VPN.
-   SNS and SQS are publically accessible by default.

Broker Types HA Architecture:
    For ActiveMQ: active/standby deployments, one instance will remain available at all times.
    For RabbitMQ: Cluster deployments of 3 broker nodes across multiple AZs behind a NLB.

Giveaways: Anything specific to JMS, or messaging protocols like AQMP, MQTT, OpenWIre and STOMP.

<!-- AWS Step Functions -->
Serverless orchestration service, integrated with many AWS services. Written in Amazon States Language.
Each step in a workflow is considered a State.
Main componentes: State Machines and Tasks
State Machine:  A particulare workflow with different event-driven steps.
Tasks: Specific states within a workflow (state machine) representing a single unit of work.

Workflows:
-   Standard: Exactly-once execution, can run upto a year, upto 2,000 executions per second, pay per state transition, useful for long-running workfolws that need to have an auditable history.
-   Express: At-least-once execution, cat run upto 5min, pricing based on num of exececutions, durations and memmory consumed,useful for high-event-rate workloads.

Different States:
-   Pass: passes any input directly to its output.
-   Task: single unit of work performed.
-   Choice: Adds branching logic to state machines.
-   Wait: Creates a time delay.
-   Succeed: Stops executions successfully.
-   Fail: Stop executions with failure
-   Parallel: Run parallel branches of executions.
-   Map: Runs a set of steps based on elements of an input array.


<!-- Amazon AppFlow -->
Service for bi-directional flow of data from AWS to 3rd party SAAS apps.
Terminology:
-   Flow: Transfer of data between sources and destinations. -upto 100GB per flow.
-   Data Mapping: Determines how src data is stored in dst.
-   Filters: enable controlling which data is transfered.
-   Triggers: How the flow has started, types are Run on demand, Run on event, Run on schedule.


# Big Data
<!-- Redshift -->
A relational database based on PostgreSQL designed for large datasets upto 16 Petabyta, not suitable for OLTP.
- Supports multi-AZ (2) deployment for HA (Not option to conver single-AZ to multi-AZ).
- Column-based instead of row based, allows for efficient queries.
- Supports Snapshots that will be stored in AWS managed S3 bucket.
* Always Favor Large Batches for inserts.

Redshift Spectrum: Efficiently query and retrieve data from S3 without having to load data into Redshift tables.
Enhanced VPC Routing: All COPY and UNLOAD traffic between our cluster and data repositories is forced through our VPC, enables the usage of VPC features such as VPC Endpoints, VPC Flow Logs and more.

<!-- ETL with EMR  -->
ETL: Extract Transform Load.
EMR (Elastic MapReduce) is an AWS-managed big data platform for processing vast amounts of data.
Good for web indexing, ML training and large scale genomics.
Can be used with open-source tools such as: Spark, Hive, HBase, Flink, Hudi and Presto.

EMR Storage:
-   HDFS: Hadoop Distributed File System, it is scalable and used for caching results during processing.
-   EMRFS: EMR File system, Extends Hadoop to directly access data in S3.
-   Local File System: Locally connected disk created with each EC2 Instance, volumes remain only for the lifecycle of the instance.

Cluster Node Types:
-   Primary: Control plane.
-   Core: Runs Tasks and stores data in HDFS - Long Running.
-   Task Node: Only runs tasks, no storage, OPTIONAL, Typically Spot instance.

Purchasing options for Instances:
- On-Demand: Most Reliabled and expensive.
- Reserved: For 1 year minimum, Typically used for primary and core nodes.
- Spot: Cheapest but unreliable, typically task nodes.
* Clusters can be long-running  or transiet (temporary)

Giveaways: mention of Apache Hadoop and Apache Spark.

<!-- Kinesis -->
Service for ingesting, proccessing and analyzing real-time streaming data.
Data Streams vs Firehose:
    Kinesis Data Streams:
        Purpose: Real-time streaming for ingesting data.
        Speed: Real-time
        Difficulty: We're responsible for creating the consumer and scaling the stream

    Kinesis Data Firehose:
        Purpose: Data transfer tool to get inforomation to S3, Redshift, Elasticsearch or Splunk.
        Speed: Near Real-time (within 60secs).
        Difficulty: plug and play

Kinesis Data Analytics / Amazon Managed Service for Apache Flink:
    Can be used with Kinesis Data Streams / Firehose for proccessing data, real-time and serverless. 
    Pay only for consumed resources.

Giveaways: mention of real-time, can be used as a real-time message broker (unlike SQS).

<!-- AWS Athena and Glue -->
Both are serverless services.
    Athena: Allows direct query and analyze data in S3 using SQL.
    Glue: Allows running ETL workloads and structure data from S3, similar to EMR but serverless.

We can combine AWS Glue Crawlers to structure our data and have Athena analyze and query the structured data.

Giveaways: Athena - Serverless SQL.

<!-- AWS QuickSight -->
Service for business data visualizations (dashboards), ad-hoc data analytics, and obtaining data-based business inights.
Integrates with RDS, Aurora, Athena, S3 and more.
SPICE: Robust in-memory engine for advanced calculations.
Colum-Level Security (CLS) for Enterprise tier (paid).
Pricine is on a per-user per-session basis.
Has its own users and groups for managing access to insights.
* Groups are enterprise tier.
Giveaways: Business Intellignce.

<!-- AWS Data Pipeline -->
Managed service ETL workflows that automates movement and transformation of data.
use data-driven workflow to create dependencies between tasks and activities.
Componenets:
-   Pipeline Definiton: The business logic of our data management, made of activites.
-   Managed Compute: Will create or use existing EC2 Instances to perform activities. 
-   Task Runners: (EC2) poll for different tasks and perform them
-   Data Nodes: The locations and types of data that will be input \ output.
Storage integrations include DynamoDB, RDS, Redshift and S3.
Compute integratiosn include EC2 and EMR.
Can be integrated with SNS for Failure notifaction and event-driven workflows.
Giveaways: managed ETL services, automatic retries for data-driven workflows.

<!-- AWS MSK -->
AWS Managed Streaming for Kafka is managed AWS service for runnign and building Apache Kafka streaming applications.
It handles control-plane operation of Kafka clusters, allows automatic recovery.
data is Encrypted at rest with KMS and uses TLS for in-transit.

<!-- Amazon OpenSearch -->
Basically managed AWS ElasticSearch, ties with IAM for Access Control, SSE, VPC SGs, multi-AZ cabpable with automated snapshots.
Easily Scalable.
Integrates with CW, CT, S3, Kinesis.



# Serverless
<!-- AWS Lambda -->
Features:
-   Pricing: Free tier of 1 Million requests and 400,000 GBs of compute per month, after that pay as you go.
-   Integrates with AWS svcs including S3, DDB, EventBridge, SQS\SNS and Kinesis.
-   Built in monitoring with CloudWatch.
-   Easy configuration and scalability, upto 10,240 MB memory and CPU scales with it.
-   Execution times no longer than 15min, for anything longer use ECS, Batch or EC2.
-   Runtime support include Python, Golang, Java, NodeJS and more.

Configuration:
-   Runtime: Pick from available runtimes or bring your own.
-   Permissions: for the function to perfrom AWS API calls, you need to attach a role.
-   Networking: Optionally define the VPC, Subnet and SGs for your function, otherwise it will be automatically deployed in an AWS managed VPC with internet access.
-   Resources: Set the memory available to your function, CPU scales with memory, affects performance and cost.
-   Trigger: define what will trigger the function.
        Common Triggers:
        -   API Gateway
        -   S3
        -   DDB
        -   SNS
        -   CloudWatch Events
        -   Cognito
        -   Kinesis
        -   SQS
        -   Step Functions

Quotas and Limitations:
    Compute and Storage:
    -   1,000 Concurrent executions.
    -   512MB-10GB disk storage (/tmp). - Integration with EFS if needed.
    -   4KB for all env vars.
    -   128MB-10GB memory allocation.
    -   Execution time upto 900 secs.
    
    Deployment and configuration:
    -   Compressed deployment .zip package <=50MB.
    -   Uncompressed deployment <=250MB.
    -   Request and Response payload <=6MB.
    -   Streamed responses <=20MB.


<!-- AWS Serverless Application Repository -->
Repository for storing and sharing AWS Serverless applications.
Templates: Define whole application via AWS SAM Templates, private by default.
Allows publishing your own applications or Deploy publicly available ones.
Can share apps only within organizations.
High integration with Lambda.

<!-- ECS -->
    ECS vs EKS
    -   ECS: Proprietary AWS container orchestration solution, best if you're all-in on AWS, simpler than kubernets.
    -   EKS: Managed service of open-source K8s, fit for larger workloads, more difficult to configure.


    ECS Launch Types:
        EC2:
        -   We're responsible for underlying OS.
        -   EC2 Pricing.
        -   Fit for long running containers.
        -   Multiple containers can share the same host.
        -   Capable of mounting EFS for persistent shared storage.
        Fargate:
        -   No OS access.
        -   Pay as you go for resources and running time.
        -   Fit for short running tasks.
        -   Also capable of mounting EFS.
        -   Simpler but can be more expensive.
    
    Fargate is for running container, and deployed via ECS or EKS.
    ECS Task Roles are used to assign IAM permissions to contianers.
        Task Execution roles are used by the container agent to make AWS API calls.
    Fargate Always runs in awsvpc Network mode.
<!-- ECS Anywhere -->
a Feature of ECS for running ECS cluster on premises but have it managed by AWS ECS.
Requires the installation of ECS Agent, SSM Agent and Docker on the nodes.
Use the EXTERNAL launch type.

<!-- AWS EventBridge (CloudWatch Events) -->
Allows to trigger actions based on events within AWS, eg. Triggering a Lambda function when cretain AWS API calls are made.
Can use the default bas or create custom bus for cross-accoutn access.

<!-- Amazon ECR -->
Supports Docker images, OCI images and OCI-compatible artifact.
Can define Lifecycle policies for images.
Allow image scanning on push for identifying software vulnerabilities.
Can be configured prevent image tags from being overwritten.

<!-- EKS Distro -->
Open source version of EKS that we can deploy anywhere ourselves.
<!-- EKS Anywhere -->
Deployment of EKS on premises based on EKS-D, has curated packages that extend core funcionality of K8s ccluster but require a subscription.

<!-- Aurora Serverles -->
Concepts:
-   Aurora Capacity Units (ACUs): Measurments of cluster scaling.
-   Set a min and max of ACUs for scaling, can be zero.
-   Allocated by AWS-Managed warm pools.
-   Combination of ~2GiB mem and matching CPU and Networking.
-   As Resilient as Aurora Provisioned.
-   Supports Multi-AZ deployments.
-   Easilty swap between Provisioned and Serverless Aurora.
-   Pay as you go per second per used resources.
* Aurora Serverless v1 DB can scale down to zero ACUs, V2 can only scale to their minimum specified ACU value.

<!-- AWS X-Ray -->
AWS Tracing solution.
Concepts:
-   Traces: contain segments and Trace ID.
-   Tracing header: extra HTTP header containing sampling decisions and trace ID. - X-Amzn-Trace-Id
-   Segments: Data containing resource names, request details and other info.
-   Subsegments: provide more granular timing information and details.
-   Service Graph: Graphical visualization of interacting services in requests.

AWS X-Ray Daemon: listens on UDP:2000 and collects raw segment data which it then sends to AWS X-Ray API.
Integrations: EC2, ECS, Lambda, SNS\SQS, API Gateway, Elastic Beanstalk.
Giveaways: Application Insights, App request insights, viewing response times, HTTP response analysis.

<!-- AWS AppSync -->
A Service for scalable GraphQL interfaces.
Giveaways: GraphQL, fetching app data, declaritve coding and front-end data fetching.


# Security
<!-- DDOS -->
Common DDOS Attacks:
    Layer 4: SYN floods, NTP Amplification attacks.
    Layer 7: Floods of GET/POST

<!-- AWS Shield -->
Provides free protection against DDOS attacks and Layer 3/4 Attacks ONLY (NOT LAYER 7).
Avanced: Costs 3,000K a month and provides 24/7 dedicated DDoS Response Team.

<!-- AWS WAF -->
Provides Layer 7 protection, can block layer 7 DDOS attacks and SQL injection aswell cross-site scripting.
Also allows you to block access to specific countries and IP addresses.

<!-- CloudTrail -->
Logs API calls made to the AWS API.
What is logged:
-   Metadata around API Calls.
-   Identity of API Caller.
-   Time of API Call.
-   Source IP of API Caller.
-   Request parameters.
-   Response elements returned by the service.
Logs stored is S3.

<!-- AWS GuardDuty -->
Uses AI to learn what normal behavior looks in our account for 7-14 days and then alerts us of abnormal or malicius activity detected.
-   Updates a database of known malicious domains.
-   Monitors CloudTrail, VPC Flow Logs and DNS logs.
-   Findings appear in GuardDuty dashboard, CloudWatch events can be used to trigger events to address a threat.

<!-- AWS Firewall Manager -->
Allows you to centrelize and secure multiple AWS accounts and resources.
-   Good for ensuring complaince across accounts.

<!-- AWS Macie -->
An automated service that uses AI to analyze data in S3 and helps identify PII (Personal Identifable Information), PHI and financial data.
Alerts you with Macie Alerts if sensetive data found insecurely in a bucket.
-   Can be combined with other services such as Step Functions for remediation actions.
-   Ideal for preventing Identity theft.

<!-- AWS Inspector -->
Used to perform vulnerability scans on both EC2 Instances and VPC.
Provides a report that assesses the security of hosts and netowrk.
-   Host assesment require the installation of an agent on the host.
-   Network assesment does not require an agent.
-   Can be ran once or weekly.

<!-- KMS -->
KMS allows automatic encryption keys rotation and generation, however the underlying hardware is multi-tenant.
3 Ways to generate CMK:
-   AWS creates it for you, It is generated within HSMs managed by AWS KMS. - Allows automatic key rotation.
-   Import key material from our own key management infra.
-   Have the material generated in an AWS CloudHSM cluster as part of the custom key store feature in AWS KMS.
3 Ways to control permissions:
-   Use the key policy, the full access of the CMK is defined in a single document.
-   Use IAM policies in combination with the key policy.
-   Use grants in combination with the key policy. 

CloudHSM:
A service that dedicates HSM hardware for us, full control of users, groups, keys etc. - no automatic key rotation.

<!-- AWS Secrets Manager -->
Allows secure storage of applicatin secrets such as DB credentials, API keys, SSH keys, passwords etc.
-   Applications use the Secret Manager API.
-   Enabling rotation is easy but make sure no hardoced credentials in the application, SM will rotate the credentials once when enabled.
-   Not free.

<!-- AWS Parameter Store -->
Allows storage and management of configuration data and secrets data. 
Limits:
-   Maximum of 10,000 parameters stored.
-   No key rotation.
-   Can't generate passwords with CloudFormation.
-   Is Free
Parameter typs:
-   String
-   StringList
-   SecureString: stored and referenced in a secure manner, encrypted via AWS KMS.

<!-- Sharing S3 Objects Temporary -->
Two methods:
-   Presigned URLS, a URL with an experation data for a single object.
-   Presigned Cookies, the user will download a cookie that will grant him access to multiple S3 objects.

<!-- AWS Certificate Manager -->
Free service for creation and management of SSL Certificates.
integrates with ELB, CloudFront and API Gateway.
Has automatic rotation of certificates.

<!-- AWS Audit Manager -->
Service for automating audits in our AWS accont.
Giveaways: continous auditing, PCI HIPAA or GDPR compliance.

<!-- AWS Artifact -->
Service for downloading audit reports, usualy a distractor.

<!-- COGNITO -->
User Pools: User directories that provide sign-up and sign-in functionality for our application users.
Identity Pools: Allows users to access other AWS services.
How it works:
    1. User auths with User Pool and gets tokens.
    2. Token are provided to Identity Pool in exchange for AWS credentials.
    3. User access AWS services using the credentials.

<!-- Amazon Detective -->
Service for analyzing the root cause of an event. 
-   Operates across multiple AWS services.
-   Often a distractor.

<!-- AWS Network Firewall -->
A Physical AWS-managed firewal hardware.
-   Allows filtering of network traffic before it reaches our internet gateway.
-   Enables usage of intrusion prevention systems.

<!-- AWS Security Hub -->
Allow you to view all security alerts across multiple AWS security services and accounts.

# Automation
<!-- CloudFormation -->
Template sections:
    AWSTemplateFormatVersion - optional
    Parameters - optional
    Mappings - optional
    Resources - REQUIRED
    Outputs - Optional
    Transform - Optional

-   Stack failure options decide the behavior in case of stack deployment failure, rollback or keep successfuly provisioned resources.
-   Stack Policy allow you to protect stack resources from being deleted or being updated.
-   Rollback configuration enables automatic rollback based on alarm threshold.
-   Notification options enables notification in an SNS topic based on changes in stack.

<!-- Elastic Beanstalk -->
Platform as a Service, takes care of provisioning resources and deploying the application, we just need to provide the code.
Supported Languages: Java, PHP, Python, Rub, Go, .NET, NodeJS.
Deploys using platfroms including Tomcat and Docker.
It can fully manage the EC2 instacnes or we can take full administrative control.

<!-- Systems Manager -->
Uses the SSM Agent to centralize control and execution of taks in EC2 instances.
-   Make sure to have the necessary IAM permissions on the compute.
-   Can be installed on non AWS compute and edge devices.
Capabilities: 
   -    Automation: use predefined playbooks (Automation Documents).
   -    Run Command: execute commands remotely without SSH or RDP.
   -    Patch Manager: Automates patching managed instances (OS and Apps).
   -    Parameter Store integration.
   -    Maintainance Windows
   -    Session Manager: Securely connect to managed compute without needing SSH access. - doesn't require opening ports. 
   -    Logging allows logging of all usage during sessions to CW and CT.


# Caching
<!-- AWS Caching options: -->
    -   CloudFront (external caching)
    -   ElastiCach (internal caching)
    -   DynamoDB DAX
    -   Global Accelerator
* Caching whenever possible is preferred.

<!-- Cloudfront: -->
    -   Defaults to HTTPS, custom SSL certificate is optional.
    -   Can be used to front non AWS applications.
    -   Global  Distribution, no specific countries just general areas globally.
    -   Manual expiration of content from cache is possible, instead of waiting for TTL.

    Settings:
    -   HTTPS, redirect to HTTPS or Force HTTPS are possible.
    -   Possible to restrict contect access via signed URLs or signed Cookies.
* Cannot pick specifc eedge locations

<!-- ElastiCache: -->
    AWS managed version of Memcached and Redis.
    Memcached:
    -   Simple DB caching solution.
    -   Not a DB.
    -   No failover or Multi-AZ support.
    -   No Backups.
    Redis:
    -   Supported as a Caching solution.
    -   Functions as a standalone DB.
    -   Failover and Multi-AZ support.
    -   Supports Backups.

<!-- Global Accelerator: -->
IP Caching solution, where multiple servers are assigned the same IP and request are automatically routed to the nearst server.
-   Operates on layer 3, primarily TCP/UDP traffic.
-   Traffic is routed through AWS's internal network for high speeds.
-   By default, we are provided 2 Anycast IP addresses.
-   Dual-stack receives 4 static IP addresses (2 IPv4, 2 IPv6)
-   Standard routing: traffic is routed based on user location, health check and weights.
-   Custom routing: Traffic is routed to specified EC2 instances and ports in a VPC.


# Governance
<!-- AWS Organizations -->
For central management of multi-account AWS designs in a hierarchical manner.
Features:
-   Consolidated Billing: Batches all bills to a single payment method.
-   Usage Discounts: Consolidated billing allows aggregate usage discounts.
-   Shared Savings: Easily share Reserved Instances and Savings Plans across the org.

Service Control Policies: An OU-wide IAM permission guard rails policy that applies to all member of that OU. - doesn't affect management accounts.

<!-- AWS RAM (Resource Access Manager) -->
Allows cross-account sharing of resources. 
List of Resources than can be shared:
- TGW
- VPC Subnets
- License manager
- Route 53 Resolver (Rules and Endpoints)
- Dedicarted Hosts 
- And many more.

Ownership:
    Owners create and manag the VPC resources that get shared.
    They CANNOT modify resources deployed by participate accounts.
Participant Accounts:
    Able to provision resources into the shared VPC subnets.
    CANNOT modify the shared resource.

<!-- Cross-Account Role Access -->
Always use roles to grant temp access to resources in our AWS account.
Cross-account roles are preferred to IAM users.
Role assumption credentials expire.

Process:
    1. Create IAM Role for sharing.
    2. Create trust policy to allow sts:assumRole using their role's ARN.
    3. Provide the ARN of our created role to recipient.

<!-- AWS Config -->
Inventory management and control tool.
- Allows viewing of infra configuration history.
- Offers ability to create rules to make sure resources conform to requirements.
- Can receive alerts via SNS
- Configured per Region!
- Results can be aggregated across Regions and AWS Accounts.

Automatic Remidiation:
- Can be enabled via SSM Automation Documents.
- Automation Documents can be AWS-managed or custom.
- Custom Automation Documents can leverage Lambda.
- Can enable a retry if fails.

Integrates with SNS topics and EventBridge.
* Monitoring and assesment tool, NOT preventative.

<!-- AWS Directory Service -->
Types:
-   Managed Microsoft AD
-   AD Connector: Creates a tunnel between AWS and on-prem AD.
-   Simple AD: Standalone directory powerd by Linux Samba AD-compatible server.

<!-- Cost Explorer -->
Allows visualisation of your costs on AWS.
Important to use Tags!
Can forecast spending upto 12 months ahead.
Offers Hourly and monthly granularity.
Can break down costs per Linked Account.
Goes hand-in-hand with AWS Budgets.

<!-- AWS Budges -->
Best way of letting users know they are close to overspending.
Use Cost Explorer to create fine-grained budgets.
Use Tags!

Types of Budgets:
-   Cost Budgets: Plan how much you want to spend on a service.
-   Usage Budgets: Plan how much you want to use on one or many services.
-   RI Utilization Budgets: Utilization threshold. See if your RIs are unused or under-utilized.
-   RI Coverage Budgets: Coverage threshold, See how much of an instance usage is covered by a reservation.
-   Savings Plans Utilization Budgets: Utilization threshold, See if your savings plans are under-utilized.
-   Savings Plans Coverage Budgets: Coverage threshold. See how much of your instance usage is coverd by Savings Plans.

<!-- AWS Cost and Usage Reports (CUR) -->
Most Comprehensive set of cost and usage data for AWS spending.
Allows Publishing billing reports to S3.
Once enabled, updates atleast once a day.
Use within Organizations at org level, OU level or member account level.
Time granularity for aggregation of data: houry, daily or monthly.
Built-in support for configuring reports to be queried with Athen, ingested into Redshift or visualized with QuickSight.
* Giveaways: mention of detailed cost breakdowns, delivery of daily usage reports or tracking Savings Plans utilizations.

<!-- AWS Compute Optimizer -->
Optimizes: Analyzes configuration and utilization metrics of AWS resources.
Reporting: Reports current usage optimizations and potential recommendations.
Graphs: Provides Graphical history data and projected utilization metrics.

Supported Resources: EC2, Auto Scaling Groups, EBS, Lambda.
Supported Accounts: Standalone, Member, Management.

* Disabled by default. has paid features for enhancement of recommendations.

<!-- Savings Plans -->
Long term commitment (1/3-year), pay all upfront (best savings), partial upfront or no upfront.
    Compute Savings: most flexible, applies to EC2, Lambda and Fargate, Up to 66% savings.
    EC2 Savings: Applies only to EC2 of specific family in specific regions, Up to 72% savings.
    SageMaker Savings: Apply to any SageMaker instance, Any region and any component, up to 64% savings.

<!-- AWS Trusted Advisor -->
Using established best practices to check accounts.
Works at an account level and makes recommendations based on entire account.
Advises on Five Categories (Example Checks):
-   Cost Optimizations (Under utilized resources)
-   Performance (Overutilized\Underprovisioned resources based on metrics)
-   Security (Outdated services in instances )
-   Service Limits (Scaling group close to 100%)
-   Fault Tolerance (Are snapshots enabled)
-   Operation Excellence (Are VPC Flow logs enabled)
Basic and Develop support comes with limited free checks.
Eneterprise grants full access to All checks, Enables EventBridge automations.

<!-- AWS Control Tower -->
Quickest way to create and managed a secure, complaint AWS Multi-Account environment based on best practices.
-   Automates account creation and security controls.
-   Extends AWS organizations and leverages guardrails.

Terminology:
-   Landing zone: Well-architected, multi-account environment based on compliance and security best practices.
-   Guardrails: High-level rules for the AWS environment.
    1. Preventitive Guardrails utilize Service Control Polices.
    2. Detective Guardrails leverages AWS Config rules to detect and alert violations.
-   Account Factory: configurable pre-approved templates for new accounts.
-   CloudFormation StackSet: Automated deployment of templates deploying repeated resource for governance.
-   Shared Accounts: Three accounts used by Control Tower created during LZ creation.
    The shared accounts are:
    1. Management account
    2. Log archive account
    3. Audit account.

* Giveaways: Automated multi-account governance, guardrails, account orchestration and governed user account provisioning.

<!-- AWS License Manager -->
Service for license management
Giveaways: License Managemenet, Preventing license abuse.

<!-- AWS Health -->
Dashboard for tracking health, performance and availability of AWS Services.
for example, it'll notify you if theres a maintainance scheduled on your EC2.
-   Alerts you when there are events specific to your account, or globally relevant.
-   Can automate actions using event bridge.
Giveaways: Alerts for service health, Automating reboot of EC2 instances for AWS maintenance.

<!-- AWS Service Catalogs -->
A Catalog of pre-approved CloudFormation templates, allows end users to deploy pre-approved services into their own accounts.
<!-- AWS Proton -->
IaC provisioning and deployment of serverless/container architectures, meant to empower developers.

<!-- AWS Well-Architected Tool -->
A tool for measuring current workload against established AWS best practices.
Aids in documentation of workload and architecture decisions.

# Migration
<!-- AWS Snow Family -->
Snowcone: small device upto 8TB of data.
Snowball edge: medium device Storage, Compute and GPU, 50-80TB of data.
Snowmobile: a truck Upto 100PB of data.

<!-- Storage Gateway -->
Hybrid cloud storage service for merging on-prem with AWS.

File Gateway: on prem NFS or SMB mount that copies/backs up/ caches files into AWS S3.
Volumes Gateway: iSCSI Mount, Cached or stored mode, Create EBS Snapshots, Good for backup or migration.
Tape Gateway: Replaces physical tapes by running as a virtual tape device.

AWS DataSync: Agent based solution for one-time sync of on-prem NFS/SMB to AWS S3/EFS/FSx.
              Agentless when trasferring data between AWS storage devices on the same AWS account.

<!-- AWS Transfer -->
Creates an sFTP and FTPS endpoints for loading data from outside into S3/EFS.
Can also create an FTP endpoint inside the VPC only. 
Good for supporting legacy applications.

<!-- AWS Migration Hub -->
Server Migration Service (SMS): Converts vCenter VMs into AMIs
Database Migration Service (DMS): Converts Oracle/MySQL databases into Amazon Aurora DB/RDS using the Schema Conversion tool.

<!-- AWS Application Discovery Service -->
Migrate Applications to AWS
Agentless: Migrate VMs based on Hypervisor-level data to AWS.
Agent-Based: Gain additional data on VMs by installing an agent to help with migration.

<!-- AWS Application Migration Service (MGN) -->
Automated lift and shift of infrastructure to AWS.
Replicates source servers (VMs, Physical, Cloud) into AWS for non-disruptive cutovers.
RTO Measured in minutes, depending on OS boot time.
RPO measured in sub-seconds.

<!-- AWS DMS - additional -->
Database Migration Service.
Types of migration:
    1. Full Load: All existing data is movbed from sources to targets in parallel.
    2. Full Load and Change data Capture (CDC): Full load plus CDC captures changes to source tables during migration - the only option that guarantees transactional intgerity of target database.
    3. CDC Only: replicate only data changes from source database.
* One of the endpoints must be in AWS.


# Front-End Web and Mobile
<!-- AWS Amplify -->
Suite of tools for front-end devs to quickly build full-stack apps on AWS
Amplify hosting:
    Supports common frameworks like React,Angular and Vue.
    Allows seperation of staging and prod envs.
    Support for server-side rendering apps like Next.js.
Amplify Studio:
    Easy auth implemenntation within apps.
    Visual development environment to simplify creation of full-stack web/mobile apps.
    Offers ready-to-use components.
* Giveaways: Managed Server-Side Rendering in AWS, Easy mobile development, developers running full-stack applications.

<!-- AWS Device Farm -->
Testing of mobile applications on actual devices (phones and tablets) either automatically or manually.

<!-- AWS Pinpoint -->
Service for engaging customers with SMS/Emails push notifications etc..
Features:
    Projects: Collection of information, segments, campaigns and journeys.
    Channels: The platform where we engage audiance segments.
    Segments: Dynamic or imported; which users receive specific messages.
    Campaigns: Initiatives engaging specifc audiance segments.
    Journeys: Customized, multi-step engagements
    Message Templates
    Machine Learning: for prediction of user patterns.


# AWS Machine Learning
<!-- Analyzing Text -->
Comprehend: used to understand meaning and sentiment in text, for example if feedback regarding you service is positive or negative.

Kendra: An intelligent search service powered by ML, can search and index data located in different locations such as S3, File Servers and websites.

Amazon Textract: automatically extract text, handwriting and data from scanned documents.

<!-- Amazon Forecast -->
Time-series forcasting service using ML.

<!-- Amazon Fraud Detector -->
Allows you to build fraud detection ML model based on your data.

<!--Services Working with Text and Speech -->
Transcribe: Convert audio and video files to text.
Lex: Allows you to build conversational interfaces using natural language models.
Polly: Turns text into lifelike speech.

<!-- Rekognition -->
Uses ML to automate recognition of pictures and videos, useful for content moderation.

<!-- Amazon SageMaker -->
Service for creating and training of ML models
Components:
    Notebook: Create models
    Training: Train and tune models
    Inference: Deploy models.
Deployment Typs:
    Offline: Asynchrous or batch.
    Online: Synchronous or realtime.

SageMaker Stages:
1. Create a Model.
2. Create an Endpoint configuration.
3. Create an Endpoint.

Elastic Inference: Speeds up throughput and decrease latency on SageMaker hosted services using CPU-based instances. more cost effective than full gpu instance.

<!-- Amazon Translate -->
ML Service to automate language translation.

# Media
<!-- Elastic Transcoder -->
Service for transcoding Media.

<!-- Kinesis Video Streams -->
Allows video streaming at scale to AWS and perform real time video analytics, ML, Playback and other processing.
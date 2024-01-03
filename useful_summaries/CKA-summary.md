# Chapter 3 Cluster Management 
    Highly available K8s cluster is:
        a cluster with multiple control plan nodes (Master)

    Stacked Etcd: 
        When each worker node is also hosting its own Etcd
    
    External Etcd:
        When theres a seperate server hosting the Etcd

    Etcd Backup and Restore with etcdctl:

        etcdctl snapshot save /home/user/etcd_backup.db \
            --endpoints=<ClusterEndponit> \
            --cacert=etcd-ca.pem \
            --cert=etcd-server.crt \
            --key=etcd-server.key 

        etcdctl snapshot restore /home/user/etcd_backup.db \
            --initial-cluster etcd-restore=<ClusterEndpoint> \
            --initial-advertise-peer-urls <ClusterEndpoint> \
            --name etcd-restore \
            --data-dir /var/lib/etcd


# Chapter 4 Kubernetes Object Managment
    kubectl get
        -o  Set output format (JSON/YAML, useful when you want to use one of the next 2 flags)
        --sort-by   Sort using JSONPath expression
        --selector  Filter using labels

    kubectl api-resources
        to list all resource types

    kubectl exec <pod-name> -c <container-name> -- echo "Hello World"
        for pods with multiple containers

    kubectl create deployment my-deployment --image=nginx --dry-run -o yaml > nginx-deployment.yaml
        useful way of obtaining an example deployment yaml without changing the cluster

    kubectl scale deployment my-deployment --replicas 5 --record
        this will scale the deployment and record the command used in the deployment annotations.

    ### RBAC ###
    
    Role vs ClusterRole:
        Role defines permissions on a namespace basis while ClusterRole defines permissions cluster wide, regardless of namespace.

    Role Example:

        apiVersion: rbac.authorization.k8s.io/v1
        kind: Role
        metadata:
            namespace: default
            name: pod-reader
        rules:
        - apiGroups: [""]
          resources: ["pods", "pods/log"]   # the resources
          verbs: ["get", "watch", "list"]   # the actions allowed to be performed on those resource 


    RoleBinding\ClusterRoleBinding:
        objects that connect Roles and ClusterRoles to users

    RoleBinding example:

        apiVersion: rbac.authorization.k8s.io/v1
        kind: RoleBinding
        metadata:
            name: pod-reader
            namespace: default
        subjects:
            kind: user
            namespace: default
            apiGroup: rbac.authorization.k8s.io
        roleRef:
            kind: Role
            name: pod-reader
            apiGroup: rbac.authorization.k8s.io


    ### METRICS ###

    kubectl top
        views resource usage of pods / nodes, requires kube-metrics-server.


# Chapter 5 Containers and Pods
    ### Pod Resources ###
    resourceRequest:
        Used to provide more information the the scheduler in order to schedule a pod on a node that has sufficient resources. 
    resourceLimits: 
        Used to limit the pod to a predefined resource amount.

    ### Readiness, Liveness, and Startup Probes ###
    example of liveness probe that checks if a container can execute a "Hello world" echo command

        apiVersion: v1
        kind: Pod
        metadata:
            name: liveness pod
        spec:
            restartPolicy: Always
            containers:
                name: busybox
                image: busybox
                command: ["sh", "-c", "while true; do sleep 3600"]
                livenessProbe:
                    exec:
                        command: ["echo", "Hello world"]
                    initialDelaySeconds: 5
                    periodSeconds: 5

    you can also edit to probe to perform http "get" request instead of a shell command, and more.

    ### Restart Policies ###
        defined under "spec" in the pod deployment.

        Always:
            the default restart policy, will restart the pod in any case they are stopped, used for applications that should always be running. 
        OnFailure:
            Restarts the pod only if the container process exists with an error code or determined to be unhealthy. 
            Used for applications that need to be run successfully and then stop.
        Never:
            Never attempts to restart a container.

    ### Init Containers ###
        Containers that run on during the inital startup of a pod, before other containers are started.
        example:
           
            apiVersion: v1
            kind: Pod
            metadata:
                name: liveness-pod
            spec:
                containers:
                    name: main-container
                    image: nginx
                initContainers:
                    name: delay
                    image: busybox
                    command: ["sleep", "sleep 60"]


# Chapter 6 Advanced Pod Allocation
    ### Scheduling ###

    Example of using nodeSelector:

        apiVersion: v1
            kind: Pod
            metadata:
                name: pod
            spec:
                nodeSelector:
                    my-label:my-value
                containers:
                    name: main-container
                    image: nginx

    Similiraly we can use nodeName, for example:
        .......
                nodeName: k8s-worker-1

    ### DaemonSets ###
    Daemonsets do follow scheduling rules.
    
    ### Static Pods ###
    Static Pods:
        A pod that is managed directly by the kubelet on a node, no control plane is required.
        A static pod can be created by placing a pod manifest file yaml in a pre-defined location, example : /etc/kubernetes/manifests .
    Mirror Pod:
        Created automatically by the kubelet when a static pod is start. It is a "ghost" version of your static pod used to provide information about the static pod to the kube-api-server


# Chapter 7 Deployments
    to get the rollout status (history) of a deployment
        kubectl rollout status (history) deployment my-deployment

    when updating a deployment, we can use --record to allow for an easy rollback later on, we can rollback to revision 2 using:
        kubectl rollout undo deployment my-deployment --to-revision=2


# Chapter 8 Networking
    NetworkPolicy, is an object that lets you control the flow of network traffic between pods, bot ingress and egress. 
    By default pods are without NetworkPolicy and are open to all traffic, As soon as a NetworkPolicy is applied to a pod, the pod is isolated and can communicate only within its NetworkPolicy limits.

    example:

        apiVersion: networking.k8s.io/v1
        kind: NetworkPolicy
        metadata:
        name: test-network-policy
        namespace: default
        spec:
        podSelector:
            matchLabels:
            role: db     // allow traffic only between pods with said label
        policyTypes:
            - Ingress
            - Egress
        ingress:
            - from:
                - ipBlock:
                    cidr: 172.17.0.0/16   // allow ingress traffic only within cidr block
                    except:
                    - 172.17.1.0/24       // exclude?
                - namespaceSelector:
                    matchLabels:
                    project: myproject    // allow ingress traffic only from project: myproject
                - podSelector:
                    matchLabels:
                    role: frontend
            ports:
                - protocol: TCP
                port: 6379
        egress:
            - to:
                - ipBlock:
                    cidr: 10.0.0.0/24
            ports:
                - protocol: TCP
                port: 5978


# Chapter 9 Services
    ClusterIP: service that allows communication from within the cluster
    NodePort: service that allows communication both within and from outside the cluster

    service:
        port: the port the service will be listening to (in-cluster)
        targetPort: the port the service will be using to communicate with the pod
        nodePort: the port the service will be listening to (from outside the cluster)

    service fqdn example:
        service-name.namespace.svc.cluster-name.local
    You can use the fqdn to communicate from any namespace.


# Chapter 10 Storage
    Common volume types:
        hostPath: Stores data in a specified directory on the K8s node
        emptyDir: Stores data in a dynamically created location on the node, exists only as long as the pod exists
                  on the node, useful for sharing data between containers on the same node.

    persistentVolumeReclaimPolicy types:
        these define what will happen to the persistentVolume after its PVC is deleted.
            Retain: keeps all data, requires manual removal.
            Delete: deletes the underlying storage resource (only for cloud)
            Recycle: deletes all data in the underlying storage resource, allowing the PersistentVolume to be resused.

    storageClass allowVolumeExpansion:
        when set to true it allows the storage class to resize volumes after they have been created


# Chapter 11 Troubleshooting
    Checkings logs for k8s related services on each node:
        sudo journalctl -u kubelet
        sudo journalctl -u docker

    executing commands within a multi container pod
        kubectl exec <pod> -c <container> -- <command>
    or
        kubectl exec <pod> -c <container> --stdin --tty -- /bin/sh

    useful pod for troubleshooting k8s network

        apiVersion: v1
        kind: Pod
        metada:
            name: netshoot
        spec:
            containers:
            - name: netshoot
              image: nicolaka/netshoot
              command: ['sh', '-c', 'while true; do sleep 5; done']


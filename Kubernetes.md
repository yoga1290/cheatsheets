
# K8S/Kubernetes
`κυβερνήτης:` means helmsman or ship pilot
`K8S`, 8 characters between K and S

+ Kubernetes is written in Go
+ Inspired by Google's borg

+ Each **node** in the cluster runs **kubelet** (`/var/lib/kubelet`[docs](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/#local-ephemeral-storage)), **kube-proxy** & container engine (Docker/cri-o/rkt)
 + **kubelet** ensures access or creation of storage, Secrets or ConfigMaps
 + **Master Node** contains **kube-apiserver**, **kube-scheduler**, **Controllers** and **etcd** db
   + **Controllers**: "A control loop that watches the shared state of the cluster through the apiserver and makes changes attempting to move the current state towards the desired state." [[docs](https://kubernetes.io/docs/concepts/overview/components/#kube-controller-manager)]
     + **Deployment** deploys a **ReplicaSet**, a controller which deploys the **containers** [[Create](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#creating-a-deployment), [scale](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#scaling-a-deployment)]
     + [**DaemonSet**](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset): Normally, the machine that a Pod runs on is selected by the Kubernetes scheduler. However, Pods created by the DaemonSet controller have the machine already selected
     + [**ReplicaSet**](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/#example)
       + "It is strongly recommended to make sure that the bare Pods do not have labels which match the selector of one of your ReplicaSets… it can acquire other Pods" [[docs](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/#non-template-pod-acquisitions)]
   + **etcd** db is a b+ tree key-value store.
     + There could be **followers** to the **master** db; managed thru **kubeadm**
   + **kube-apiserver** handles both internal and external traffic, connects to the **etcd** db.
   + **kube-scheduler** deploys the **Pod**, quota validation.
     + [Resource requests and limits](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/#resource-requests-and-limits-of-pod-and-container):
     + `spec.containers[].resources.limits.cpu`
     + `spec.containers[].resources.requests.cpu`
     + `spec.containers[].resources.limits.memory`
     + `spec.containers[].resources.requests.memory`
     + `spec.containers[].resources.limits.ephemeral-storage`
     + `spec.containers[].resources.requests.ephemeral-storage`
+ **Pod**, a group of co-located **containers** that share the same IP address (could be for logging and/or different functionality)
  + **State**: "To check state of container, you can use `kubectl describe pod [POD_NAME]`" [docs](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-states) 
  + **Probe**
    + "diagnostic performed periodically by the kubelet on a Container. To perform a diagnostic, the **kubelet** calls a **Handler** implemented by the Container" [docs](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes)
   + **readinessProbe** :  ready to accept traffic?
    + `exec` w zero exit
    + `httpGet` code returns `[  200-399]`
   + **livenessProbe**
  + **pause container** is used to get an IP address, then all the containers in the pod will use its network namespace
  + Pods can communicate w each other via loopback interface, IPC or writing files to common filesystem.
 + Container options: Docker, CRI, Rkt :rocket: , CRI-O
  + **runC** is part of Kubernetes, unlike Docker, is not bound to higher-level tools and that is more portable across operating systems and environments.
  + **buildah** & **PodMan** (pod-manager) allow building images with and without Dockerfiles while not requiring any root privileges

+ **Annotations** are for meta-data
+ **Supervisord** monitors **kubelet** and docker processes
+ **Fluentd** could be used for cluster-wide logging

[![](https://d33wubrfki0l68.cloudfront.net/e298a92e2454520dddefc3b4df28ad68f9b91c6f/70d52/images/docs/pre-ccm-arch.png)](https://kubernetes.io/docs/concepts/architecture/cloud-controller/)

# [Playground](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#before-you-begin)
 + [Katacoda](https://www.katacoda.com/courses/kubernetes/playground)
 + [Play w K8S](http://labs.play-with-k8s.com/)

## MiniKube
+ [install guide](https://kubernetes.io/docs/tasks/tools/install-minikube/)
+ [doc](https://kubernetes.io/docs/setup/minikube)

[![](https://d33wubrfki0l68.cloudfront.net/673dbafd771491a080c02c6de3fdd41b09623c90/50100/images/docs/admin/access-control-overview.svg)](https://kubernetes.io/docs/reference/access-authn-authz/controlling-access/)

**Authentication** -*login*-> **Authorization** -*requests*-> **Admission Control** (other checks)

## Authentication
+ Client Certificate: `--client-ca-file=SOMEFILE`
+ Webhook Token Authentication
+ Static Token(s) File: `--token-auth-file=SOMEFILE`
+ Bootstrap Tokens (*alpha*): bootstrapping a new Kubernetes cluster.
+ Static Password File: `--basic-auth-file=SOMEFILE`
+ Service Account Tokens: This is an automatically enabled authenticator that uses signed bearer tokens to verify the requests. These tokens get attached to Pods using the ServiceAccount Admission Controller, which allows in-cluster processes to talk to the API server.
+ OpenID Connect Tokens
+ `--experimental-keystone-url=<AuthURL>`
+ Authenticating Proxy

## Authorization
+ Node Authorizer
+ [Webhook](https://kubernetes.io/docs/reference/access-authn-authz/webhook/#configuration-file-format): `--authorization-webhook-config-file=WebhookAuthz.json`
+ [**Role**-Based Access Control (RBAC) Authorizer](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) (& ClusterRole)
 + `--authorization-mode=RBAC`

```yaml
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: pod-read-access
  namespace: lfs158
subjects:
- kind: User
  name: nkhare
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```
+ **Attribute**-Based Access Control (ABAC) Authorizer
  + `--authorization-mode=ABAC`
  + `--authorization-policy-file=Policy.json`
 
 ```json
 {
  "apiVersion": "abac.authorization.kubernetes.io/v1beta1",
  "kind": "Policy",
  "spec": {
    "user": "nkhare",
    "namespace": "lfs158",
    "resource": "pods",
    "readonly": true
  }
}
 ```
 
## Admission Control
+ after API requests are authenticated and authorized.
+  admission-control, which takes a comma-delimited, ordered list of [admission controller names](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#what-does-each-admission-controller-do), e.g: `--admission-control=NamespaceLifecycle,ResourceQuota,PodSecurityPolicy,DefaultStorageClass`

# Services

+ External-to-pod communications
+ "defines a logical set of Pods and a policy by which to access them" [[docs](https://kubernetes.io/docs/concepts/services-networking/service/#service-resource)]
+ Service is a microservice handling access polices and traffic; NodePort or **LoadBalancer**
+ Logically, via Labels & Selectors, groups Pods and a policy to access them
+ load balancing while selecting the Pods
+ By default, each Service also gets an IP address, which is **routable only inside the cluster**
+ Service can have **multipile IP:Port** endpoints
+ ServiceType
 + Decide the access scope
 + **ClusterIP** is the default ServiceType w a 0000-32767 NodePort exposed to all worker nodes
 + ExternalName
  + Has no Selectors & endpoints
  + Accessible within the cluster
  + Returns a CNAME record of an externally configured Service.
+ Service Discovery
 + Environment Variables for the (previously) created services as:
  + `<SERVICE_NAME>_SERVICE_HOST`
  + `<SERVICE_NAME>_SERVICE_PORT`
  + `<SERVICE_NAME>_PORT`
  + `<SERVICE_NAME>_PORT_<PORT>_TCP`
  + `<SERVICE_NAME>_PORT_<PORT>_TCP_PROTO`
  + `<SERVICE_NAME>_PORT_<PORT>_TCP_PORT`
  + `<SERVICE_NAME>_PORT_<PORT>_TCP_ADDR`
 + [DNS add-on](https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/dns)
  + Services, within the same Namespace, can reach to each other by their name.
  + 
+ example:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: ServiceName
  labels:
    app: mysvc
spec:
  type: NodePort
  ports:
  - port: 80 #
    targetPort: web-port #forwarded to
    protocol: TCP
  selector:
    app: mysvc
```

# kube-proxy

+ Runs in worker nodes
+ Configures the iptable for forwarding to the Service endpoint(s)


# ConfigMap

+ [ConfigMap](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#create-a-configmap)
 + [Create from directory](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#create-configmaps-from-directories)
 + [Create from file/url](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#create-configmaps-from-files)
 + [Create from literal values](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#create-configmaps-from-literal-values)
+ [Environment variables in Pod](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#use-configmap-defined-environment-variables-in-pod-commands)

# Secret
+ Secret data is stored as plain text inside etcd, thus limit access
+ does not appear in `kubectl get secret [secret]` and `kubectl describe secret [secret]`
+ [As Pod Volume](https://kubernetes.io/docs/concepts/configuration/secret/#using-secrets-as-files-from-a-pod)
+ [Environment Variable](https://kubernetes.io/docs/concepts/configuration/secret/#using-secrets-as-environment-variables)

# Kubectrl

+ `kubectl get pods`
+ `kubectl exec -it <Pod-Name> --/bin/bash`
+ `kubectl run <Deploy-Name> --image=<repo>/<app-name>:<version>`



# YAML

## DEPLOYMENT
-----

**apiVersion:** apps/v1  
**kind:** Deployment  
**metadata:**  
&nbsp;&nbsp;**name:** DEPLOYMENT_NAME  
&nbsp;&nbsp;**labels:** (*DEPLOYMENT*|*SERVICE*)  
&nbsp;&nbsp;**appdb:** rsvpdb  
**spec:**  
&nbsp;&nbsp;**replicas:** 1  
&nbsp;&nbsp;**selector:**  
&nbsp;&nbsp;**matchLabels:** (*DEPLOYMENT*|*SERVICE*)  
&nbsp;&nbsp;&nbsp;&nbsp;**appdb:** rsvpdb  
&nbsp;&nbsp;**template:**  
&nbsp;&nbsp;&nbsp;&nbsp;**metadata:**  
&nbsp;&nbsp;&nbsp;&nbsp;**labels:** (*DEPLOYMENT*)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**appdb:** rsvpdb  
&nbsp;&nbsp;**spec:**  
&nbsp;&nbsp;&nbsp;&nbsp;**containers:**  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- **name:** DEPLOYMENT_CONTAINER_NAME  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**image:** DEPLOYMENT_IMAGE:TAG  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**ports:**  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- **containerPort:** DeploymentPort  

## SERVICE
-----
**apiVersion:** v1  
**kind:** Service  
**metadata:**  
&nbsp;&nbsp;**name:** mongodb  
&nbsp;&nbsp;**labels:** (*DEPLOYMENT*|*SERVICE*)  
&nbsp;&nbsp;**app:** rsvpdb  
**spec:**  
&nbsp;&nbsp;**ports:**  
&nbsp;&nbsp;- **port:** 27017  
&nbsp;&nbsp;&nbsp;**protocol:** TCP  
&nbsp;&nbsp;&nbsp;**selector:** (*DEPLOYMENT*|*SERVICE*)  
&nbsp;&nbsp;&nbsp;**appdb:** rsvpdb  


## RoleBinding


kind: RoleBinding  
apiVersion: rbac.authorization.k8s.io/v1  
metadata:  
 name: pod-read-access  
 namespace: lfs158  
subjects:  
  - kind: User  
    name: nkhare  
    apiGroup: rbac.authorization.k8s.io  
roleRef:  
   kind: Role  
   name: pod-reader  
   apiGroup: rbac.authorization.k8s.io  
  

## [DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/#create-a-daemonset)
## [ReplicaSet](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/#example)

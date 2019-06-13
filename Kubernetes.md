
# K8S/Kubernetes
`κυβερνήτης:` means helmsman or ship pilot
`K8S`, 8 characters between K and S

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

+ Logically, via Labels & Selectors, groups Pods and a policy to access them
+ load balancing while selecting the Pods
+ By default, each Service also gets an IP address, which is routable only inside the cluster
+ Service can have multipile IP:Port endpoints
+ ServiceType
 + Decide the access scope
 + ClusterIP is the default ServiceType w a 0000-32767 NodePort exposed to all worker nodes
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

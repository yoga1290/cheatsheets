 
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
+ [`--authorization-webhook-config-file=WebhookAuthz.json`](https://kubernetes.io/docs/reference/access-authn-authz/webhook/#configuration-file-format)
+ **Role**-Based Access Control (RBAC) Authorizer (& ClusterRole)
```yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: lfs158
  name: pod-reader
rules:
- apiGroups: [""] # "" indicates the core API group
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
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
 
 

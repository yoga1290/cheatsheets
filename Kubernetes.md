**Authentication** -*login*-> **Authorization** -*requests*-> **Admission Control** (other checks) 
[![](https://d33wubrfki0l68.cloudfront.net/673dbafd771491a080c02c6de3fdd41b09623c90/50100/images/docs/admin/access-control-overview.svg)](https://kubernetes.io/docs/reference/access-authn-authz/controlling-access/)

+ Client Certificate: `--client-ca-file=SOMEFILE`
+ Webhook Token Authentication
+ Static Token(s) File: `--token-auth-file=SOMEFILE`
+ Bootstrap Tokens (*alpha*): bootstrapping a new Kubernetes cluster.
+ Static Password File: `--basic-auth-file=SOMEFILE`
+ Service Account Tokens: This is an automatically enabled authenticator that uses signed bearer tokens to verify the requests. These tokens get attached to Pods using the ServiceAccount Admission Controller, which allows in-cluster processes to talk to the API server.
+ OpenID Connect Tokens
+ `--experimental-keystone-url=<AuthURL>`
+ Authenticating Proxy

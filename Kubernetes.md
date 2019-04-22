**Authentication** -*login*-> **Authorization** -*requests*-> **Admission Control** (other checks) 
[![](https://d33wubrfki0l68.cloudfront.net/673dbafd771491a080c02c6de3fdd41b09623c90/50100/images/docs/admin/access-control-overview.svg)](https://kubernetes.io/docs/reference/access-authn-authz/controlling-access/)

## Users:
+ **Normal Users**: managed externally
  + Client Certificate: ``
  + File listing
+ Service Accounts (auto/manually)
+ Anonymous (configuration)

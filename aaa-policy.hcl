# https://www.vaultproject.io/docs/secrets/kv/kv-v2.html

# meta-data required for v2 / versioning
path "kv/metadata/*" {
  capabilities = ["list"]
}

# A suggested kv format for large orgs
# <store_name>/data/<environment>/<group_name>/<app_name>/<secret_owner>/mysecret
#
# store_name: The keystore name
# data: Required for V2 - See also delete, metadata, destroy, etc.  See: https://www.vaultproject.io/docs/secrets/kv/kv-v2.html
# environment: dev, qa, rnd, prod, stage, etc. 
# group_name: team/app/product/dept/etc. 
# app_name: app within group
# secret_owner: same as group, or alternately a delegated secret manager such as the dba team. Allows for delegate policy like kv/data/+/+/dba/+/*
# finally, the secret key name you want to use. 
#
path "kv/data/+/aaa/+/aaa/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}


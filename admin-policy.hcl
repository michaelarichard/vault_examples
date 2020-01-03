
path "kv/metadata/*" {

  capabilities = ["list"]

}

path "kv/data/*" {

  capabilities = ["create", "read", "update", "delete", "list"]

}

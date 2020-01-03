path "kv/metadata/*" {

  capabilities = ["list"]

}

path "kv/data/+/bbb/+/bbb/*" {

  capabilities = ["create", "read", "update", "delete", "list"]

}

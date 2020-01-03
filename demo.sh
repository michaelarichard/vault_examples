# Shell Script
#
####
# Run a local docker vault ( Or request creds)
####

# --cap-add=IPC_LOCK = lock memory/no swap

docker run --rm --cap-add=IPC_LOCK -p 8200:8200 -d --name=dev-vault vault
docker logs dev-vault
 
# Grab the token
export VAULT_TOKEN=$(docker logs dev-vault 2>/dev/null | grep Root | awk '{ print $3 }')
#export VAULT_TOKEN="<from docker logs>"
export VAULT_ADDR="http://127.0.0.1:8200"

vault status
vault login $VAULT_TOKEN

# SHOW UI Login
# Open ${VAULT_ADDR} in a browser.
open $VAULT_ADDR

# Example secret
cat secret.json

 

# Enable a V2 key-value store for versioned secrets called 'kv'
# https://www.vaultproject.io/docs/secrets/kv/index.html
#vault secrets enable -version=2 kv

vault secrets enable -version=2 -path=kv kv

# Create secret/confirm
vault kv put kv/rnd/aaa/hello-world/aaa/test-cred1 @secret.json
vault kv put kv/rnd/bbb/hello-world/bbb/test-cred1 @secret.json
vault kv get kv/rnd/aaa/hello-world/aaa/test-cred1 

# get a specific field
vault kv get -field=password kv/rnd/aaa/hello-world/app/test-cred1

# or via json outputs
vault kv get -format=json kv/rnd/aaa/hello-world/aaa/test-cred1 

# JQ examples for formatting / color
vault kv get -format=json kv/rnd/aaa/hello-world/aaa/test-cred1  | jq
vault kv get -format=json kv/rnd/aaa/hello-world/aaa/test-cred1  | jq .data.data.password
vault kv get -format=json kv/rnd/aaa/hello-world/aaa/test-cred1   | jq -r .data.data.password

### TESTING POLICY
#
# Create a limited user policy
vault policy write aaa aaa-policy.hcl 
# or
vault policy write bbb bbb-policy.hcl 

# Create admin policy
# All the keys
vault policy write admin admin-policy.hcl

# Create provisioner policy
# ie. Read-only
# vault policy write provisioner provisioner-policy.hcl


# Create a token using a specific policy
vault token create -policy=aaa

# OR
vault token create -policy=aaa -period=30m

# Testing permissions/policy examples
# GET THE TOKEN, EXPORT THE VAULT TOKEN AND LOGIN
# USING A NEW SHELL

export VAULT_TOKEN="s.qTNmRhSBmPK1ZPqwfzbvdK9n"
vault login $VAULT_TOKEN

# Write/confirm a secret to a path matching the policy
vault kv put kv/rnd/aaa/hello-world/aaa/test-cred1 @secret.json
vault kv get kv/rnd/aaa/hello-world/aaa/test-cred1

# DENIED WRITE OTHER PATHS
vault kv put kv/rnd/bbb/hello-world/bbb/test-cred1 @secret.json

# DENIED GET OTHER PATHS
vault kv get kv/rnd/aaa/hello-world/aaa/test-cred1
vault kv get kv/rnd/bbb/hello-world/bbb/test-cred1

# TEST ANOTHER POLICY
vault policy write policy-name bbb-policy.hcl
vault token create -policy=bbb -period=30m
vault kv put kv/rnd/bbb/hello-world/bbb/test-cred1 @secret.json

###
# All Functionality also available via HTTP/REST
### 

curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request POST \
    --data '{"username": "jenkins", "password": "jenkins123"}' \
    ${VAULT_ADDR}/v1/kv/dev/aaa/hello-world/aaa/jenkins-cred1
 
# Confirm
vault kv get -format=json kv/dev/aaa/hello-world/aaa/jenkins-cred1

curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request GET \
    ${VAULT_ADDR}/v1/kv/dev/aaa/hello-world/aaa/jenkins-cred1  | jq


# WHEN NOT IN DEV MODE - INIT REQUIRED
# REST API init
# https://www.vaultproject.io/api/system/init.html#parameters
# cat <<EOF > payload.json
# {
#   "secret_shares": 5,
#   "secret_threshold": 3
# }
# EOF

# curl \
#     --request PUT \
#     --data @payload.json \
#     ${VAULT_ADDR}/v1/sys/init > vault_init.json


# LDAP login example: Will not work for this demo/locally. Just for example if on network
# 
# export VAULT_ADDR=https://server:8500
# export VAULT_SKIP_VERIFY=true
# vault login -method=ldap username=userid
 

# curl \
#     --header "X-Vault-Token: ${VAULT_TOKEN}" \
#     --request LIST \
#     http://127.0.0.1:5500/v1/auth/ldap/groups

 

# curl \
#     --header "X-Vault-Token: ${VAULT_TOKEN}" \
#     ${VAULT_ADDR}/v1/auth/ldap/config 

# # ldap group misc examples
# vault write auth/ldap/groups/scientists policies=foo,bar
# vault write auth/ldap/groups/engineers policies=foobar
# vault write auth/ldap/users/tesla groups=engineers policies=zoobar
# vault write auth/ldap/users/userid groups=admins policies=default,admin



 

 



 



 

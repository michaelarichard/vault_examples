# Example Hashicorp Vault Code

https://www.vaultproject.io/

### SlideDeck
[Here](https://drive.google.com/file/d/0B2QHyxb_lX8LeW5KQ2VwdThfaEZlMzBhRnFuazJ0eXZEekww/view?usp=sharing)

### Getting Started
```
docker run --rm --cap-add=IPC_LOCK -p 8200:8200 -d --name=dev-vault vault

```

### Grab the root token
```
docker logs dev-vault
```

### Login:
- http://127.0.0.1:8200

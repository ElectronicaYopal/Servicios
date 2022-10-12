```bash
sudo crontab -u serverelectronica -e
```

```sh
PATH="/usr/local/bin:/usr/bin:/bin:/snap/bin"

*/15 * * * * /home/serverelectronica/Scripts/Manager/Checker.sh >> /home/serverelectronica/Scripts/Servicios/ErrOut.log 2>&1
```

```bash
cat .ngrok2/ngrok.yml
```

```bash
authtoken: 1uGW9cTtGq6Awn6Rg4aJ9cwKIRG_5KpkAWv6WPh2HSA3EHkxy
tunnels:
  ssh:
    addr: 22
    proto: tcp    
  web80:
    addr: 80
    proto: http
    bind_tls: false
  web8080:
    addr: 4200
    proto: http
    bind_tls: false
  web3000:
    addr: 3000
    proto: http
    bind_tls: false
```

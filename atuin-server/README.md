# Configuration
- Update the user in the systemd file, so it can correctly point to these files from systemd.
- Copy the systemd file as noted in that file.
- Modify .env.template to what you want to set.

## Configure ~/.config/atuin/config.toml
Change the following settings:
```
sync_address = "http://192.168.1.x:51234"
auto_sync = true
sync_frequency = "0m"
enter_accept = false
```

# start
Start the service:
```
sudo systemctl daemon-reload
sudo systemctl start atuin
```

# Check that configuration is correct:
```
atuin info
# see if your config is correctly pointing to your server
atuin status
```

# login
```
atuin register
atuin login
```

# Save your key
```
atuin key
```

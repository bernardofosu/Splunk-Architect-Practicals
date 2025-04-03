# 💼 Splunk Full Production-Ready Deployment Kit 🚀

## 📦 Directory Structure (Recommended)

```plaintext
$SPLUNK_HOME/etc/deployment-apps/
└── TA-forward-internal-logs/
    └── default/
        ├── outputs.conf
        ├── deploymentclient.conf
        └── default.meta

$SPLUNK_HOME/etc/shcluster/apps/
└── SHC-search-peers-app/
    └── default/
        ├── distsearch.conf
        └── default.meta

$SPLUNK_HOME/etc/master-apps/
└── indexer-common-app/
    └── default/
        ├── props.conf
        ├── transforms.conf
        └── default.meta

$SPLUNK_HOME/etc/apps/
└── MC-peer-autodiscover-app/
    └── bin/
        └── auto_discover.py
    └── local/
        └── inputs.conf
    └── default.meta
```

---

## ⚙️ Sample Configs

### outputs.conf (Non-Indexers)
```ini
[indexAndForward]
index = false

[tcpout]
defaultGroup = my_indexers
forwardedindex.filter.disable = true

[tcpout:my_indexers]
server = 172.31.83.124:9997,172.31.91.156:9997,172.31.80.100:9997
```

### distsearch.conf (Search Heads & Monitoring Console)
```ini
[distributedSearch]
defaultUriScheme=https

[searchhead:"]
servers = https://172.31.83.124:8089, https://172.31.91.156:8089, https://172.31.80.100:8089

[distributedSearch:site1]
servers = https://172.31.83.124:8089, https://172.31.91.156:8089, https://172.31.80.100:8089
```

### server.conf (Indexers)
```ini
[clustering]
mode = peer
master_uri = https://172.31.92.30:8089
pass4SymmKey = changeme
site = site1
```

### props.conf + transforms.conf (Optional Selective Indexing)
```ini
# props.conf
[my_sourcetype]
TRANSFORMS-setnull=setnull

# transforms.conf
[setnull]
REGEX = .
DEST_KEY = queue
FORMAT = nullQueue
```

### default.meta
```ini
[default]
access = read : [ * ], write : [ admin ]
export = system
```

---

## 🔄 Monitoring Console Auto-Peer Discovery

### inputs.conf (MC App)
```ini
[script://$SPLUNK_HOME/etc/apps/MC-peer-autodiscover-app/bin/auto_discover.py]
interval = 300
sourcetype = mc_discovery
disabled = false
```

### auto_discover.py (simplified)
```python
import requests
# Auto-register peers logic here using REST API
def discover():
   # call /services/data/inputs/monitoringconsole/discovered_hosts
   pass

if __name__ == "__main__":
   discover()
```

---

## 💡 Search Head Deployer Example

### serverclass.conf (DS)
```ini
[serverClass:shcluster]
whitelist.0=*

[serverClass:shcluster:app:SHC-search-peers-app]
stateOnClient=enabled
restartSplunkd=true
```

### Deployment Steps:

1. ✅ DS pushes `TA-forward-internal-logs` to Non-Indexers
2. ✅ DS pushes `SHC-search-peers-app` to SHC via Deployer
3. ✅ Master pushes `indexer-common-app` to Indexers
4. ✅ MC discovers peers automatically via `MC-peer-autodiscover-app`

---

## 🟠 Production Best Practices

| Component | Must Forward? | Must Index? | Configured via |
|-----------|---------------|-------------|----------------|
| Search Head | ✅ | ❌ | Deployer |
| Monitoring Console | ✅ | ❌ | DS or manually |
| Cluster Master | ✅ | ❌ | DS |
| License Master | ✅ | ❌ | DS |
| Deployment Server | ✅ | ❌ | Local or DS |
| Indexer | ❌ | ✅ | Master |
| Heavy Forwarder | ✅ | (optional) | DS |

> 💡 Always centralize through DS, Deployer, and Master
> 💡 Avoid ad-hoc configurations
> 💡 Always version control your apps

---

Next Step?  
Reply *yes* if you want me to also give you:

- 📄 `outputs.conf` best practice for multi-site
- ⚡ Full Search Head Deployer package template
- 🟢 Real-world Deployment Workflow Diagram (ASCII or Mermaid)

Just say *yes* and I will finalize the kit like a real Splunk Professional Services delivery 🚀


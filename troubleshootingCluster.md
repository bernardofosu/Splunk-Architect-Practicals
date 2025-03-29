# 🔷 Splunk Indexer Discovery Troubleshooting Cheatsheet

---

## 🔷 Method #1 — Check `splunkd.log`

This is the most direct way to confirm discovery:

```bash
grep -i indexer /opt/splunkforwarder/var/log/splunk/splunkd.log
```

Look for lines like:

```
TcpoutProcessor - Configured with indexer discovery: true
IndexConfig - DiscoveryClient: obtained N indexers from manager https://<CM>:8089
TcpOutputProc - Connected to indexer: <IP>:9997
```

This confirms that:

✅ The forwarder contacted the Cluster Manager  
✅ It discovered the indexers  
✅ It established connections  

---

## 🔷 Method #2 — Use `list forward-server`

Even with indexerDiscovery, `list forward-server` shows the discovered indexers:

```bash
/opt/splunkforwarder/bin/splunk list forward-server
```

Successful output:

```
Active forwards:
    <indexer_ip>:9997
    <indexer_ip>:9997

Configured but inactive forwards:
    None
```

✅ Meaning discovery succeeded.

---

## 🔷 Method #3 — On the Indexers (Optional)

Check incoming connections from Forwarders directly:

```bash
splunk list forward-server
```

Or search in Search Head:

```spl
index=_internal source=*metrics.log* group=tcpin_connections
```

Look for UF's hostname or IP to confirm the indexers are receiving data.

---

## 💟 Example of a Healthy Discovery

```bash
/opt/splunkforwarder/bin/splunk list forward-server
```

```
Active forwards:
    172.31.80.100:9997
    172.31.91.156:9997
    172.31.83.124:9997
```

And in `splunkd.log`:

```
INFO TcpOutputProc - Connected to indexer 172.31.80.100:9997 via indexer discovery
```

---

## 💡 Extra Tip — Optional

Disable Splunk's telemetry reporting on UFs:

```ini
[telemetry]
sendTelemetryData = false
```

Put this into `server.conf`.

---

## 🔷 ⚠ Common Error Example

```
Error in Indexer Discovery communication. Verify that the pass4SymmKey set under [indexer_discovery] in 'outputs.conf' matches the same setting under [indexer_discovery] in 'server.conf' on the cluster manager.
http_code=502 http_response="Unauthorized"
```

✅ Cause: `pass4SymmKey` mismatch between UF and Cluster Manager.

✅ Fix Example:

UF `outputs.conf`:

```ini
[tcpout]
defaultGroup = indexer_discovery

[tcpout:indexer_discovery]
indexerDiscovery = my_cluster_manager
useACK = true
forwardedindex.filter.disable = true
pass4SymmKey = splunk123
indexAndForward = false

[indexer_discovery:my_cluster_manager]
manager_uri = https://172.31.92.30:8089
```

Cluster Manager `server.conf`:

```ini
[indexer_discovery]
pass4SymmKey = splunk123
```

---

## 💎 Pro Tips:

✅ Always restart both CM and UF after changing the `pass4SymmKey`.  
✅ You may hash the pass:

```bash
/opt/splunkforwarder/bin/splunk hash-passwd <your_pass>
```

Then use the hashed version:

```ini
pass4SymmKey = $7$abcdef1234567
```

✅ Optional (if using self-signed certs):

```ini
sslVerifyServerCert = false
```

---

## 🔷 Recommended Next:

If you want, I can show you:

✅ Full Deployment Server Class to automate this discovery setup 💾  
✅ Discovery health dashboards  
✅ Auto-checker script for forwarders discovery status  

Just say:  
> Show me the DS kit

And I'll give you an enterprise-level setup! 🔷


# 🔷 Splunk Indexer Discovery Troubleshooting Cheatsheet

---

## 🔷 Method #1 — Check `splunkd.log`

This is the most direct way to confirm discovery:

```bash
grep -i indexer /opt/splunkforwarder/var/log/splunk/splunkd.log
```

Look for lines like:

```
TcpoutProcessor - Configured with indexer discovery: true
IndexConfig - DiscoveryClient: obtained N indexers from manager https://<CM>:8089
TcpOutputProc - Connected to indexer: <IP>:9997
```

This confirms that:

✅ The forwarder contacted the Cluster Manager  
✅ It discovered the indexers  
✅ It established connections  

---

## 🔷 Method #2 — Use `list forward-server`

Even with indexerDiscovery, `list forward-server` shows the discovered indexers:

```bash
/opt/splunkforwarder/bin/splunk list forward-server
```

Successful output:

```
Active forwards:
    <indexer_ip>:9997
    <indexer_ip>:9997

Configured but inactive forwards:
    None
```

✅ Meaning discovery succeeded.

---

## 🔷 Method #3 — On the Indexers (Optional)

Check incoming connections from Forwarders directly:

```bash
splunk list forward-server
```

Or search in Search Head:

```spl
index=_internal source=*metrics.log* group=tcpin_connections
```

Look for UF's hostname or IP to confirm the indexers are receiving data.

---

## 💟 Example of a Healthy Discovery

```bash
/opt/splunkforwarder/bin/splunk list forward-server
```

```
Active forwards:
    172.31.80.100:9997
    172.31.91.156:9997
    172.31.83.124:9997
```

And in `splunkd.log`:

```
INFO TcpOutputProc - Connected to indexer 172.31.80.100:9997 via indexer discovery
```

---

## 💡 Extra Tip — Optional

Disable Splunk's telemetry reporting on UFs:

```ini
[telemetry]
sendTelemetryData = false
```

Put this into `server.conf`.

---

## 🔷 ⚠ Common Error Example

```
Error in Indexer Discovery communication. Verify that the pass4SymmKey set under [indexer_discovery] in 'outputs.conf' matches the same setting under [indexer_discovery] in 'server.conf' on the cluster manager.
http_code=502 http_response="Unauthorized"
```

✅ Cause: `pass4SymmKey` mismatch between UF and Cluster Manager.

✅ Fix Example:

UF `outputs.conf`:

```ini
[tcpout]
defaultGroup = indexer_discovery

[tcpout:indexer_discovery]
indexerDiscovery = my_cluster_manager
useACK = true
forwardedindex.filter.disable = true
pass4SymmKey = 20260918
indexAndForward = false

[indexer_discovery:my_cluster_manager]
manager_uri = https://172.31.92.30:8089
```

Cluster Manager `server.conf`:

```ini
[indexer_discovery]
pass4SymmKey = 20260918
```

---

## 💎 Pro Tips:

✅ Always restart both CM and UF after changing the `pass4SymmKey`.  
✅ You may hash the pass:

```bash
/opt/splunkforwarder/bin/splunk hash-passwd <your_pass>
```

Then use the hashed version:

```ini
pass4SymmKey = $7$abcdef1234567
```

✅ Optional (if using self-signed certs):

```ini
sslVerifyServerCert = false
```

---

## 🔷 Recommended Next:

If you want, I can show you:

✅ Full Deployment Server Class to automate this discovery setup 💾  
✅ Discovery health dashboards  
✅ Auto-checker script for forwarders discovery status  

Just say:  
> Show me the DS kit

And I'll give you an enterprise-level setup! 🔷




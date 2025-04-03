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



🔴 Issue:
```sh
splunk@clustermanager:/opt/splunk/bin$ cat /opt/splunk/var/log/splunk/splunkd.log | grep Detention
03-28-2025 23:56:34.148 +0000 INFO  CMPeer [1253 CMMasterServiceThread] - peer=44D63DC8-AC53-40E6-AD72-00C75DD53EB9 peer_name=site1_indexer_02 transitioning from=Up to=AutomaticDetention reason="peer is blocked"
03-28-2025 23:56:57.652 +0000 INFO  CMPeer [1253 CMMasterServiceThread] - peer=6EE2E225-2EAE-4F21-8DA6-F773BAA8653E peer_name=site1_ndexer_03 transitioning from=Up to=AutomaticDetention reason="peer is blocked"
03-28-2025 23:57:26.653 +0000 INFO  CMPeer [1253 CMMasterServiceThread] - 
```
```sh
The index processor has paused data flow. 
Current free disk space on partition '/' has fallen to 4218MB, below the minimum of 5000MB.

Search peer site1_ndexer_03 has the following message: The index processor has paused data flow. Current free disk space on partition '/' has fallen to 4218MB, below the minimum of 5000MB. Data writes to index path '/opt/splunk/var/lib/splunk/audit/db'cannot safely proceed. Increase free disk space on partition '/' by 
```
Splunk auto-protects itself when disk space is below 5 GB by entering a "paused" state (it will not index or replicate data) → which also causes detention in cluster status.
```sh
df -h
```
⚠ Notes:

    The detention here is not caused by pass4SymmKey for site1_indexer_03 but by low disk space.

    Still, you should double-check all peers for both:

        Matching pass4SymmKey

        Enough disk space

# ✔️ Steps to Increase EBS Volume of an EC2 Instance

## Step 1: Go to EC2 Console

🔹 **Navigate to EC2** → **Volumes**

🔹 **Find the volume** attached to your indexer (e.g., `/dev/xvda`)

🔹 **Right-click** → **Modify Volume**

---

## Step 2: Set New Size

🔹 Enter a **larger size** like **50 GB** or **100 GB** (up to you)

🔹 Click **Modify** → **Confirm**

---

## Step 3: Expand Partition Inside the Instance (VERY IMPORTANT)

After modifying the EBS volume, go back to the instance and run:

```bash
# Check disk name (usually xvda)
lsblk

# Grow the partition
sudo growpart /dev/xvda 1

# Resize filesystem
sudo resize2fs /dev/xvda1

# Check disk again
df -h
```

✅ **You will now see your disk as 50GB or more**, and Splunk will exit detention automatically after restart or timeout.

---

## ✅ Notes:

✔️ **Your data will not be lost.**

✔️ **You do not need to stop the EC2 instance.**

✔️ **You do not need to change instance type** unless you want more CPU/RAM.

✔️ **This is 100% safe** if you only resize EBS. 🚀


The real problem is likely Splunk buckets and internal Splunk data.

Let's check the big consumers under /opt/splunk/var/lib/splunk/:
🔄 Run this:
```sh
sudo du -sh /opt/splunk/var/lib/splunk/*
```

✅ Step-by-Step Targeted Check:

From the Cluster Manager (assuming CM is also in Site1):

ping 172.31.83.124
ping 172.31.91.156
ping 172.31.80.100

nc -vz 172.31.83.124 8089
nc -vz 172.31.91.156 8089
nc -vz 172.31.80.100 8089

sudo vi /opt/splunk/etc/system/local/server.conf

cat /opt/splunk/etc/system/local/server.conf | grep manager_uri

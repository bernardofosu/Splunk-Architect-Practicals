# 🌟 Splunk Best Practices — Forwarding vs Indexing (Production Ready)

## ✅ Why This Matters?

In Splunk Distributed Environments:

- 💡 **Only Indexers should index**
- 🕖 **Non-indexers** (Search Head, Cluster Master, License Master, Monitoring Console, Deployment Server, Deployer) **should only forward their logs to Indexers**

---

## ⚙️ Recommended Forward-Only Setup for Non-Indexers

Create an app
```sh
cd /opt/splunk/etc/apps
mkdir -p all_internal_logs/local
vi outputs.conf
```
### For Static Indexer Forwarding (no indexer discovery):
```sh
[indexAndForward]
index = false          

[tcpout]
defaultGroup = my_search_peers
forwardedindex.filter.disable = true   
indexAndForward = false               

[tcpout:my_search_peers]
server = 172.31.83.124:9997,172.31.91.156:9997,172.31.80.100:9997
```


### ✅ What does this do?
| Setting | Meaning |
|---------|---------|
| `index = false` | ❌ Disables local indexing completely |
| `forwardedindex.filter.disable = true` | ✅ Forwards ALL events (including internal logs) |
| `indexAndForward = false` | ✅ Confirms forward-only mode under `tcpout` |
| `defaultGroup` | 🚦 Specifies indexers (IP:port list) |

### ❌ Avoid this:
```ini
[tcpout]
disabled = true   # 💀 This stops ALL forwarding (do not use on SH, CM, MC, etc.)
```

---

## 🔶 Config #1 — Pure Forwarder (Recommended for Non-Indexers)

**Used for:**

- 🔵 Search Head (SH)
- 🔶 Cluster Master (CM)
- 🟢 Monitoring Console (MC)
- 🟡 License Master (LM)
- 🟤 Deployment Server (DS)
- 🟠 Deployer

```ini
[indexAndForward]
index = false

[tcpout]
defaultGroup = my_indexers
forwardedindex.filter.disable = true

[tcpout:my_indexers]
server = 172.31.83.124:9997,172.31.91.156:9997,172.31.80.100:9997
```

---

## 🔶 Config #2 — Selective Indexing Mode (⚠️ Advanced)

**Used when:**

- You need **some** data indexed locally
- And forward the rest

```ini
[indexAndForward]
index = true
selectiveIndexing = true

[tcpout]
defaultGroup = my_search_peers
forwardedindex.filter.disable = true
indexAndForward = false

[tcpout:my_search_peers]
server = 172.31.83.124:9997,172.31.91.156:9997,172.31.80.100:9997
```

### 🔎 Requires:
- `props.conf`
- `transforms.conf`

---

## ✅ Typical Real-World Behavior
| Component | Should it index? | Should it forward logs? |
|-----------|----------------|---------------------|
| Indexer | ✅ Yes | ❌ Usually not |
| Search Head | ❌ No | ✅ Yes |
| Cluster Master | ❌ No | ✅ Yes |
| License Master | ❌ No | ✅ Yes |
| Monitoring Console | ❌ No | ✅ Yes |
| Deployment Server | ❌ No | ✅ Yes |
| Heavy Forwarder | ⚠️ Optional | ✅ Yes |

---

## ✅ Why Centralize?

- 💎 Cleaner Monitoring Console
- 💎 Avoids wasting disk space on SH / CM / LM / MC
- 💎 Consistent internal logs from all components
- 💎 Standard practice in Enterprise Splunk

---

## ⚠️ Common Mistake
```ini
[tcpout:my_search_peers]
server = 1.2.3.4:9997

[tcpout:my_search_peers]
server = 5.6.7.8:9997
```
❌ **Only the last stanza will take effect!**

### ✅ Correct:
```ini
[tcpout:my_search_peers]
server = 1.2.3.4:9997,5.6.7.8:9997
```

---

## ✅ Pro Tip — Recommended Deployment App Structure

```
TA-forward-internal-logs/
├── default/
│   ├── outputs.conf
│   ├── deploymentclient.conf (optional)
└── metadata/
    └── default.meta (optional)
```

- 🟢 Push via Deployment Server
- 🟢 Automatically apply to all non-indexers
- 🟢 No need to configure each node manually

---

## ✅ TL;DR
| Action | Recommendation |
|--------|---------------|
| Forward logs only | `index = false` |
| Selective local indexing | `index = true + selectiveIndexing = true` |
| Stop forwarding | ❌ `disabled = true` (do NOT use for SH, CM, MC, etc.) |

---

## ✅ Components Needing This Configuration

Here is your requested list:

- 🔵 Search Head (SH)
- 🔶 Cluster Master (CM)
- 🟢 Monitoring Console (MC)
- 🟡 License Master (LM)
- 🟤 Deployment Server (DS)
- 🟠 Deployer
- ⚪ Heavy Forwarder (HF) — optional depending on role


### ✅ Example `props.conf`
```ini
[source::.../my_special_logs.log]
TRANSFORMS-set_local_index = set_local_index
```

### ✅ Example `transforms.conf`
```ini
[set_local_index]
REGEX = (CRITICAL_EVENT)
DEST_KEY = _INDEX
FORMAT = my_local_index
```

#### **Result:**
- Only logs matching `CRITICAL_EVENT` will be locally indexed into `my_local_index`.
- All other logs will be forwarded normally.

---

## 📋 Recommended Deployment App Structure

```
TA-forward-internal-logs/
├── default/
│   ├── outputs.conf
│   ├── deploymentclient.conf  # Optional (connects to DS)
│   ├── props.conf             # Optional (only for selective indexing cases)
│   ├── transforms.conf        # Optional (only for selective indexing cases)
└── metadata/
    └── default.meta           # Optional permissions
```

### 🟢 Benefits of Using a Deployment App:
- 📂 Push via **Deployment Server**
- 🛠️ Automatically apply to **all non-indexers**
- ✅ No need to configure each node manually

---

## 🌟 TL;DR Best Practice Summary

| Component | Local Indexing | Forwarding |
|-----------|---------------|------------|
| Non-Indexer (SH, CM, LM, MC, DS, Deployer) | ❌ Disabled | ✅ Enabled |
| Indexer | ✅ Enabled | ⚠️ Optional |
| Heavy Forwarder | ⚠️ Optional | ✅ Usually Enabled |

### 📘 Notes:
- Always keep configs versioned inside an **App** (e.g., `TA-forward-internal-logs`)
- 📂 Push via **Deployment Server** to all non-indexers
- ⚠ Avoid duplicate `[tcpout:group]` stanzas
- ⚠️ Use **selective indexing** only if absolutely needed (e.g., **banks, telecoms, SIEM scenarios**)

---

This setup ensures **scalability, efficiency, and compliance** in **Enterprise Splunk environments**. 🚀




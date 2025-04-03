# 💯 Splunk Search Head Clustering (SHC) Admin Mini-Kit

## ✅ Search Head Clustering Overview

When you enable Search Head Clustering (SHC), Splunk hides or moves some settings because the cluster now controls them centrally through the captain. This prevents accidental misconfiguration.

---

## ✅ What Happens After Enabling SHC?

| Feature                     | Behavior |
|-----------------------------|----------|
| **Distributed Search**      | Renamed to **Search Head Clustering** |
| **Indexes and Inputs**      | Some options hidden, use Deployer for app & configuration management |
| **Server Settings**         | Only the Captain handles certain configurations |
| **Forwarder Management**    | Removed from SHC members, use a Deployment Server instead |

💡 **Notes:**
- SHC-specific pages are now found under: `Settings > Search Head Clustering`
- Configuration changes should be applied via **deployer bundle pushes**, not manual edits.
- Even **Knowledge Objects replication** is now managed by the Captain.

### Example of UI Changes:

| Before SHC                | After SHC                      |
|---------------------------|--------------------------------|
| Settings > Distributed Search | Settings > Search Head Clustering |
| Settings > Data Inputs    | **Removed** |
| Settings > Forwarder Management | **Removed** |
| Settings > Indexes        | **Removed** |
| Settings > General Settings | **Removed or Limited** |

---

## 🟣 Why Are These Settings Removed?

Because SHC uses **Captain Authority**:
- 🚀 **Captain pushes bundles**
- 🔄 **Captain manages knowledge object replication**
- 🛑 **Prevents split-brain configurations**

### Where Do You Manage These Now?

| Config                      | Managed by |
|-----------------------------|------------|
| **Search Head Cluster Settings** | Captain only |
| **Apps, Inputs, Indexes, Props, Transforms** | Use **Deployer** |
| **Forwarders** | Use **Deployment Server** |
| **Licensing** | Still available on all Search Heads |

✅ **Tip:** If you check the UI on the Captain node, you will see slightly more settings compared to non-captains, but still reduced compared to a standalone search head.

---

## 💼 SHC Admin Cheatsheet

### ✅ Day-to-Day SHC Admin Commands

| Task | Command |
|------|---------|
| **Check SHC Status** | `./splunk show shcluster-status -auth admin:pass` |
| **Check Conf Replication Status** | `./splunk show shcluster-replication-status -auth admin:pass` |
| **Bootstrap Captain (Only Once)** | `./splunk bootstrap shcluster-captain -servers_list "<list>" -auth admin:pass` |
| **Rolling Restart** | `./splunk rolling-restart shcluster-members -auth admin:pass` |
| **Apply Deployer Bundle** | `./splunk apply shcluster-bundle -target https://deployer:8089 -auth admin:pass` |
| **Remove Search Head from SHC** | `./splunk remove shcluster-member -auth admin:pass` |

---

## ✅ Best REST APIs for Monitoring & Troubleshooting

| Purpose | REST Endpoint |
|---------|--------------|
| **Captain Status** | `GET /services/shcluster/captain/info` |
| **Members Status** | `GET /services/shcluster/member/info` |
| **Search Head Peers** | `GET /services/shcluster/members` |
| **Conf Replication Status** | `GET /services/shcluster/status` |
| **Search Jobs Running** | `GET /services/search/jobs` |
| **Current Bundle Check** | `GET /services/shcluster/config` |

### 🖥️ Example Command:
```bash
curl -ku admin:pass https://<SH>:8089/services/shcluster/status?output_mode=json | jq
```

---

## ✅ Search Head Captain Election Explained

When you run:
```bash
./splunk bootstrap shcluster-captain -servers_list "https://172.31.24.196:8089,https://172.31.28.177:8089,https://172.31.86.130:8089" -auth admin:pass
```
👉 The node executing this command **immediately becomes the Captain** upon successful bootstrap.

### 💡 Why?
- 🏆 **Captain Election is Triggered Automatically**
- 🛑 Since no other Captain exists yet, this node wins by default.
- 🚀 Once elected, it manages:
  - 🍰 **Configuration Replication**
  - 🔄 **Rolling Restarts**
  - 🕵️‍♂️ **Search Artifact Replication**
  - 🧩 **Bundle Distribution**

---

## ✅ Managing Deployer & Bundle Pushes

### 🟣 Deployer Directory Structure
📁 The Deployer pushes configurations from:
```bash
/opt/splunk/etc/shcluster/apps/
```

### Typical Workflow:
1️⃣ Place your apps/configs under:
```bash
/opt/splunk/etc/shcluster/apps/my_custom_app/
/opt/splunk/etc/shcluster/apps/search_config_baseline/
```
2️⃣ Check bundle status:
```bash
./splunk show shcluster-bundle-status -auth admin:<password>
```
3️⃣ Push the bundle to SHC:
```bash
./splunk apply shcluster-bundle -auth admin:<password>
```
✅ **All Search Heads receive and apply the bundle.**

💡 **Important Notes:**
- **Only content inside `/shcluster/apps/` is deployed.**
- This includes:
  - `default/`
  - `local/`
  - `metadata/`
  - `bin/`
  - Static files, macros, custom search commands, etc.
- The `README` file in `/apps/` is just a placeholder.
- Anything under `/shcluster/users/` will also be bundled **if user-level objects are included** (not common in production).

---

## ✅ Bonus: SHC Health Checkpoints

### ✅ Check SHC Status
```bash
./splunk show shcluster-status -auth admin:pass
```

### ✅ Check Captain Election Status
```bash
curl -ku admin:pass https://<SH>:8089/services/shcluster/captain/info?output_mode=json | jq
```

### ✅ Check Replication Issues
```bash
./splunk show shcluster-replication-status -auth admin:pass
```

---

## 🚀 Want More?

If you need more resources, I can provide:
- ✅ **Full Table of SHC Setting Changes** (What disappears, where it moves, and how to configure it now)
- ✅ **SHC Admin Workflow Cheat Sheet**
- ✅ **Captain Election Logic Diagram**
- ✅ **Bonus: UI Screenshot Mockup of SHC in Action**

Let me know! 🎯


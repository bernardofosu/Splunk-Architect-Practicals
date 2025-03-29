# 🚀 Deploy a Search Head Cluster

This guide covers the key steps needed to configure and start a **[Search Head Cluster](https://docs.splunk.com/Documentation/Splunk/9.4.1/DistSearch/SHCdeploymentoverview)** in Splunk.

[Search head clustering architecture](https://docs.splunk.com/Documentation/Splunk/9.4.1/DistSearch/SHCarchitecture)
---
## 🔍 Parts of a Search Head Cluster

A **Search Head Cluster** consists of multiple search heads that share configurations, job scheduling, and search artifacts. The components include:

- **Cluster Members**: The search heads in the cluster.
- **Cluster Captain**: Coordinates job and replication activities among members.
- **Deployer**: Distributes apps and configurations to cluster members.
- **Search Peers**: Indexers that the search heads run searches against.
- **Load Balancer**: (Optional) Directs user traffic across search heads.

📌 *The cluster captain role may shift among members over time.*

### That's a clean and complete Search Head Cluster + Deployer documentation already.
- 🟣 Search Head Cluster members setup
- 💡 Deployer configuration
- ⚙️ Cluster bootstrap + post-deployment tasks
- 🔍 Validation commands

## 📌 Deploy the Cluster

### 1️⃣ Identify Your Requirements

- **Cluster Size**: Define the number of search heads based on search load and availability needs.
- **Replication Factor**: Decide how many copies of search artifacts should be maintained.
- **Indexer Setup**: Choose between standalone indexers or an indexer cluster.
- **System Requirements**: Review system specs and deployment considerations.

---
### 2️⃣ Set Up the Deployer

🔹 **Select a Splunk instance** to act as the deployer. It must be separate from the cluster members.

🔹 **Configure the security key** in `server.conf`:

```ini
[shclustering]
pass4SymmKey = yoursecuritykey
shcluster_label = shcluster1
```
#### You cannot repeat the same stanza header twice.
- Every stanza should be opened once and contain all relevant keys under it.
- If you define [shclustering] twice, only the second one will be used, the first will be ignored.

🔹 **Set the cluster label**:

```ini
[shclustering]
shcluster_label = shcluster1
```

🔹 Restart the deployer to apply changes.

```bash
/opt/splunk/bin/splunk restart
./splunk restart
```

---
### 3️⃣ Install Splunk Enterprise Instances

📌 Always use fresh Splunk instances for cluster members.

```bash
splunk start
splunk enable boot-start
```

⚠️ *Change the default admin password on each instance!*

---
### 4️⃣ Initialize Cluster Members

Run the following command on each search head:

```bash
splunk init shcluster-config -auth <username>:<password> \
    -mgmt_uri <URI>:<management_port> \
    -replication_port <replication_port> \
    -replication_factor <n> \
    -conf_deploy_fetch_url <URL>:<management_port> \
    -secret <security_key> \
    -shcluster_label <label>
```

Then restart Splunk:

```bash
splunk restart
```

---
### 5️⃣ Bootstrap the Cluster Captain

Select one instance and run:

```bash
splunk bootstrap shcluster-captain -servers_list "<URI>:<management_port>,<URI>:<management_port>,..." -auth <username>:<password>
```

⚠️ The `-servers_list` must match the `-mgmt_uri` values set during initialization!

---
### 6️⃣ Perform Post-Deployment Setup

✅ **Connect the Search Head Cluster to Search Peers:**

- For **indexer clusters**, follow [this guide](#).
- For **standalone indexers**, follow [this guide](#).

✅ **Add Users:** Manage access roles for different users.

✅ **Install a Load Balancer (Optional):** Helps distribute user traffic efficiently.

✅ **Use the Deployer:** To push apps and config updates across the cluster.

---
## 🔍 Check Search Head Cluster Status

Run the following command from any cluster member:

```bash
splunk show shcluster-status -auth <username>:<password>
```

For KV Store status:

```bash
splunk show kvstore-status -auth <username>:<password>
```





## ⚙️ Explanation of Steps to Configure a Search Head Cluster Using CLI for the above commands

Configuring a Search Head Cluster (SHC) involves three key steps:

### ✅ 1. Initialize the First Search Head (as the Cluster Captain)

```powershell
splunk init shcluster-config -auth admin:changeme \
-mgmt_uri https://<search_head_1>:8089 \
-replication_port 8080 \
-replication_factor 3 \
-conf_deploy_fetch_url https://<deployer>:8089 \
-shcluster_label <cluster_label>
```

🔎 **Explanation:**

- `splunk init shcluster-config`: This command initializes the search head cluster configuration on the node.
- `-auth admin:changeme`: Specifies the username and password for authentication. *(Use a strong password in practice.)*
- `-mgmt_uri https://<search_head_1>:8089`: The management URI of the search head. Port **8089** is the default Splunk management port.
- `-replication_port 8080`: Defines the port for knowledge object replication between search heads. Ensure this port is open for communication.
- `-replication_factor 3`: Indicates how many copies of knowledge objects (like dashboards, reports, and alerts) should be replicated across the cluster.
- `-conf_deploy_fetch_url https://<deployer>:8089`: URL of the deployer (a separate Splunk instance responsible for pushing configurations to the cluster).
- `-shcluster_label <cluster_label>`: A label to identify the cluster.

**You typically specify this only once when initializing the first search head to configure the replication factor for the cluster.**

**The other search heads joining the cluster do not need this flag. They will inherit the replication factor from the cluster configuration.**

**you need at least three search heads to form a proper search head cluster and ensure high availability.**

📌 **Note:** This first search head is not automatically the captain. The captain will be elected during the bootstrapping step.

---

### ✅ 2. Add Other Search Heads to the Cluster

For each additional search head, run the following command:

```bash
splunk init shcluster-config -auth admin:changeme \
-mgmt_uri https://<search_head_2>:8089 \
-replication_port 8080 \
-conf_deploy_fetch_url https://<deployer>:8089 \
-shcluster_label <cluster_label>
```

🔎 **Explanation:**

- `-mgmt_uri`: Specifies the management URI of the second search head.
- `-conf_deploy_fetch_url`: Points to the same deployer for configuration management.
- `-shcluster_label`: Must match the same label as the first search head to ensure they join the same cluster.

📌 **Repeat** this command for each additional search head you want to add to the cluster.

---

### ✅ 3. Bootstrap the Cluster (Elect a Captain)

Once all search heads are initialized, choose one search head and run the following command:

```bash
splunk bootstrap shcluster-captain \
-servers_list "https://<search_head_1>:8089,https://<search_head_2>:8089,https://<search_head_3>:8089" \
-auth admin:changeme
```
```sh
splunk bootstrap shcluster-captain \
-servers_list "https://172.31.10.101:8089,https://172.31.10.102:8089,https://172.31.10.103:8089" \
-auth admin:MySecurePass123
```
🔎 **Explanation:**

- `splunk bootstrap shcluster-captain`: This command triggers the captain election process and bootstraps the cluster.
- `-servers_list`: Provide a comma-separated list of all search head management URIs for cluster communication.
- `-auth admin:changeme`: Authenticates using the admin account.

---

## ⚡ **What Happens During Bootstrap?**

- The search heads communicate using the **RAFT Consensus Algorithm** to elect a captain.
- The captain takes responsibility for:
  - Coordinating search requests
  - Managing knowledge object replication
  - Monitoring cluster health
- You can monitor the cluster using CLI or the Splunk Web UI.

---

## ✅ **Next Steps After Bootstrap**

### 🔎 **Verify Cluster Status**
```bash
splunk show shcluster-status -auth admin:changeme
./splunk show shcluster-status -auth admin:splunk123
```

### 🛡 **Manage and Monitor**
- Access the Splunk Web UI → **Settings → Distributed Environment → Search Head Clustering**.

### 📦 **Deploy Apps and Configurations**
- Use the deployer to push configurations to all search heads.


# 💯 Splunk Search Head Cluster Multi-Site Explained

## ✅ Deployer Role & Placement

💡 **The Deployer is NOT part of the Search Head Cluster**

| Role | Site 1 | Site 2 | Outside Sites |
|------|--------|--------|---------------|
| Search Head Member 1 | ✔️ | | |
| Search Head Member 2 | ✔️ | | |
| Search Head Member 3 | ✔️ | | |
| Search Head Member 4 | | ✔️ | |
| Search Head Member 5 | | ✔️ | |
| Search Head Member 6 | | ✔️ | |
| Deployer | Optional | Optional | ✔️ External box |

### 👉 Real-World Placement Notes:
- The Deployer simply **pushes configs and apps** to the SHC.
- It does **NOT participate** in clustering, captain election, or searches.
- It is usually placed **closer to the majority of SHs** for low-latency pushes.
- Often placed in **Site 1** if it's the main datacenter.

---

## ✅ Minimum Search Head Cluster Requirement

| ✔ What Splunk Requires | ✔ What Production Wants |
|-----------------------|------------------------|
| Minimum = **3 SHC members** total | Recommended = **3 SHs per site** (for HA) |

---

### ✨ Example 1 (valid):
| Search Head | Site |
|-------------|------|
| sh1 | Site 1 |
| sh2 | Site 1 |
| sh3 | Site 2 |

Total = **3 members** → ✅ Valid SHC

---

### ✨ Example 2 (also valid):
| Search Head | Site |
|-------------|------|
| sh1 | Site 1 |
| sh2 | Site 2 |
| sh3 | Site 2 |

Total = **3 members** → ✅ Valid SHC

---

## ✅ Why people often aim for "3 per site"?

- 🟣 **Site-level HA** → Survive if one site goes down.
- 🟣 **Captain Election Stability** → Needs odd number.
- 🟣 **Disaster Recovery Friendly**.

---

## 🟣 Recommended Production Setup:

For critical environments:

- 3+ search heads in **each site**.
- Deployer close to the majority or primary site.
- Well-tuned captain election settings.

---

## 💡 Next-Level Tips I can give you:

1. Multi-site SHC ASCII Diagram
2. Captain Election Rules Cheat Sheet
3. Ready-to-use `server.conf` and `shclustering.conf` multi-site samples
4. Deployer + SHC Folder Structure (Production)

Reply with **yes** and I will make it like a Splunk Architect's private playbook. 🚀


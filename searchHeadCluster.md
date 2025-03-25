## ⚙️ Explanation of Steps to Configure a Search Head Cluster Using CLI

Configuring a Search Head Cluster (SHC) involves three key steps:

### ✅ 1. Initialize the First Search Head (as the Cluster Captain)

```bash
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
```

### 🛡 **Manage and Monitor**
- Access the Splunk Web UI → **Settings → Distributed Environment → Search Head Clustering**.

### 📦 **Deploy Apps and Configurations**
- Use the deployer to push configurations to all search heads.

---

Would you like additional guidance on deploying apps, monitoring the cluster, or troubleshooting issues? 😊


## 🟢 Adding a Search Head to a Splunk Cluster

In your setup with **one Splunk manager node**, **three peers**, and **one search head**, adding or configuring a search head involves:

### ✅ Ensure Search Head Connectivity
- Verify that the search head can communicate with the manager node and indexer peers over the necessary ports (**default is 8089**).

### 🚀 Add Search Head to Cluster
On the search head, run the following commands:
```bash
./splunk edit cluster-config -mode searchhead -manager_uri https://<manager-node>:8089 -auth <username>:<password>
./splunk restart
```
This configures it to communicate with the cluster as a search head.

### 🔎 Validate Configuration
On the manager node, check the status:
```bash
./splunk show cluster-status
```

### 🖥️ Perform a Search
- Access the search head via the **Web UI**:
  ```
  https://<search-head-ip>:8000
  ```
- Verify that you can query data from the indexers.

---

## 🟢 Adding a Search Head Using Splunk Web UI

### Step 1: Log In to the Search Head
- Open a browser and navigate to:
  ```
  http://<search-head-ip>:8000
  ```
- Log in using your Splunk **admin credentials**.

### Step 2: Configure the Search Head
- Go to **Settings → Indexer Clustering**.
- Click **Edit** to configure cluster settings.
- Select **Enable Indexer Clustering**.
- Choose **Search Head** as the node type.
- Provide the following information:
  - **Manager Node URI:** `https://<manager-node-ip>:8089`
  - **Replication Port:** *(Not required for search heads)*
  - **Security Key:** *(Must match the cluster's security key)*
- Click **Save**.

### Step 3: Restart Search Head
- After saving, Splunk will prompt you to restart.
- Click **Restart Now**.

### Step 4: Verify the Search Head Status
- Log back into the search head.
- Go to **Settings → Indexer Clustering → View Cluster Status**.
- Confirm that the search head is connected to the manager node and can search across the indexer peers.

---

## 🟢 Adding Multiple Search Heads to the Cluster
If you have **three search heads**, follow the same process for each. However, it's recommended to create a **Search Head Cluster (SHC)** for better management.

### ✅ Steps to Add Multiple Search Heads

#### **Step 1: Perform Initial Setup on Each Search Head**
- Follow the previous steps on each search head to connect them to the manager node.
- Ensure the same **Manager Node URI** and **Security Key** are used.

#### **Step 2: Form a Search Head Cluster (Optional but Recommended)**
To manage multiple search heads effectively:

- Designate one of the search heads as a **Captain** *(or allow Splunk to elect one)*.
- On each search head, go to:
  ```
  Settings → Search Head Clustering → Enable Search Head Clustering
  ```
- Provide the following details:
  - **Replication Port:** *(default is 8080)*
  - **Replication Factor:** *(typically 3 for three search heads)*
  - **Security Key**
  - **Cluster Member Management URI:** `https://<search-head-ip>:8089`
- Restart Splunk on all search heads.

#### **Step 3: Verify Cluster Status**
- Go to **Settings → Search Head Clustering → View Cluster Status**.
- Ensure all three search heads are visible and operational.

---

Let me know if you'd like further troubleshooting steps or additional configurations! 🚀


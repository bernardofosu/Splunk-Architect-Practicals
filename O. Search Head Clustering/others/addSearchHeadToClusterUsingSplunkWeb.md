## 🟢 When You Add a Search Head to an Indexer Cluster

When you add a search head to an indexer cluster using the manager node, the search head no longer needs the indexers configured as search peers. The cluster manager handles the communication between the search head and the indexers.

### ✅ After Adding to the Cluster

- The search head will automatically discover and communicate with the indexers in the cluster.
- You don't need to manually manage search peers since the manager node coordinates everything.
- The search head will see data from all indexers in the cluster.

---

## 🚀 How to Remove Search Peers After Joining the Cluster

If you’ve already added the search head to the cluster, follow these steps to remove the previously configured search peers:

### Step 1: Log in to the Search Head

- Go to `http://<search-head-ip>:8000`
- Log in using your admin credentials.

### Step 2: Navigate to Distributed Search Settings

- From the top menu, go to **Settings** → **Distributed Search** → **Search Peers**.

### Step 3: Remove the Search Peers

- You will see a list of manually added search peers.
- Click **Remove** next to each indexer that is now part of the cluster.

### Step 4: Confirm Cluster Status

- After removing the search peers, go to **Settings** → **Indexer Clustering** → **View Cluster Status**.
- Ensure the search head is connected to the cluster and all data is accessible.

---

## 🔎 Verification

Perform a simple search to confirm the configuration:

```splunk
index=* | stats count by host
```

- Confirm that data from all indexers is visible.
- If any issues arise, check the cluster status using the manager node.

---

Enjoy streamlined data access and centralized management with your indexer cluster! 🚀



## ✅ Steps to Remove Search Peers in This Case

### 1. **Disable the Search Head from the Cluster**

- Go to the search head UI: `http://<search-head-ip>:8000`
- Navigate to **Settings → Indexer Clustering**.
- Click **Disable Indexer Clustering**.
- Confirm the action.

### 2. **Remove the Search Peers**

If you're seeing the error **"Cannot remove peer=https://<indexer-ip>:8089. This peer is a part of a cluster"**, it means the search head is part of the indexer cluster.

You cannot directly remove the search peers from the search head since the cluster manager controls the communication

- Go to **Settings → Distributed Search → Search Peers**.
- You should now be able to remove the search peers without errors.

### 3. **Restart Splunk (if required)**

```bash
./splunk restart
```

### 4. **Verify Changes**

- After the restart, go to **Settings → Indexer Clustering → View Cluster Status** and ensure the search head is no longer part of the cluster.

---

This will allow you to manage search peers manually without the restrictions of the cluster. Let me know if you'd like additional help with commands! 😊


## ✅ Scenario: Rejoining a Search Head to the Cluster

If you're asking whether a search head can regain access to data from all indexers after it has been:

- Removed from the cluster and had its search peers manually added.
- Rejoined to the cluster later on.

### ✅ Answer
Yes, once you rejoin the search head to the cluster, it will **no longer use the manually added search peers**. Instead, it will automatically get access to all indexers managed by the cluster.

---

## 🔎 Why?

- The cluster manager (also called the indexer cluster master) will manage the connection between the search head and all indexers.
- You don't need to manually configure search peers when the search head is part of the cluster.
- All data from the indexers will be visible to the search head through cluster management.

---

## ⚙️ What Happens When You Rejoin the Cluster?

- The search head will **stop using manually added search peers.**
- It will rely on the **cluster manager for data discovery.**
- You can run searches and access data from all indexers in the cluster.
- **You cannot manually remove cluster-managed peers.**

---

## 🚀 Next Steps

- If you've already removed it from the cluster, you can simply **rejoin it using the manager node.**
- After rejoining, check the cluster status using the UI:
  
  **Settings → Indexer Clustering → View Cluster Status**

- Run a test search to confirm data visibility:
  
  ```spl
  index=* | stats count by host
  ```

---

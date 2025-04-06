## ✅ Using Distributed Search Without an Indexer Cluster

You can configure distributed search without making the search head part of an indexer cluster.

- Instead of participating in cluster management, the search head simply queries the indexers for data.
- The indexers remain independent, and the search head is only used for running searches.

## ⚙️ How It Works

- **Search Head as a Search Peer Manager:**
  - The search head sends search requests to the indexers that are configured as search peers.
- **Data Access:**
  - The indexers process the search requests, retrieve the data, and return results to the search head.
- **No Cluster-Level Management:**
  - The search head doesn’t manage the replication or search factors of the indexers, unlike when part of an indexer cluster.

## 🚀 Steps to Configure Distributed Search Using the UI

1. **Log in to the Search Head**
    - Navigate to `http://<search-head-ip>:8000` using your admin credentials.

2. **Go to Settings → Distributed Search**
    - Select **Search Peers**.

3. **Add Search Peers**
    - Click on **Add New**.
    - Enter the indexer IP address and management port (**8089**).
    - Provide the admin username and password of the indexer.
    - Click **Save**.

4. **Verify Connection**
    - Ensure the status of the search peer is **Up**.

5. **Perform a Search**
    - Go to **Search & Reporting** and run a search like:
    ```
    index=* | stats count by sourcetype
    ```
    - You should see data from all the indexers.

## 🧑‍💻 When to Use This Setup

- If you have only one search head and multiple indexers.
- If you don’t need search head clustering or high availability.
- For smaller environments where data availability is not a major concern.
- When you don’t require replicated configurations using a deployer.

## 🚫 When Not to Use It

- If you need high availability for the search head.
- When managing configurations centrally across multiple search heads.
- If you want to ensure that searches are load-balanced or managed across search heads.


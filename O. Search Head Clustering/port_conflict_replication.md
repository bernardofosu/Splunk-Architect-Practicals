## ⚠️ Avoid Using the Same Replication Port for Indexer Clustering and SHC

Using the same replication port for both Indexer Clustering and Search Head Clustering (SHC) is not recommended and can lead to critical issues.

### 🔍 Why This Matters
Both Indexer Clustering and SHC rely on replication ports for peer-to-peer communication:

#### 🗃️ Indexer Clustering
- **Purpose:** Replicates bucket data (raw events).
- **Config Location:** `server.conf` under `[clustering]`
- **Example:**
  ```ini
  [clustering]
  mode = peer
  replication_port = 9887
  ```

#### 🧠 Search Head Clustering (SHC)
- **Purpose:** Synchronizes knowledge objects (saved searches, dashboards, etc.).
- **Config Location:** `server.conf` under `[shclustering]`
- **Example:**
  ```ini
  [shclustering]
  replication_port = 9888
  ```

### ⚠️ What Happens If the Ports Are the Same?

#### 🚨 1. Port Binding Conflict
- Each service will attempt to bind to the same port during startup.
- The second service will fail to start.
- **Common Error:**
  ```
  ERROR TcpInputProc - Error binding to port 9887 - Address already in use
  ```

#### 🚫 2. Clustering Fails to Communicate
- SHC expects knowledge object sync traffic.
- Indexer clustering expects raw data replication.
- If both use the same port:
  - Replication may silently fail.
  - Data loss or inconsistent state may occur.

#### 💣 3. Inconsistent Cluster Behavior
- If binding doesn’t fail outright, you might see:
  - SHC objects not syncing properly (e.g., dashboards missing).
  - Indexer bucket replication errors.
- **Example Logs:**
  ```
  SHClusterMgr - Failed to replicate configuration
  ClusteringMgr - Replication failed, peer unreachable
  ```

### ✅ Best Practice
- Use different, non-conflicting TCP ports for each cluster type.
- **Recommended Values:**
  - Indexer clustering: `9887`
  - SHC: `9888`
- **Network Note:** Make sure these ports are open and reachable in your firewall/security groups.


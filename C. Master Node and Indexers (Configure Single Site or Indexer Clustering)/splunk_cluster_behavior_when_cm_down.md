# 📦 Splunk Clustering Behavior When the Cluster Manager is Down

## 🧠 Context

- **Cluster Manager** (a.k.a. Master Node) manages the indexer cluster.
- **Peers (Indexers)** are the data nodes in the cluster.
- **Forwarders** can use Indexer Discovery to find available indexers via the Cluster Manager.

---

## ❌ What Happens When the Cluster Manager is Down?

### 🔍 Search Heads

- Search Heads get the list of indexer peers from the Cluster Manager.
- If the Cluster Manager is down:
  - No updated list of peers can be fetched.
  - Cached peer list may be used **temporarily**.
  - Over time, without updates, **searches may fail or become stale**.

### 🗂️ Indexer Peers

- Continue to **replicate and index data**.
- Operate independently of the Cluster Manager for data serving.
- Do **not** initiate bucket fixing on their own.

### 📡 Forwarders (Using Indexer Discovery)

- Depend on the Cluster Manager to discover indexers.
- When down:
  - **Dynamic discovery stops**.
  - Forwarders may stop sending data once cached indexers become unreachable.

---

## 🧾 Summary Table

| Component       | Behavior When Cluster Manager is Down                                   |
|----------------|---------------------------------------------------------------------------|
| Search Heads    | May use cached peers briefly; no updates; search failures likely         |
| Indexer Peers   | Continue indexing/replicating internally                                |
| Forwarders      | Discovery fails; forwarding halts if peers are unknown/unreachable       |

---

## 🔄 Replication & Search Factor When CM is Down

### ✅ Data Replication

- Still happens **peer-to-peer**.
- Cluster Manager is **not in the data path**.

### 🔍 Search Factor

- Maintained by peers.
- Searchable copies persist **as long as peers are healthy**.

### ❗ Cluster Coordination

- **Stops** without the Cluster Manager.
- No enforcement of configuration, peer changes, or cluster rebalancing.

---

## 🧰 Summary Table

| Function             | Continues Without Cluster Manager?   |
|----------------------|--------------------------------------|
| Data replication     | ✅ Yes                                |
| Search factor         | ✅ Yes                                |
| Cluster coordination | ❌ No                                 |

---

## 🪣 Bucket Fixing and Cluster Manager

### 🔧 What is Bucket Fixing?

- Cluster Manager **detects and coordinates** fixing of missing or under-replicated buckets.
- Ensures **Search Factor (SF)** and **Replication Factor (RF)** targets are met.

### ⚠️ If CM is Down:

- Bucket fixing is **paused**.
- Cluster may degrade below SF/RF thresholds.
- Peers will **not fix** buckets on their own.

### ✅ When CM Comes Back:

- It scans the cluster state.
- Orchestrates **bucket repair** and replication.
- Cluster health gradually **restores**.

---

## 📌 Final Summary

| Activity               | Behavior When Cluster Manager Is Down                |
|------------------------|------------------------------------------------------|
| Bucket fixing          | ❌ Paused                                             |
| Maintaining SF & RF    | ⚠️ Degraded if copies are lost                       |
| New data replication   | ✅ Ongoing directly between peers                    |

---

## 🧑‍💻 Need Help?

Let me know if you’d like:
- SPL queries to check cluster health
- Monitoring setups for CM availability
- Alerts for degraded SF/RF states

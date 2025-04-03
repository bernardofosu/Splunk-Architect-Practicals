## 🔥 Phase 2 (Day 2 & 3) – Installation
>[!NOTE] 
> [Use the intallation Secript]()

### ✅ A. Install the Deployment Server / License Master / Monitoring Console
- Set up a **Deployment Server** to centrally manage forwarders.
- Configure a **License Master** to manage Splunk licensing.
- Install the **Monitoring Console** to track the performance of Splunk components.

### ✅ B. Install the Forwarders
- Deploy a **Universal Forwarder on a Windows machine** to collect and send data to indexers.
- Deploy a **Universal Forwarder on a Linux machine** to collect system logs and application logs.

### ✅ C. Install the Master Node and Indexers
- Install and configure the **Cluster Master** to manage the indexer cluster.
- Set up **three Indexers** as peer nodes for storing and replicating data.

### ✅ D. Install the Search Head
- Install a **Search Head** to enable distributed searching across the indexers.
- Join the Search Head to the Indexer Cluster for high availability.
# 🏗️ Splunk Architect Class (Indexer Clustering or Single Site Clustering)

## 📖 Brief Explanation
This class covers the installation, configuration, and setup of a Splunk deployment, focusing on best practices for architecting a scalable Splunk environment.

---

## 🔥 Phase 1 (Day 1) – Installation

### ✅ A. Install the Deployment Server / License Master / Monitoring Console
- Set up a **Deployment Server** to centrally manage forwarders.
- Configure a **License Master** to manage Splunk licensing.
- Install the **Monitoring Console** to track the performance of Splunk components.

### ✅ B. Install the Forwarders
- Deploy a **Universal Forwarder on a Windows machine** to collect and send data to indexers.
- Deploy a **Universal Forwarder on a Linux machine** to collect system logs and application logs.

### ✅ C. Install the Master Node and Indexers
- Install and configure the **Cluster Master** to manage the indexer cluster.
- Set up **three Indexers** for storing and replicating data.

### ✅ D. Install the Search Head
- Install a **Search Head** to enable distributed searching across the indexers.
- Join the Search Head to the Indexer Cluster for high availability.

### ✅ E. Configure the Deployment Server and Forwarders
- Set up the **Deployment Server** to manage forwarder configurations.
- Configure forwarders (Windows & Linux) to **phone home** to the Deployment Server for updates.

### ✅ F. Configure Server Classes
- Create **Server Classes** to group forwarders based on data sources.
- Apply appropriate configurations and apps automatically to different classes.

---

## 🚀 Phase 2 (Day 1) – Configuration & Optimization

### ✅ G. Configure Indexer Discovery
- Enable **Indexer Discovery** to allow forwarders to dynamically locate available indexers.

### ✅ H. Enable Listeners on Search Peers
- Open the required ports on **all three indexers** to receive data from forwarders.

### ✅ I. Create Indexes on the Manager Node
- Define at least **three indexes** in `indexes.conf` and deploy them to indexers:
  - `windows_logs`
  - `linux_logs`
  - `application_logs`

### ✅ J. Disable Search Peers UI
- Disable the **Web UI** on indexers for security and performance optimization.

### ✅ K. Install License
- Apply a **Splunk Enterprise License** to enable full functionality.

### ✅ L. Configure Monitoring Console
- Set up **Monitoring Console** to track:
  - Cluster health
  - Indexing performance
  - Search efficiency

### ✅ M. Forward Internal Logs to Indexers
- Configure Splunk to send **internal logs** (e.g., `splunkd.log`) to indexers for centralized monitoring.

### ✅ N. Install Linux & Windows Apps
- Download and install **Splunk Add-ons for Windows and Linux** via Splunk Web.
- Onboard **Windows Event Logs** and **Linux Syslogs** into Splunk for real-time analysis.


## 🖥️ Final Deployment Overview
| Component        | Description |
|-----------------|-------------|
| 1 x Deployment Server | Manages forwarder configurations |
| 1 x License Master | Manages Splunk licensing |
| 1 x Monitoring Console | Tracks cluster health & performance |
| 2 x Forwarders (1 Windows, 1 Linux) | Collects and sends logs to indexers |
| 1 x Cluster Master | Manages indexer clustering |
| 3 x Indexers | Stores and replicates data |
| 1 x Search Head | Provides search functionality |


# 🏗️ Splunk Architect Class (Multi Site Clustering)


# 🏗️ Splunk Architect Class (Search Head Clustering)



# 🏗️ Splunk Architect Class (Indexer Clustering or Single Site Clustering, Multi Site Clustering and Search Head Clustering)

## 📖 Brief Explanation
This class covers the installation, configuration, and setup of a Splunk deployment, focusing on best practices for architecting a scalable Splunk environment.

## 🔥 Phase 1 (Day 1) – Brief Explanation on Splunk Architect Theory

## 🔥 Phase 2 (Day 2 & 3) – Installation

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


#### 🖥️🔧 Change Hostname Permanently (Immediately after Installation)

This is very important to identify all instances when querying internal logs, ensuring a proper hostname and correct server name at your **monitoring console** and **cluster manager**. ✨

**You can do it on Splunk Web/UI**
- Change hostname via **Splunk UI** (Settings → Server Settings).
- Set a **Global Banner** for easy identification across new instances.
- Rename accounts to reflect respective **Splunk components**.

For more details on hostname configuration:
[Change Hostname Permanently (Immediately after Adding New Instances for MultiSite Clustering) 🖥️🔧](hostnamefForSingleSiteClustering.md)

### ✅ E. Configure the Deployment Server and Forwarders
- Set up the **Deployment Server** to manage forwarder configurations.
- Configure forwarders (Windows & Linux) to **phone home** to the Deployment Server for updates.

### ✅ F. Configure Server Classes
- Create **Server Classes** to group forwarders based on data sources.
- Apply appropriate configurations and apps automatically to different classes.

---

## 🚀 Phase 2 (Day 4 & 5) – Configuration & Optimization

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
- Apply a **Splunk Enterprise License** on the DS/LM/MC and let all other components be slave to the master to enable full functionality.

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


### 🖥️ Final Deployment Overview for Indexer Clustering (Single Site Clustering)

| Component        | Description |
|-----------------|-------------|
| 1 x Deployment Server / License Master / Monitoring Console | Manages forwarder configurations, licensing, and tracks cluster health & performance |
| 2 x Forwarders (1 Windows, 1 Linux) | Collects and sends logs to indexers |
| 1 x Cluster Master | Manages indexer clustering |
| 3 x Indexers | Stores and replicates data |
| 1 x Search Head | Provides search functionality |

## 🚀 Phase 4 (Day 6) – Configuration & Optimization

### 🔥 Splunk Architect Class (Multi Site Clustering) using VPC peering in AWS

- Site replication factor: 3
- Site search factor: 2
- `available_sites = site1,site2`
- `multisite = true`
- `site_replication_factor = origin:2,total:3`
- `site_search_factor = origin:1,total:2`

#### Multi Site Clustering Setup:
- Add 3 new indexers for `site2`, keeping the old ones for `site1`.
- Add 2 new search heads: assign two to `site1` and one to `site2`.
- Add a new instance to serve as the **Search Head Deployer**.

---

### 🖥️🔧 Change Hostname Permanently (Immediately after Adding New Doing the Multi Site Clustering to differentiate the two sites settings eg. indexer-01-site1)

This is very important to identify all instances when querying internal logs, ensuring a proper hostname and correct server name at your **monitoring console** and **cluster manager**. ✨

#### You can do it on Splunk Web/UI
- Change hostname via **Splunk UI** (Settings → Server Settings).
- Set a **Global Banner** for easy identification across new instances.
- Rename accounts to reflect respective **Splunk components**.

For more details on hostname configuration:
[Change Hostname Permanently (Immediately after Adding New Instances for MultiSite Clustering) 🖥️🔧](hostnamefForSingleSiteClustering.md)

## 🚀 Phase 5 (Day 7) – Configuration & Optimization
### 🔥 Splunk Architect Class (Search Head Clustering)

- Configure **Search Head Deployer**.
- Initialize the **3 Search Head Cluster Members**.
- Install **Windows** and **Linux** add-ons on the Search Head Deployer and push them to Search Head members.


### 🖥️ Final Deployment Overview for Multi Site Site Clustering

| Component        | Description |
|-----------------|-------------|
| 1 x Deployment Server / License Master / Monitoring Console | Manages forwarder configurations, licensing, and cluster health |
| 2 x Forwarders (1 Windows, 1 Linux) | Collects and sends logs to indexers |
| 1 x Cluster Master | Manages indexer clustering |
| 6 x Indexers (3 for site1, 3 for site2) | Stores and replicates data |
| 3 x Search Heads (2 for site1, 1 for site2) | Provides search functionality |
| 1 x Search Head Deployer | Manages Search Head Cluster configurations |

## 🚀 Phase 6 (Day 8) – Configuration & Optimization
### 🔥Where and How to get logs to splunk
  
### 🔥 Syslog

<!-- ## 🔥Splunk with Ansible for Configuration Automation

## 🔥 Data Filtering using Props.conf and transform.conf

## 🔥 Splunk with Python and Node Js SDK

## 🔥 Create Splunk Amazon Machine Images (AMIs) with Packer

## 🔥 Creating instances using Terraform with the Splunk AMI

## 🔥 Splunk Cloud

## 🔥Splunk App Development




# 🏭 Managing Splunk in Production

In most production environments, you typically don't build Splunk from scratch. Instead, the focus is on maintaining, scaling, and managing it effectively.

Here are the most important things to focus on in a production Splunk environment:

## ✅ 1. Deployment and Architecture Management

- **Multi-Site Clustering**: Ensure redundancy and failover with indexer clustering and search head clustering.
- **Data Replication and Search Factor**: Configure appropriate replication factors (**RF**) and search factors (**SF**) to meet availability and performance goals.
- **Index Management**: Plan efficient use of indexes to organize data logically and reduce search time.
- **Forwarder Management**: Set up universal forwarders or heavy forwarders to collect and send data.

🔎 *Focus on understanding how to optimize and monitor the cluster health using Splunk Monitoring Console.*

---

## ✅ 2. Data Management

- **Ingestion Management**: Ensure proper data onboarding using inputs like log files, syslog, APIs, or cloud services (**AWS S3**, **GCP**, or **Azure Blob**).
- **Parsing and Indexing**: Configure `props.conf` and `transforms.conf` for field extraction and data transformation.
- **Data Retention**: Set **hot**, **warm**, **cold**, and **frozen** buckets with appropriate retention policies.

🔎 *Learn how to troubleshoot data parsing and ingestion issues.*

---

## ✅ 3. Search and Performance Optimization

- **Efficient Search Design**: Write optimized **SPL (Search Processing Language)** queries using best practices like limiting fields and using indexed data.
- **Data Model Acceleration**: Enable acceleration for frequently used datasets to improve search performance.
- **Scheduled Searches and Alerts**: Create and monitor scheduled searches without overloading the cluster.

🔎 *Monitor slow searches using the `search.log` and optimize them using Splunk's Job Inspector.*

---

## ✅ 4. Security and Access Management

- **Role-Based Access Control (RBAC)**: Configure users, roles, and permissions to restrict access based on the principle of least privilege.
- **Audit and Monitor Access**: Enable audit logging to track changes and user activities.
- **Data Masking and Anonymization**: Ensure sensitive data is masked using `props.conf` or custom masking rules.

🔎 *Implement security best practices using Splunk Enterprise Security (ES) if available.*

---

## ✅ 5. Monitoring and Maintenance

- **Health Monitoring**: Use the **Monitoring Console** to track the health of your cluster.
- **Log Management**: Monitor internal Splunk logs (`_internal` index) to detect issues.
- **Capacity Planning**: Regularly check disk usage, memory, and CPU to ensure the environment scales as data grows.

🔎 *Set up alerts to proactively detect indexing or search failures.*

---

## ✅ 6. Incident Response and Troubleshooting

- **Search Failures**: Investigate search performance using search logs (`search.log`).
- **Data Loss or Ingestion Issues**: Check forwarder and indexer logs (`splunkd.log`).
- **Cluster Replication Failures**: Troubleshoot using the cluster manager UI or CLI.

🔎 *Create runbooks for common issues to speed up incident response.*

---

## 🚀 Next Steps

Would you like:

- 🛠 **Hands-on guidance** on setting up a Monitoring Console?
- ✨ **Tips on writing optimized SPL queries?**
- 🕵️ **Examples of how to troubleshoot cluster issues?**

Let me know how you'd like to proceed! 😊




 -->

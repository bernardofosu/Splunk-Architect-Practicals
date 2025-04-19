
# 📘 Splunk Architecture & Operations – Interview Prep Guide

## 1. 🏗️ Explain the Components of the Splunk Architecture (Basic vs Managed)

### 🔹 Basic Components:
- **Forwarder**: Sends data to the indexer.
- **Indexer**: Stores and indexes data.
- **Search Head**: Allows users to search the indexed data.

### 🔹 Managed Components:
- **Deployment Server**: Manages and distributes configurations to forwarders.
- **Cluster Master (Manager Node)**: Manages indexer cluster.
- **Search Head Deployer**: Manages configuration for SH clusters.
- **Monitoring Console**: Provides centralized health view.
- **License Master**: Tracks license usage.

## 2. 📤 What are the Types of Forwarders?
- Universal Forwarder (UF)
- Heavy Forwarder (HF)

## 3. 🔄 Differences Between Forwarders

| Feature            | Universal Forwarder (UF) | Heavy Forwarder (HF)     |
|--------------------|---------------------------|---------------------------|
| Resource Usage     | Low                        | High                      |
| Parsing & Indexing | No                         | Yes                       |
| Use Case           | Lightweight data transport | Data filtering & routing  |

## 4. ⚙️ What is the Purpose of indexes.conf?
Defines index-level settings such as:
- Index name
- Retention policy
- Storage paths
- Sizing

## 5. 🧪 What are the Technical Properties?
- Port usage (9997 for forwarding, 8000 for UI)
- Licensing
- Index size & retention
- Search concurrency
- Resource utilization

## 6. 🧾 What is the Purpose of the License Master?
- Monitors data ingestion volume
- Ensures license compliance across the architecture

## 7. 📤 Role of the Search Head Deployer in a SH Cluster
- Distributes configuration bundles to all SH cluster members
- Ensures uniformity across the SH cluster

## 8a. 📥 How Do You Onboard New Data into Splunk Enterprise?
- 🔁 Forwarders
- 🔌 Cribl
- 📡 Syslog
- 🌐 HEC (HTTP Event Collector)
- 🧾 Script
- 🔗 API

## 8b. 📝 Explain the Onboarding Process
Organize a meeting with the client and your team to understand the data sources. Create a data onboarding template. Use up-to-date Splunk docs and the relevant tool documentation to guide the process.

## 9. ☁️ Do You Know About AWS or Any Cloud Platform?
✅ Always say Yes

## 10. 🔍 What is Search Concurrency?
- Number of simultaneous searches that can run in Splunk at a time

## 11. ⚠️ Problems of Search Concurrency
- High latency
- Search skipping

## 12. 🛠️ How Do You Handle Search Concurrency/Skipping?
- Configure limits.conf
- Match concurrency with server resources
- Discuss changes with the team

## 13. 📈 How Do You Monitor a Splunk Cluster?
- Use the Monitoring Console
- Monitor via internal logs
- Review health checks

## 14. ⬆️ How to Upgrade an Indexer Cluster
- Upgrade Manager Node (enable maintenance mode)
- Upgrade Search Heads (version ≥ peers)
- Upgrade Search Peers, one-by-one

## 15. 🔼 How to Upgrade a Search Head Cluster
- Upgrade the Search Head Deployer
- Upgrade the Captain first
- Upgrade each SH member, one-by-one

📌 **Note**: Always take a backup before upgrading

## 16. 🧩 How to Do the Actual Upgrading
- Upgrade apps/add-ons before the Splunk core if required
- Follow Splunk's upgrade order and compatibility matrix

## 17. 🔐 Knowledge Object Permissions
If you create a knowledge object under your username, it will be stored in your user context (/users/).  
To make it accessible to others, change permissions to global or app-level in the UI or via metadata/local.meta.

## 18. 🧠 Explain the Search Cluster
A group of Search Heads that share:
- Jobs
- Knowledge Objects
- Load balancing

## 19. 🧭 What Does a Search Head Cluster Do?
- Improves search performance
- Ensures high availability
- Manages shared configurations and searches

## What Does the Search Head Captain Does

## 20. ☁️ How to Onboard Cloud Data into Splunk
- 🔗 API Integration
- 💡 Cribl Stream
- 🧾 Scripted Inputs
- 🌐 HEC

# Splunk Components Overview

## 🧩 Core Components
| Component                       | Description                                                                             |
|---------------------------------|-----------------------------------------------------------------------------------------|
| **Indexer**                     | Indexes incoming data and handles search queries. Stores indexed data on disk.        |
| **Search Head**                 | User interface for running searches, creating reports, dashboards, alerts, etc.       |
| **Forwarders**                  | Send data to Splunk indexers (or other forwarders). See types below:                 |
| └─ **Universal Forwarder (UF)** | Lightweight agent for sending raw data; no parsing.                                   |
| └─ **Heavy Forwarder (HF)**     | Full Splunk instance that can parse, filter, and route data.                          |

## 🛠️ Management & Deployment Components
| Component                                   | Description                                                                 |
|---------------------------------------------|-----------------------------------------------------------------------------|
| **Deployment Server**                       | Centralized config manager for forwarders (pushes apps/configs to UFs/HFs). |
| **License Master**                          | Manages and enforces license usage across Splunk instances.                  |
| **Monitoring Console (formerly DMC)**      | Monitors health and performance of Splunk deployment.                        |
| **Indexer Cluster Master Node**             | Manages indexer cluster (e.g., data replication, rebalancing).              |
| **Search Head Deployer**                    | Used to distribute apps and configs to clustered search heads (SHC).        |

## 🔗 Specialized Components
| Component                       | Description                                                               |
|---------------------------------|---------------------------------------------------------------------------|
| **Clustered Search Head (SHC)** | Group of search heads for load balancing and high availability.           |
| **Indexer Cluster (IC)**        | Set of indexers configured for data replication and high availability.   |
| **Deployment Clients**          | Forwarders that are managed by the Deployment Server.                    |

## 🧠 Premium App Components
| Component                       | Description                                                               |
|---------------------------------|---------------------------------------------------------------------------|
| **ITSI (IT Service Intelligence)** | Advanced IT monitoring and analytics platform.                           |
| **ES (Enterprise Security)**    | SIEM (Security Information and Event Management) solution.               |
| **UBA (User Behavior Analytics)**| Machine learning-based detection for insider threats/anomalies.         |
| **Phantom (SOAR)**             | Security Orchestration, Automation, and Response tool (now part of Splunk SOAR). |

## 🧪 Others
| Component                       | Description                                                               |
|---------------------------------|---------------------------------------------------------------------------|
| **Splunk Web**                  | The web interface of Splunk (part of Search Head).                       |
| **REST API**                    | Interface for programmatic access to Splunk data and functions.          |
| **App/Add-on**                  | Extensions for data collection, parsing, dashboards, visualizations, etc.|

## 📊 Medium Deployment Configuration
In a large deployment with **35 Indexers**, if you're using a **Search Head Cluster (SHC)**, here’s how the components fit together:

- **35 Indexers** (Clustered for redundancy)
- **3-5 Search Heads** (SHC, clustered for load balancing and high availability)
- **1 Deployer or Search Head Deployer** (To distribute configurations and apps to all the search heads in the SHC)
- **1 Cluster Master Node** (To manage the Indexer Cluster)
- **1 License Master** (To manage licensing)
- **1 Monitoring Console** (For monitoring the environment)
- **1 or 2 Heavy Forwarders** (For parsing and forwarding logs)
- **Hundreds or Thousands of Universal Forwarders** (To forward raw logs to indexers)

## 📊 Large Deployment Configuration with 70 Indexers
In a large deployment with **70 Indexers**, the configuration would need to be scaled accordingly to handle the increased volume and ensure high availability, redundancy, and load balancing. Here’s how the components could fit together:

- **70 Indexers**: Clustered for redundancy and scalability to distribute workload effectively.
- **5-7 Search Heads**: Part of a Search Head Cluster (SHC) to handle increased searches, dashboards, and user queries, providing load balancing and high availability.
- **1 Deployer**: To manage the deployment of configurations and apps across all search heads in the SHC, ensuring consistency.
- **1 Cluster Master Node**: Manages the Indexer Cluster, ensuring data replication and maintaining cluster health.
- **1 License Master**: Manages licensing for the entire Splunk deployment, crucial for compliance.
- **1 Monitoring Console**: Tracks health and performance of the entire Splunk deployment.
- **2-4 Heavy Forwarders**: Handles data parsing and forwarding from source systems before sending to the indexers.
- **Thousands of Universal Forwarders**: Installed across endpoints to collect raw logs and forward them for processing.
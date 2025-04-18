## ⚙️ Perform a Multisite Migration in Splunk
[Migrate an indexer cluster from single-site to multisite](https://docs.splunk.com/Documentation/Splunk/9.4.0/Indexer/Migratetomultisite)


[Multisite indexer cluster architecture](https://docs.splunk.com/Documentation/Splunk/9.4.1/Indexer/Multisitearchitecture#Multisite_searching_and_search_affinity)

Migrating from a single-site cluster to a multisite cluster involves several steps. Follow this guide to configure your manager node, peer nodes, and search heads for a successful migration.

---

## 🧰 Prerequisites
- The **manager node** must run **Splunk Enterprise 7.2 or later**.
- Ensure **all nodes** follow the [Splunk version compatibility](https://docs.splunk.com).
- Upgrade your single-site cluster if necessary.
- If you want existing buckets to follow multisite policies, configure the manager node to convert the buckets. See **Configure the manager to convert existing buckets to multisite**.

---

## 🚀 Steps to Migrate to Multisite

### ✅ **1. Configure the Manager Node for Multisite**
Run the following command on the manager node to enable multisite mode:

Splunk Decide
```bash
splunk edit cluster-config -mode manager -multisite true \
-available_sites site1,site2 \
-site site1 \
-site_replication_factor origin:2,total:3 \
-site_search_factor origin:1,total:2
```
You decide
```bash
./splunk edit cluster-config -mode manager -multisite true -available_sites "site1,site2" -site site1 \
-site_replication_factor "origin:2,site1:1,total:3" \
-site_search_factor "origin:1,site1:1,total:2"
```
With the Secret Key
```sh
splunk edit cluster-config -mode manager -multisite true -available_sites site1,site2 -site site1 -site_replication_factor origin:2,total:3 -site_search_factor origin:1,total:2 -secret your_key
```
>[!NOTE] 
>If the first cluster, you added the pass4SymmKey, you should add -secret your_key to the command unless you will get secret error `Could not contact manager. Check that the manager is up, the manager_uri=https://172.31.1.193:8089 and secret are specified correctly.`

[Read More](https://docs.splunk.com/Documentation/Splunk/9.4.0/Indexer/MultisiteCLI)
```sh
splunk restart
```

🔎 **Explanation:**
- `-mode manager`: Configures the node as a cluster manager.
- `-multisite true`: Enables multisite.
- `-available_sites`: Lists all available sites.
- `-site`: Specifies the site the manager belongs to.
- `-site_replication_factor`: Defines how many bucket copies are maintained.
- `-site_search_factor`: Determines how many copies of searchable data must exist.

⚠️ **Important:**
- Do **not** remove existing `replication_factor` and `search_factor` settings.
- Ensure `site_replication_factor` and `site_search_factor` values meet or exceed the single-site settings.

---

### ✅ **2. Enable Maintenance Mode on the Manager**

Prevent unnecessary bucket fix-ups during the migration:

```bash
splunk enable maintenance-mode
```

🔎 **Confirm Maintenance Mode:**
```bash
splunk show maintenance-mode
```
#### ✅ Why Enable Maintenance Mode?
Prevent Data Movement:
- Without maintenance mode, the cluster manager will detect missing or misaligned copies of data and initiate bucket fix-ups (i.e., copying and replicating data).
- During the transition, some nodes may temporarily become unavailable or misconfigured, which would trigger unnecessary data replication.

#### When maintenance mode is not enabled, the cluster manager continuously monitors the cluster to ensure it meets the configured:
- Replication Factor (RF): Ensuring there are enough copies of each bucket across the sites.

- Search Factor (SF): Ensuring there are enough searchable copies available for queries.

**🚀 What Happens Without Maintenance Mode?**
- If a node fails, a site goes down, or buckets are missing, the manager immediately triggers a bucket fix-up.
- The goal is to quickly restore the number of copies to meet the replication and search factors.
- This can lead to a significant amount of data transfer and resource consumption across indexers, especially in large or multisite environments.

#### With Maintenance Mode:
- The manager pauses fix-ups and waits for the site to come back online.
- Once Site2 is restored, it only performs the necessary fix-ups, optimizing resource usage.

### ✅ **3. Configure Existing Peer Nodes for Multisite**

On each peer node, run: or we can update the server.conf

```bash
./splunk edit cluster-config -site site1
splunk restart
```
```sh
This command [POST /services/cluster/config/config] needs splunkd to be up, but splunkd is unreachable.
```

#### ✅ Fixes and Workaround
Manually add the site under [general]

Since splunkd is failing, just do it manually:
```ini
[general]
serverName = Indexer_03_Site2
pass4SymmKey = $7$wUnEhJQot2m7m4dzkK8O1uhSwVREtx3kuRZVi7JXcpX3ClSvSq/IRQ==
site = site1
```

🔎 **Explanation:**
- `-site`: Specifies the site the peer belongs to.
- Restarting the peer applies the changes.

**`splunk edit cluster-config -site site1; splunk restart`**: This command can only be run on existing peer nodes that are already part of the cluster. It is typically used for making minor adjustments, such as assigning a site in a multisite configuration.

#### 🔧 Command
```sh
splunk edit cluster-config -mode peer -site site2 -manager_uri https://172.31.92.30:8089 -replication_port 9887 -secret splunk123
```
```bash
./splunk restart
```

🔎 **Explanation:**
- `-mode peer`: Configures the node as a peer.
- `-manager_uri`: Specifies the manager node.
- `-replication_port`: Port used for data replication.

**splunk edit cluster-config -mode peer -site site1 -manager_uri https://<manager_ip>:8089 -replication_port 9887 -pass4SymmKey your_secret_key; splunk restart**: This command is used when adding a new indexer (peer node) to the cluster. It provides all the essential details for the manager node to register the peer. It’s necessary if the peer isn’t already a part of the cluster.

[Add New Peer Nodes, Do it from Splunk Web or UI](addNewIndexersToMultisiteSplunkWeb.md)

### ✅ **5. Configure Search Heads for Multisite**

For each search head, run:

```bash
splunk edit cluster-manager https://172.31.92.30:8089 -site site1
```
```sh
splunk edit cluster-config -mode searchhead -site site1 -manager_uri https://10.160.31.200:8089 -secret your_key

splunk edit cluster-config -mode searchhead -site site1 -manager_uri https://172.31.92.30:8089 -secret splunk123

splunk edit cluster-config -mode searchhead -site site2 -manager_uri https://172.31.92.30:8089 -secret splunk1233
```

🔎 **Explanation:**
- This associates the search head with the manager node and the specified site.

**For search head clusters:** Follow the guide on [Integrating with a Multisite Indexer Cluster](https://docs.splunk.com/Documentation/Splunk/9.4.1/Indexer/Multisitearchitecture#Multisite_searching_and_search_affinity).

---

### ✅ **6. Add New Search Heads (Optional)**

To add a new search head to the cluster, run:

```bash
splunk edit cluster-config -mode searchhead -site site1 \
-manager_uri https://<manager_ip>:8089

splunk restart
```

🔎 **Explanation:**
- `-mode searchhead`: Configures the node as a search head.

---

### ✅ **7. Disable Maintenance Mode on the Manager**

Once the configuration is complete, disable maintenance mode:

```bash
splunk disable maintenance-mode
```

🔎 **Confirm Maintenance Mode is Off:**
```bash
splunk show maintenance-mode
```

You can now check the cluster status using the Splunk Web UI or CLI.

---

## 📌 **Additional Notes**
- **Existing Buckets**: After migration, single-site buckets will be tagged with site values.
- **Indexer Discovery**: If using indexer discovery, assign a site to each forwarder.
- **Bucket Fixup**: If the manager is set to convert single-site buckets to multisite policies, bucket fix-up may continue for a while.

Need more details? Refer to the [Multisite Cluster Configuration Guide](https://docs.splunk.com) for additional information.


# 📊 Understanding Site Replication Factor Calculation in Splunk
| Data originates at | No. of copies at site1 | No. of copies at site2 | No. of copies at site3 | No. of copies at site4 | Total |
|:-------------------:|:----------------------:|:----------------------:|:----------------------:|:----------------------:|:-----:|
| **Site1**            |          2            |           2            |           3            |           1            |   8   |
| **Site2**            |          1            |           2            |           3            |           2            |   8   |
| **Site3**            |          1            |           2            |           3            |           2            |   8   |
| **Site4**            |          1            |           2            |           3            |           2            |   8   |

## Scenario Overview

- **4-site cluster**
- **Replication Factor Configuration:**
  ```
  site_replication_factor = origin:2, site1:1, site2:2, site3:3, total:8
  ```
- **Question:** Where will the last copy go if there is no site4?

---

## 🧑‍💻 Step 1: Origin Takes Precedence
- **origin:2** means the origin site (**site1**) needs **2 copies**.
- Even though `site1:1` specifies only **1 copy**, the **origin rule takes precedence**.
- ✅ **2 copies** will be placed at **site1**.

---

## 📦 Step 2: Apply Site Replication Factors
- **Site2** will receive **2 copies** as per `site2:2`.
- **Site3** will receive **3 copies** as per `site3:3`.

✅ So far:
- **Site1 → 2 copies**
- **Site2 → 2 copies**
- **Site3 → 3 copies**

👉 **Total so far:** 2 + 2 + 3 = **7 copies**

---

## ❗ Step 3: Remaining Copy Allocation
- The total required copies are **8 copies**, but we only have **7 copies**.
- Normally, the extra copy would be placed at **site4**.
- **But in this case, there is no site4.**

### 🟢 **What Happens Next?**
- The system will distribute the last copy across the existing sites: **Site1, Site2, or Site3.**
- The decision is usually based on:
  - 📊 **Load Balancing**
  - 💾 **Available Storage Capacity**
  - 🚀 **Network Latency**

💡 **In most cases, Site3 will receive the additional copy** since it already has the highest replication allocation (`site3:3`) and can handle more data.

---

## ✅ Final Distribution (No Site4)
| Site        | Copies  |
|--------------|----------|
| **Site1**   | 2        |
| **Site2**   | 2        |
| **Site3**   | 4        |
| **Total**   | 8        |

🎉 **Conclusion:** With no site4, the extra copy is distributed to **Site3**, ensuring redundancy and load balancing.

---

🔎 *This example helps understand how Splunk manages replication factors in a multisite environment without a fourth site.*

### Example 1

4 site cluster,  
**site_replication_factor = origin:2, site1:1, site2:2, site3:3, total:8**  

### On the Manager Node
```ini
[general]
serverName = cluster_manager
pass4SymmKey = $7$OIX/gHad3C1xSJMJOitcqluuzCNDjFpxWIMPwOgTp2dPV4ent8SXzQ==
site = site1

[clustering]
cluster_label = Cluster_01
mode = manager
pass4SymmKey = $7$PWRFmWEthDEpzVA6xZv1ETS1UR6IRY+jPZWo7zhgJNYFztfM/EF/dQ==
replication_factor = 2
constrain_singlesite_buckets = false
available_sites = site1,site2
multisite = true
site_replication_factor = origin:2,total:3
site_search_factor = origin:1,total:2
maintenance_mode = false
rebalance_threshold = 0.9

[indexer_discovery]
pass4SymmKey = $7$Fk3j6Y5OhzjfFEzXDW3AjhC5TP0kcOshkRbFCNkVz1ojGjWTyLE3Mw==
indexerWeightByDiskCapacity = true

[license]
manager_uri = https://172.31.95.252:8089
```

```ini
[general]
serverName = site1_indexer_02
pass4SymmKey = $7$/gYoN1Ajn9JwpJjAHo9wgH0G/q+udbxGI60vpCa3KiewcSLZRxavWg==
site = site1

[replication_port://9887]

[clustering]
manager_uri = https://172.31.92.30:8089
mode = peer
pass4SymmKey = $7$MDGnXM/sA3l6CPsTx/4HdI3NeepFn5shh6beQqjvRsWtsV1eNpNyvA==

[license]
manager_uri = self
```


# 🟠 Splunk Multisite Cluster Configuration

## 📌 Command
```bash
./splunk edit cluster-config -mode manager -multisite true -available_sites "site1,site2" -site site1 \
-site_replication_factor "origin:2,site1:1,total:3" \
-site_search_factor "origin:1,site1:1,total:2"
```

## 🔍 Explanation
This command configures a **multisite indexer cluster** with a **manager node**.

### 🔧 Options Breakdown
- **`./splunk edit cluster-config`** → Modifies the cluster configuration.
- **`-mode manager`** → Sets this node as the **cluster manager**.
- **`-multisite true`** → Enables **multisite clustering**.
- **`-available_sites "site1,site2"`** → Defines **two sites** (`site1` and `site2`).
- **`-site site1`** → Declares that **this node belongs to site1**.

### 📂 Replication & Search Factors
#### 📑 **Replication Factor (`-site_replication_factor`)**
- **`origin:2`** → Store **2 copies** of data at the **origin site**.
- **`site1:1`** → Store **1 copy** at **site1**.
- **`total:3`** → The cluster **keeps 3 copies in total**.

#### 🔍 **Search Factor (`-site_search_factor`)**
- **`origin:1`** → The **origin site** must have **1 searchable copy**.
- **`site1:1`** → **Site1 must have 1 searchable copy**.
- **`total:2`** → The cluster **must have 2 searchable copies**.

## 🎯 Purpose
This command **configures a multisite indexer cluster** in Splunk, ensuring **data replication** and **search availability** across multiple locations (`site1` and `site2`).

✅ This setup enhances **high availability** and **disaster recovery** in distributed Splunk environments.

# 🌐 Splunk Multisite Cluster Configuration Differences

## 📌 Overview
This document compares two different ways of configuring a **Splunk multisite cluster manager** and explains their key differences.

---

## 🛠️ Command 1 (With Quotes)  
```bash
./splunk edit cluster-config -mode manager -multisite true \
-available_sites "site1,site2" \
-site site1 \
-site_replication_factor "origin:2,site1:1,total:3" \
-site_search_factor "origin:1,site1:1,total:2"
```
✔ **Explicit argument grouping** with **quotes**  
✔ **Forces site1 to store at least 1 copy**  

---

## ⚡ Command 2 (Without Quotes)  
```bash
splunk edit cluster-config -mode manager -multisite true \
-available_sites site1,site2 \
-site site1 \
-site_replication_factor origin:2,total:3 \
-site_search_factor origin:1,total:2
```
✔ **More concise**  
❌ **Does not explicitly force site1 to store data**  

---

## 🔍 Key Differences

| Feature                     | Command 1 (With Quotes) | Command 2 (Without Quotes) |
|-----------------------------|------------------------|----------------------------|
| **Quotes Used**             | ✅ Yes                | ❌ No                     |
| **Explicit Data Placement** | ✅ Yes (`site1:1`)    | ❌ No (default behavior)   |
| **Potential Parsing Issues**| ❌ Less likely        | ✅ Possible if unquoted   |

**✅ Recommendation:** Use **Command 1** if you need precise control over **replication and search factors**. Otherwise, **Command 2** is a simpler alternative.

---
🚀 **Choose the right configuration based on your needs!**


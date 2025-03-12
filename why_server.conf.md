## Why Cluster Managemnent is done using sever.conf

Editing the cluster configuration in server.conf is done because this file acts as a central configuration point for Splunk. Here's a breakdown of why server.conf is used for cluster editing:

### 1️⃣ Persistent Configuration
- Purpose: Changes in server.conf are persistent across restarts of Splunk.
- If you configure the cluster using the CLI (e.g., ./splunk edit cluster-config), Splunk updates the corresponding values in server.conf automatically. This ensures that the cluster settings are applied every time Splunk starts.

### 2️⃣ Manual Configuration Option
- Splunk provides flexibility:
- You can edit server.conf manually if needed.
- Alternatively, you can use the CLI (which modifies the file for you).
- This gives administrators more control, especially in scenarios where they prefer using scripts or automation to update configuration files directly.

### 3️⃣ Centralized Settings for Cluster Management
- server.conf contains the [clustering] stanza, which is the designated section for cluster configuration.

This section is where critical settings like:
```sh
mode = manager (or mode = peer)
replication_factor
search_factor
pass4SymmKey
cluster_label
# are stored to define the behavior of the cluster.
```
### 4️⃣ CLI Commands vs. Manual Editing
- CLI (splunk edit cluster-config):
- Easier for administrators who prefer a simple, one-time configuration or automation via scripts.
- Automatically updates server.conf.
- Manual editing (server.conf):
- Useful in advanced scenarios or when using version control to manage configuration files.

### 5️⃣ Ensures Cluster Consistency
By defining clustering settings in server.conf, Splunk ensures that every restart of the system respects the defined cluster structure. This avoids potential issues like missing cluster peers or misconfigured replication/search factors.
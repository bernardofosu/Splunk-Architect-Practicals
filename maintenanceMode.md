# 🛠️ Use Maintenance Mode

Maintenance mode halts most bucket fixup activity and prevents frequent rolling of hot buckets. It is useful when performing peer upgrades and other maintenance activities on an indexer cluster. Because it halts critical bucket fixup activity, use maintenance mode only when necessary.

## ❓ Why Use Maintenance Mode

Certain conditions can generate errors during hot bucket replication and cause the source peer to roll the bucket. While this behavior is generally beneficial to the health of the indexer cluster, it can result in many small buckets across the cluster if errors occur frequently. Situations that can generate an unacceptable number of small buckets include:

- 🌐 Persistent network problems
- 🔄 Repeated offlining of peers

To stop this behavior, you can temporarily put the cluster into maintenance mode. This is useful for:

- 🛠️ System maintenance work that generates repeated network errors (e.g., network reconfiguration)
- ⏫ Peer upgrades or temporarily offlining several peers

🔹 **Note:** The CLI commands `splunk apply cluster-bundle` and `splunk rolling-restart` incorporate maintenance mode functionality by default, so you do not need to invoke maintenance mode explicitly when running those commands. A message stating that maintenance mode is running appears on the manager node dashboard.

## 🔄 The Effect of Maintenance Mode on Cluster Operation

To prevent unnecessary bucket rolling, maintenance mode:

✅ Halts most bucket fixup activity except for primary fixup.

✅ Allows the manager node to reassign primaries to available searchable bucket copies.

❌ Does **not** replicate buckets or convert non-searchable buckets to searchable.

❌ Does **not** enforce replication factor or search factor policy.

⚠️ **Important Considerations:**
- If a peer node is lost during maintenance mode, the cluster can be in a valid but incomplete state.
- If peer nodes are lost in numbers equal to or greater than the replication factor, the cluster loses its valid state.
- Losing even a single peer node can result in incomplete search results during primary fixup.

Maintenance mode applies equally to both **single-site** and **multisite clusters**.

## 🚀 Enable Maintenance Mode

Before starting maintenance activity, enable maintenance mode with:

```sh
splunk enable maintenance-mode
```

🔹 When you run this command, a message appears warning about the effects of maintenance mode and requiring confirmation to proceed.

🔹 **Note:** Since Splunk version **6.6**, maintenance mode persists across manager node restarts.

## ⛔ Disable Maintenance Mode

To return to standard bucket-rolling behavior, run:

```sh
splunk disable maintenance-mode
```

## 🔍 Determine Maintenance Mode Status

To check if maintenance mode is enabled, run:

```sh
splunk show maintenance-mode
```

📖 **For more details, visit:** [Splunk Documentation](https://docs.splunk.com/Documentation/Splunk/9.4.0/Indexer/Usemaintenancemode)


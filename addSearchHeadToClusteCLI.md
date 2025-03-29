# 🔧 Configure the Search Heads for Multisite Cluster

This guide helps you configure a **Search Head** in a multisite or single-site indexer cluster using the Splunk CLI.

---

## 🟣 Initial Configuration for Multisite Search Head

To configure a search head for a multisite cluster, specify the site during initial setup.

```bash
splunk edit cluster-config -mode searchhead \
    -site site1 \
    -manager_uri https://10.160.31.200:8089 \
    -secret your_key

splunk restart
```

### ✅ What this does:
- Declares the instance as a **search head**.
- Associates it with **site1**.
- Links it to the **cluster manager** at `10.160.31.200:8089`.
- Sets the **cluster-wide secret**.

⚠️ Setting the `site` parameter automatically sets `multisite=true` in `server.conf`.

---

## 🟡 Disable Search Affinity (Optional)

To allow the search head to fetch data from all sites randomly:

```bash
splunk edit cluster-config -mode searchhead \
    -site site0 \
    -manager_uri https://10.160.31.200:8089 \
    -secret your_key

splunk restart
```

---

## 🟢 Edit Search Head Configuration (After Initial Setup)

> Use `splunk edit cluster-manager` instead of `splunk edit cluster-config` for changes after initial setup.
[Configure the search head with the CLI](https://docs.splunk.com/Documentation/Splunk/9.4.0/Indexer/ConfiguresearchheadwithCLI)

### ✅ Change to multisite:

```bash
splunk edit cluster-manager https://10.160.31.200:8089 -site site1
splunk restart
```

### ✅ Change the cluster secret:

```bash
splunk edit cluster-manager https://10.160.31.200:8089 -secret newsecret123
splunk restart
```

### ✅ Change the manager URI:

```bash
splunk edit cluster-manager https://10.160.31.200:8089 -manager_uri https://10.160.31.55:8089
splunk restart
```

⚠️ Always provide the **current manager node** URI as the first argument to `splunk edit cluster-manager`.

---

## 🟤 Basic Search Head Enablement Example (Single Site)

```bash
splunk edit cluster-config -mode searchhead \
    -manager_uri https://10.160.31.200:8089 \
    -secret your_key

splunk restart
```

This command:
- Enables the instance as a **search head**.
- Sets the **cluster manager URI**.
- Configures the **secret** in `[clustering]` stanza of `server.conf`.

---

## 🔵 Notes

- Always restart Splunk after applying changes.
- `splunk edit cluster-manager` is used for post-initialization changes.
- `site0` disables search affinity.
- Review **Indexer Cluster CLI Guide** before proceeding with search head configuration.

---

✅ Official Documentation: [Splunk Multisite Search Head Config](https://docs.splunk.com/Documentation/Splunk/9.4.1/Indexer/Multisitesearchheads)

---

For production deployments, always validate cluster health after any configuration change using:

```bash
splunk show cluster-status -auth <user>:<password>
```


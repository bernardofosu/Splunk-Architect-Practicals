# 🛠️ Configure the Deployer for a Splunk Search Head Cluster (SHC)

Follow these steps to configure the deployer for managing a Search Head Cluster (SHC) in Splunk.

---

## ✅ Step 1: Install and Configure the Deployer

1. Install Splunk on the deployer node if not already installed.
2. Ensure the deployer can communicate with all search heads using port **8089** (management port).

### Enable Deployer Mode
```bash
./splunk enable deployer -auth <username>:<password>
```

### Confirm Configuration
```bash
./splunk show deployer-info
```

### Restart Splunk to Apply Changes
```bash
./splunk restart
```

---

## 🗂 Step 2: Prepare Search Head Cluster Apps and Configurations

- Place all apps and configuration files you want to deploy in the following directory:

```bash
$SPLUNK_HOME/etc/shcluster/apps/
```

### Example:
```bash
mkdir -p $SPLUNK_HOME/etc/shcluster/apps/my_custom_app
cp -r /path/to/app $SPLUNK_HOME/etc/shcluster/apps/my_custom_app
```

---

## 🚀 Step 3: Distribute Apps and Configurations

Push the configurations to all search heads using the deployer:

```bash
./splunk apply shcluster-bundle -target https://<search-head-ip>:8089 -auth <username>:<password>
```

- **`<search-head-ip>`** → Choose **any one** of the search heads.
- Splunk will sync configurations across all search heads using gossip communication.

### Verify Deployment
```bash
./splunk show shcluster-status
```

---

## 🛡️ Additional Tips

- Ensure all search heads are reachable from the deployer.
- If you make further changes to apps, reapply the bundle using the `apply shcluster-bundle` command.
- Use `show shcluster-status` on the deployer or any search head to check cluster health.

---

## 🎯 Monitoring the Search Head Cluster Using the UI

After deploying the configurations using the deployer, follow these steps to monitor the cluster via the UI:

1. **Log in to a Search Head:**
    - Navigate to: `http://<search-head-ip>:8000`
    - Log in using your Splunk admin credentials.

2. **View Cluster Status:**
    - Go to **Settings → Search Head Clustering → View Search Head Cluster Status.**
    - Check cluster health, captain status, and replication state.

3. **Validate App Deployment:**
    - Go to **Settings → Distributed Environment → Search Head Clustering → Apps.**
    - Confirm that the configurations and apps deployed by the deployer are visible.

---

Let me know if you need further troubleshooting steps or additional details! 😊


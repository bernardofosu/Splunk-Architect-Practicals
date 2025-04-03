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

# 🖥️ How to Install Windows & Linux Add-ons on Splunk Search Head Using Splunk Web 🌐

## 🔹 Prerequisites

✅ Ensure you have administrative access to Splunk Web.  
✅ Download the Splunk Add-ons for Windows and Linux from Splunkbase.  
✅ Your Splunk Search Head should be up and running.  
✅ If using a Search Head Cluster, ensure you have access to the **Deployer**.

## 🔹 Step-by-Step Guide

### 1️⃣ Log in to Splunk Web

🔹 Open your web browser and go to your Splunk instance:  
👉 `http://<splunk-server-ip>:8000`  
🔹 Enter your admin username and password.  

### 2️⃣ Navigate to the App Management Page

🔹 Click on **Apps** in the top-left corner.  
🔹 Select **Manage Apps** from the dropdown menu.  

### 3️⃣ Upload the Add-on File

🔹 Click on **Install App from File** 📂.  
🔹 Click **Choose File** and select the Windows Add-on (`TA-windows.tgz`) or Linux Add-on (`TA-nix.tgz`) that you downloaded.  
🔹 Click **Upload** to install the add-on.  

### 4️⃣ Restart Splunk (If Required) 🔄

🔹 After installation, Splunk may prompt you to restart.  
🔹 Click **Restart Splunk** to apply the changes.  

### 5️⃣ Verify the Add-on Installation ✅

🔹 Go to **Apps > Manage Apps** and check if the Splunk Add-on for Windows/Linux appears in the list.  
🔹 Click **Launch App** to configure data inputs if needed.  

## 🔹 Installing on a Search Head Cluster (Using the Deployer)

If you are using a **Search Head Cluster**, you need to install the add-ons on the **Deployer** and push them to the Search Head members.

### 1️⃣ Copy the Add-on to the Deployer

🔹 Transfer the add-on package (`TA-windows.tgz` or `TA-nix.tgz`) to the deployer server.

```bash
scp TA-windows.tgz user@deployer:/opt/splunk/etc/shcluster/apps/
scp TA-nix.tgz user@deployer:/opt/splunk/etc/shcluster/apps/
```

### 2️⃣ Extract and Configure the Add-on

```bash
cd /opt/splunk/etc/shcluster/apps/
tar -xvzf TA-windows.tgz
tar -xvzf TA-nix.tgz
```

### 3️⃣ Apply and Push the Add-ons to the Search Head Cluster
The -target in your command should point to any Search Head Cluster (SHC) member, not necessarily the Captain.
- The -target should be any active Search Head Cluster member (not necessarily the Captain).
- The member you target will propagate the changes across the cluster.

>[!NOTE]Best Practice:
> Choose a healthy and reachable SHC member (preferably the Captain, but not required).
> Verify the cluster status first:
> `splunk show shcluster-status`

Then apply the bundle.
```bash
/opt/splunk/bin/splunk apply shcluster-bundle -target https://<search-head-cluster>:8089 -auth admin:<password>
# captain ip just once
/opt/splunk/bin/splunk apply shcluster-bundle -target https://172.31.86.130:8089 -auth admin:20260918
```

### 4️⃣ Restart the Search Head Cluster Members

🔹 After applying the bundle, restart all Search Head members:

```bash
/opt/splunk/bin/splunk rolling-restart shcluster-members
```

## 🎯 Conclusion

You have successfully installed the Splunk Add-ons for Windows and Linux using Splunk Web or deployed them via the Deployer for a Search Head Cluster! 🚀 Now, you can configure data collection and start monitoring your Windows and Linux environments.  

🔹 Need more help? Check out **[Splunk Documentation](https://docs.splunk.com/)** for detailed configurations.  



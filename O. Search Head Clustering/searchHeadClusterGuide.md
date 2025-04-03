# 🚀 Search Head Cluster Deployment Guide

You're asking exactly like a pro architect should — these are the subtle things that make the cluster "production-grade" rather than just "working". 💪

## ✅ `server.conf` Template for Deployer + Search Head Members

All search head cluster members and the deployer need consistent settings.

### 🔹 For Deployer (`$SPLUNK_HOME/etc/system/local/server.conf`)
```ini
[shclustering]
pass4SymmKey = <your_secret_key>
shcluster_label = shcluster-prod

[general]
serverName = deployer01
```

### 🔹 For Search Head Members (`$SPLUNK_HOME/etc/system/local/server.conf`)
```ini
[shclustering]
pass4SymmKey = <your_secret_key>
shcluster_label = shcluster-prod
conf_deploy_fetch_url = https://deployer01:8089

[general]
serverName = sh0N  # Replace N with search head number (sh01, sh02, etc.)
```

## ✅ `shcluster_label` Naming Convention

The label should identify:
- 🏗️ Environment (dev, qa, prod)
- 🌍 Region (optional)
- 🎯 Purpose

**Example:**
```ini
shcluster_label = shcluster-prod-us-east
```

🔹 This is the glue that the deployer & all members use to agree they belong to the same cluster.

## ✅ Recommended `replication_factor = 3`

In production:
```sh
-replication_factor 3
```

This ensures:
- 🔄 3 copies of search artifacts (scheduler outputs, search artifacts, etc.)
- 🔥 High Availability even if you lose a node.

**Splunk Recommendation:**
- `replication_factor ≥ N`, where N is the number of cluster members.

## ✅ Search Head Deployer App Structure (`deployment-apps/`)

This is the directory the deployer pushes from:
```
$SPLUNK_HOME/etc/shcluster/apps/
├── TA-windows
│   └── default/
│       └── inputs.conf
├── TA-linux
│   └── default/
│       └── inputs.conf
├── mysearchapp
│   ├── default/
│   │   └── savedsearches.conf
│   └── metadata/
│       └── default.meta
└── README
```

### 🔹 Notes:
- ✅ Only put **search head specific apps** here.
- ✅ These apps will replicate to **all cluster members**.
- ❌ **DO NOT** put forwarder apps here.

## 💡 Pro Tip: Push Bundles Correctly

After preparing apps, run:
```sh
splunk apply shcluster-bundle -target https://<sh1>:8089 -auth admin:password
```

## ✅ Difference Between **Deployment Server** and **Deployer**

| Feature               | Deployment Server        | Search Head Deployer       |
|----------------------|------------------------|--------------------------|
| Pushes to           | Forwarders              | Search Head Members       |
| Pull Mechanism      | **Automatic** (Forwarders pull) | **Manual** (You must push) |
| Uses Directory      | `deployment-apps/`      | `shcluster/apps/`        |
| Requires Apply Cmd? | ❌ No                     | ✅ Yes (`apply shcluster-bundle`) |

## ✅ Workflow to Install Apps via Deployer

### 1️⃣ Install or Prepare the App on the Deployer
You can either:
- Install the app via UI (`$SPLUNK_HOME/etc/apps/`), or
- Download/unpack the app manually into `$SPLUNK_HOME/etc/apps/`.

### 2️⃣ Move the App to the Deployer's SHC directory
```sh
mv $SPLUNK_HOME/etc/apps/<app_name> $SPLUNK_HOME/etc/shcluster/apps/
```

### 3️⃣ Validate App Ownership and Permissions
```sh
chown -R splunk:splunk $SPLUNK_HOME/etc/shcluster/apps/<app_name>
chmod -R 755 $SPLUNK_HOME/etc/shcluster/apps/<app_name>
```

### 4️⃣ Push the Bundle to the Search Head Cluster
```sh
splunk apply shcluster-bundle -target https://<any_search_head>:8089 -auth admin:changeme
```

✅ **Notes:**
- This is **mandatory**—there is **no automatic pulling** like Deployment Server.
- The **deployer is a distribution tool**, not a Deployment Server.
- After pushing, all Search Head Members **sync, validate, and restart if needed**.

### 🔹 Bonus Tip: Preserve Lookup Files
If you don’t want to overwrite user-generated lookups:
```sh
splunk apply shcluster-bundle -target https://<any_search_head>:8089 -preserve-lookups true -auth admin:password
```

## 🔥 How Apps Get Distributed in SHC

### 🔹 Push to One → All Members Receive It

When you run:
```sh
splunk apply shcluster-bundle -target https://<any_search_head>:8089 -auth admin:changeme
```

🔹 **What Happens?**
1. 🏆 The **cluster captain** accepts the bundle.
2. 🔄 The **captain distributes** the apps and configurations to all members.
3. ✅ No need to run the command on each search head manually.

### 📂 Where Will Apps Land on Members?

After replication, all search head members will place the apps inside:
```sh
$SPLUNK_HOME/etc/apps/
```

Even though they came from:
```sh
$SPLUNK_HOME/etc/shcluster/apps/  # (Deployer side only)
```

This is why:
- On **the deployer** → Apps go under `etc/shcluster/apps/`.
- On **the members** → They get **synced automatically** into `etc/apps/`.

## ✅ Want More?
If you want, I can also show you:
- 🔍 How to check which member is the **captain**.
- ✅ How to verify if the **apps were distributed properly**.
- 🗂️ Best-practice **folder structures** for SHC deployments.


# 🖥️ How to Install Windows & Linux Add-ons on Splunk Search Head Using Splunk Web 🌐

## 🔹 Prerequisites

✅ Ensure you have administrative access to Splunk Web.  
✅ Download the Splunk Add-ons for Windows and Linux from Splunkbase.  
✅ Your Splunk Search Head should be up and running.  

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

## 🎯 Conclusion

You have successfully installed the Splunk Add-ons for Windows and Linux using Splunk Web! 🚀 Now, you can configure data collection and start monitoring your Windows and Linux environments.  

🔹 Need more help? Check out **[Splunk Documentation](https://docs.splunk.com/)** for detailed configurations.  

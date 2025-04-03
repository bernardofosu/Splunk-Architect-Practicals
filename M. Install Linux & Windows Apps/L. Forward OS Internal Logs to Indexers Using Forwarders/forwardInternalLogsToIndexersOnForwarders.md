## 🛡️ Forwarding Configuration

## 📌 Steps to Install Apps on Deployment Server via Splunk Web & Move to `deployment-apps`

1️⃣ **Log in to Splunk Web** → `http://<deployment-server-ip>:8000` → Enter **admin credentials**  
2️⃣ **Go to Apps** → **Manage Apps** (`App: Find More Apps`)  
3️⃣ **Install the required App** (Either from Splunkbase or upload manually)  
4️⃣ **Navigate to** → `Settings` → `Forwarder Management`  
5️⃣ **Move the Installed App**:  
   - Go to **$SPLUNK_HOME/etc/apps/**  
   - Move the app to **$SPLUNK_HOME/etc/deployment-apps/**  
   
   ```bash
   mv $SPLUNK_HOME/etc/apps/<app-name> $SPLUNK_HOME/etc/deployment-apps/
   ```  
6️⃣ **Restart Splunk** for changes to take effect:  
   
   ```bash
   splunk restart
   ```  
7️⃣ **Verify in Splunk Web** → `Settings` → `Forwarder Management` → **Check Deployment Apps**  
   

## 📌 Steps to Download, Upload, and Extract a Splunk App to `deployment-apps`

### 1️⃣ Download the App from Splunkbase
- Go to **[Splunkbase](https://splunkbase.splunk.com/)**
- Search for the required app
- Click **Download** and save the `.tgz` or `.tar.gz` file on your local machine

### 2️⃣ Upload the App to Deployment Server
#### **Using MobaXterm**
1. Open **MobaXterm**
2. Start an **SFTP session** to your Splunk Deployment Server
3. Navigate to the Splunk directory: `$SPLUNK_HOME/etc/deployment-apps/`
4. Drag and drop the downloaded `.tgz` or `.tar.gz` file to the target directory

#### **Using FileZilla**
1. Open **FileZilla** and connect to the Deployment Server
2. Locate the downloaded `.tgz` or `.tar.gz` file on your local machine
3. Navigate to `$SPLUNK_HOME/etc/deployment-apps/`
4. Upload the file to this directory

### 3️⃣ Extract the App on the Deployment Server
#### **Using SSH (Terminal/Command Line)**
1. SSH into the Deployment Server:
   ```bash
   ssh user@<deployment-server-ip>
   ```
2. Navigate to the `deployment-apps` directory:
   ```bash
   cd $SPLUNK_HOME/etc/deployment-apps/
   ```
3. Extract the app:
   ```bash
   tar -xvzf <app-name>.tgz
   ```
   or if the file is `.tar.gz`:
   ```bash
   tar -xzvf <app-name>.tar.gz
   ```
4. Remove the compressed file after extraction:
   ```bash
   rm <app-name>.tgz
   ```

### 4️⃣ Verify the App Deployment
- Run the following command to list the extracted app:
  ```bash
  ls -l $SPLUNK_HOME/etc/deployment-apps/
  ```
- Check in Splunk Web:
  - **Go to** `Settings` → `Forwarder Management`
  - **Verify** the app appears in **Deployment Apps**

### 5️⃣ Restart Splunk to Apply Changes
```bash
splunk restart
```

## 🚀 Step 6: Deploy Apps to Forwarders
Create the following **apps** on the Deployment Server and push them to forwarders:
- `all_base_inputs_linux`
- `all_base_inputs_windows`

```bash
mkdir -p /opt/splunk/etc/deployment-apps/all_base_inputs_linux/local
mkdir -p /opt/splunk/etc/deployment-apps/all_base_inputs_windows/local
```
## 📦 Deploy these apps to forwarders using **Deployment Server**.
 **OS Logs Configuration From Windows and Linux Server**

For the Linux and Windows App inputs.conf and find the like like what is below and put in inside on the DS and the clients will download

You will get these same from the Splunk TA Addon for WIndows default in the /opt/splunk/etc/system and you copy to put inside your custom inputs.conf inside local dir
### 🪟 Windows Logs

```ini
[WinEventLog://Application]
disabled = 0
start_from = oldest
current_only = 0
checkpointInterval = 5
renderXml = true
index = atlgsdach_windows_prod

[WinEventLog://Security]
disabled = 0
start_from = oldest
current_only = 0
evt_resolve_ad_obj = 1
checkpointInterval = 5
blacklist1 = EventCode="4662" Message="Object Type:(?!\s*groupPolicyContainer)"
blacklist2 = EventCode="566" Message="Object Type:(?!\s*groupPolicyContainer)"
renderXml = true
index = atlgsdach_windows_prod

[WinEventLog://System]
disabled = 0
start_from = oldest
current_only = 0
checkpointInterval = 5
renderXml = true
index = atlgsdach_windows_prod
```

You will get these same from the Splunk TA Addon for Linux and Unix default in the /opt/splunk/etc/system and you copy to put inside your custom inputs.conf inside local dir
### 🐧 **Linux Logs**

```ini
[script://./bin/vmstat_metric.sh]
sourcetype = vmstat_metric
source = vmstat
interval = 60
disabled = 0
index = atlgsdach_linux_prod

[script://./bin/iostat_metric.sh]
sourcetype = iostat_metric
source = iostat
interval = 60
disabled = 0
index = atlgsdach_linux_prod

[script://./bin/ps_metric.sh]
sourcetype = ps_metric
source = ps
interval = 30
disabled = 0
index = atlgsdach_linux_prod

[script://./bin/df_metric.sh]
sourcetype = df_metric
source = df
interval = 300
disabled = 0
index = atlgsdach_linux_prod

[script://./bin/interfaces_metric.sh]
sourcetype = interfaces_metric
source = interfaces
interval = 60
disabled = 0
index = atlgsdach_linux_prod

[script://./bin/cpu_metric.sh]
sourcetype = cpu_metric
source = cpu
interval = 30
disabled = 0
index = atlgsdach_linux_prod
```

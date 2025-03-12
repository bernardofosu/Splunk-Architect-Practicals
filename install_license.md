# 📜 Installing Splunk License on License Master & Joining Other Instances

## 🎯 Prerequisites
- A running **Splunk Enterprise** instance
- A valid **Splunk license file** (`.lic`)
- Admin access to Splunk Web or CLI

---

## 🏗️ Step 1: Configure the License Master

### 🔹 Upload License via Splunk Web
1. Log in to **Splunk Web** (`https://<license-master>:8000`)
2. Navigate to: **Settings** → **Licensing**
3. Click on **Add License**
4. Upload your **Splunk license file** (`.lic`)
5. Click **Install** ✅
6. Verify that the license appears in the list 🎉

### 🔹 Upload License via CLI
Alternatively, use the CLI to add the license:
```bash
splunk add licenses /path/to/license.lic -auth admin:password
```

---

## 🔗 Step 2: Set Up License Master Role
1. Navigate to **Settings** → **Licensing**
2. Click **Change License Group**
3. Select **License Master** and save changes 🏆
4. Restart Splunk for changes to take effect:
   ```bash
   splunk restart
   ```

---

## 🖥️ Step 3: Connect Other Splunk Instances as License Slaves
On each **License Slave (Search Head, Indexer, etc.)**:

### 🔹 Via Splunk Web
1. Navigate to **Settings** → **Licensing**
2. Click **Change License Group**
3. Select **License Slave**
4. Enter **License Master URI**:
   ```
   https://<license-master>:8089
   ```
5. Click **Save** 🔄
6. Restart Splunk on the slave instance:
   ```bash
   splunk restart
   ```

### 🔹 Via CLI
Run the following command on each slave:
```bash
splunk set licenser-lm https://<license-master>:8089 -auth admin:password
splunk restart
```

---

## ✅ Step 4: Verify License Master-Slave Connection
On the **License Master**:
1. Go to **Settings** → **Licensing**
2. Under **License Usage**, verify connected slaves are listed 📋
3. Run CLI check:
   ```bash
   splunk list licenser-pools
   ```

---

## 🎉 Success! Your Splunk License Master is Set Up! 🚀
Now all connected Splunk instances can share the central license. If any issues arise, check **splunkd.log** for troubleshooting:
```bash
tail -f $SPLUNK_HOME/var/log/splunk/splunkd.log
```
Happy Splunking! 🎊


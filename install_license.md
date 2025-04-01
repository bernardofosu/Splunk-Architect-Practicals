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
Add to all server.conf
```ini
[license]
manager_uri = https://172.31.95.252:8089
```

# 🛑 Splunk License Duplication Issue & Fix

## ❌ Error Message
```plaintext
Duplicated license situation not fixed in time (72-hour grace period).
Disabling peer site1_indexer_02 because it has the same license installed as peer indexer_01_Site2.
Peer site1_indexer_02 is using license master self and peer indexer_01_Site2 is using license master self.
3/31/2025, 12:29:06 AM

Peer site1_indexer_03 has the same license installed as peer indexer_01_Site2.
Peer site1_indexer_03 is using license master self, and peer indexer_01_Site2 is using license master self.
Please fix this issue in 72 hours, otherwise peer will be disabled.
3/31/2025, 12:29:06 AM
```

## 🚨 **Why This Happens?**
- Some indexers (e.g., `site1_indexer_02`, `site1_indexer_03`) are using **self** as their own license master.
- Other indexers (`indexer_01_Site2`) are also using **self** as their own license master.
- **But all of them have the same license installed**, causing a duplicate license violation.
- Splunk enforces a **72-hour grace period** before disabling affected peers.

## ✅ **How to Fix This?**

### 🏆 **Step 1: Designate a License Master**
Pick a single Splunk instance to act as the **License Master** (e.g., `indexer_01_Site2`).

1. Go to **Splunk Web** → `Settings` → `Licensing`.
2. Select **Set as License Master**.
3. Ensure a **valid Splunk Enterprise license** is installed on this master.

### 🔄 **Step 2: Convert Other Indexers to License Slaves**
On the affected indexers (`site1_indexer_02`, `site1_indexer_03`):

1. Go to **Splunk Web** → `Settings` → `Licensing`.
2. Click **Change to Slave**.
3. Enter the license master’s address: `https://indexer_01_Site2:8089`.
4. Save and **restart Splunk**.

Alternatively, use the CLI:
```sh
splunk edit licenser-localslave -master_uri https://indexer_01_Site2:8089 -auth admin:<password>
splunk restart
```

### 🔍 **Step 3: Verify License Assignment**
Run the following command on the **License Master** to check connected license slaves:
```sh
splunk list licenser-pools
```

### 🔄 **Step 4: Restart Splunk Services**
Restart all affected indexers to apply the changes:
```sh
splunk restart
```

## 🎯 **Final Verification**
1. Go to **Splunk Web** → `Settings` → `Licensing` on the License Master.
2. Verify that **all indexers appear under License Slave Instances**.

## ❓ **Why This Happens?**
- Each Splunk license is **node-locked**, meaning it is tied to a specific Splunk instance.
- If multiple indexers use the **same license** but act as their **own license master**, Splunk detects duplication.
- If not resolved **within 72 hours**, Splunk **disables search and indexing** on the affected nodes.

## 🎉 **Next Steps**
✅ If all slaves report to the master, your issue is **fixed**!
🚨 If the issue persists, check `splunkd.log`:
```sh
$SPLUNK_HOME/var/log/splunk/splunkd.log
```

---
**Need further help? Let me know! 🚀**




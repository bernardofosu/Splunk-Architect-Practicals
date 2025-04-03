
## 🔧 Step 5: Final Configuration & Deployment

### **Disable Web Interface on Indexers**
📌 Steps to Disable Splunk Web from Splunk UI

**1️⃣** Log in to Splunk Web → http://<splunk-server-ip>:8000 → Enter admin credentials

**2️⃣** Go to Settings → Server Settings → General Setting

**3️⃣** Check No "Enable Splunk Web

**4️⃣** Click Save → Restart Splunk

Edit `web.conf`: 
```bash
vi /opt/splunk/etc/system/local/web.conf
```
```ini
[settings]
startwebserver = false
```
### **Deploy Changes**
```bash
./splunk apply cluster-bundle
./splunk apply cluster-bundle --skip-validation
```
**Disable Splunk Web UI Permanently, Method: Using Splunk CLI**

Run the following command:
```sh
splunk disable webserver
```
✅ This prevents Splunk Web from starting on the next reboot. The Splunk backend (splunkd) will continue running.

To re-enable the web interface later:
```sh
splunk enable webserver
```
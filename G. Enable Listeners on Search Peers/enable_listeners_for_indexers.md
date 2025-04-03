## 🎯 Step 3: Enable Listener on Manager Node for Indexers

On each **indexer**, enable receiving by modifying `inputs.conf`:
```bash
mkdir -p /opt/splunk/etc/manager-apps/atlgsdach_all_indexers_base/local
cd /opt/splunk/etc/manager-apps/atlgsdach_all_indexers_base/local
vi inputs.conf
```
```ini
[splunktcp://9997]
disabled = 0
```
Check if Port 9997 is Enabled on the Indexers

Run the following on each indexer:
```sh
/opt/splunk/bin/splunk btool inputs list --debug | grep 9997
```
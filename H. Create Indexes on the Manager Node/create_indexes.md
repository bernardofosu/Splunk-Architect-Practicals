## 📂 Step 4: Create Indexes

On the **manager node**, create an app and define `indexes.conf`:
```bash
mkdir -p /opt/splunk/etc/manager-apps/atlsdach_all_indexers_base/local
cd /opt/splunk/etc/manager-apps/atlsdach_all_indexers_base/local
vi indexes.conf

mv atlsdach_all_indexers_base/ atlgsdach_all_indexes_base/
```

### 🔹 Define Storage Volumes and Create Indexes for Different Data Types
```ini
[volume:one]
path = /opt/splunk/hot/one/
maxVolumeDataSizeMB = 40000

[volume:two]
path = /opt/splunk/warm/two/
maxVolumeDataSizeMB = 60000

[volume:three]
path = /opt/splunk/cold/three/
maxVolumeDataSizeMB = 80000

[atlgsdach_os_prod]
homePath = volume:one/atlgsdach_os_prod/db
coldPath = volume:three/atlgsdach_os_prod/colddb
coldToFrozenDir = /opt/splunk/frozen/atlgsdach_os_prod/frozendb
thawedPath = /opt/splunk/thawed/atlgsdach_os_prod/thaweddb
maxHotSpanSecs = 2592000
frozenTimePeriodInSecs = 7776000
maxDataSize = auto
maxTotalDataSizeMB = 102400
repFactor = auto

[atlgsdach_linux_prod]
homePath = volume:one/atlgsdach_linux_prod/db
coldPath = volume:three/atlgsdach_linux_prod/colddb
coldToFrozenDir = /opt/splunk/frozen/atlgsdach_linux_prod/frozendb
thawedPath = /opt/splunk/thawed/atlgsdach_linux_prod/thaweddb
maxHotSpanSecs = 2592000
frozenTimePeriodInSecs = 7776000
maxDataSize = auto
maxTotalDataSizeMB = 102400
repFactor = auto

[atlgsdach_windows_prod]
homePath = volume:one/atlgsdach_windows_prod/db
coldPath = volume:three/atlgsdach_windows_prod/colddb
coldToFrozenDir = /opt/splunk/frozen/atlgsdach_windows_prod/frozendb
thawedPath = /opt/splunk/thawed/atlgsdach_windows_prod/thaweddb
maxHotSpanSecs = 2592000
frozenTimePeriodInSecs = 7776000
maxDataSize = auto
maxTotalDataSizeMB = 102400
repFactor = auto
```
```bash
./splunk apply cluster-bundle
```
>[!NOTE]
> Apply the cluster bundle anytime you create apps under manager-apps in the Cluster Master to push the changes to the indexers

### After applying the cluster bundle, You check peer-apps on the peers
```sh
cd /opt/splunk/etc/peer-apps # go inside the apps to check the conf
```
# 📡 Splunk Universal Forwarder - Check Connections and Responses

## 🔍 1. Check TCP Output Connections via `splunkd.log`

```bash
sudo su
export SPLUNK_HOME=/opt/splunkforwarder
tail -f $SPLUNK_HOME/var/log/splunk/splunkd.log | grep -i tcpout
```

🔹 Or with full path if `$SPLUNK_HOME` is not set:

```bash
tail -f /opt/splunkforwarder/var/log/splunk/splunkd.log | grep -i tcpout
```

✅ **Expected Output:**

You should see lines like:

```
INFO  AutoLoadBalancedConnectionStrategy [...] - Connected to idx=IP:9997, using ACK
INFO  AutoLoadBalancedConnectionStrategy [...] - Closing stream for idx=IP:9997
```

✅ Confirmed, you are 100% using Indexer Discovery, NOT static indexers.
```sh
/opt/splunkforwarder/bin/splunk btool outputs list --debug | grep -E "server|targetUri|discovery"
```

## 🌍 2. Check if Forwarder Sees the Indexers (Indexer Discovery View)

```bash
splunk list forward-servers
```

Create the user-seed.conf File: Navigate to the $SPLUNK_HOME/etc/system/local/ directory and create a file named user-seed.conf with the following content:
```sh
cd $SPLUNK_HOME/etc/system/local/
cd /opt/splunkforwarder/etc/system/local/

vi user-seed.conf

[user_info]
USERNAME = admin
PASSWORD = splunk123

/opt/splunkforwarder/bin/splunk restart
```

✅ **Expected Output:**

This will list all discovered indexers by indexer discovery.

---

## 📡 3. Check Forwarder to Indexer Connection Status

```bash
splunk btool outputs list --debug
```

✅ **Expected Output:**

This will show you the currently active outputs configuration, including the discovered indexers.

---

## 🔎 4. Search on the Indexer to Confirm Data

From the **Search Head** or **Indexer GUI**, run:

```splunk
index=_internal host=<forwarder-hostname>
```

✅ **Expected Output:**

- Should return internal logs from the forwarder, meaning it is successfully sending data.
- You can also replace `<forwarder-hostname>` with `*` to check all forwarders.

---

## 📝 Notes:

- 🏃 **Run all commands as the `splunk` user or `root`.**
- ⚙ **Ensure the forwarder is running:**
  
  ```bash
  splunk status
  ```

- 🔄 **Restart the forwarder after changing `outputs.conf`:**
  
  ```bash
  splunk restart
  ```

---

### ✨ Want a more polished version?

If you want, I can make it even fancier with:
- 🎨 Emoji indicators
- 🏷 Markdown badges
- 📖 Clean formatting for your documentation or team handbook

Just say **make it prettier**, and I got you 😄


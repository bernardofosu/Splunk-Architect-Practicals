# 🔧 Configuration: Scheduled & Summarization Search Concurrency in Splunk

## 🔍 Configuration File and Component Involved

| Setting                          | Component   | Config File                                  | Web Path                                                  |
|----------------------------------|-------------|-----------------------------------------------|-----------------------------------------------------------|
| Scheduled Search Concurrency     | Search Head | `$SPLUNK_HOME/etc/system/local/limits.conf`  | Settings > Server Settings > Search Preferences           |
| Summarization Search Concurrency| Search Head | `$SPLUNK_HOME/etc/system/local/limits.conf`  | Same as above                                             |

---

## 🧾 1. Set Concurrency Limits via `limits.conf`

Manually configure on Search Head or SHC members:

📄 **File:** `$SPLUNK_HOME/etc/system/local/limits.conf`

```ini
[scheduler]
# Max % of concurrent searches that can be scheduled
max_searches_perc = 70

# Max % of scheduled searches that can be summarization (accelerations)
max_summary_searches_perc = 50
```

### 📘 Meaning:

- `max_searches_perc = 70` → Up to **70%** of available concurrent searches can be used for **scheduled** searches (user/system).
- `max_summary_searches_perc = 50` → Of that 70%, up to **50%** (i.e., 35% total) is used for **summarization** (acceleration) jobs.

---

## 🌐 2. Set Concurrency Limits via Splunk Web

Prefer a GUI approach? Use the web interface:

🔗 Navigate to: **Settings > Server Settings > Search Preferences**

- Set **Relative concurrency limits**:
  - Scheduled searches → e.g., 70%
  - Summarization searches → e.g., 50%
- ✅ Click **Save**
- 🚫 No restart required

📖 [Official Documentation on Concurrent Search Limits](https://docs.splunk.com/Documentation/SplunkCloud/9.3.2408/Admin/ConcurrentLimits)

---

## 👥 Applies To

| Role               | Applies? |
|--------------------|----------|
| Search Head (SH)   | ✅ Yes   |
| Search Head Cluster| ✅ Yes   |
| Indexer            | ❌ No    |
| Forwarder          | ❌ No    |

---

## ✅ Best Practices

| Situation                        | Recommended Action                                      |
|----------------------------------|----------------------------------------------------------|
| High scheduled workload          | Increase `max_searches_perc` to **70–80%**              |
| Heavy use of acceleration jobs   | Raise `max_summary_searches_perc` to **60–70%**         |
| Missed scheduled jobs            | Check concurrency limits and raise if necessary         |
| Resource contention on SH       | Monitor usage and consider horizontal scaling           |

---

🗓️ **Generated on:** {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}

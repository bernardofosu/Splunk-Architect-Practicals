# Understanding the Need for the Windows Add-on in Splunk

Great question! The reason you need to install the Windows Add-on (or any other Splunk technology-specific add-on) on both the forwarder and the search head is because they serve different purposes in Splunk's architecture. Let's break it down:

## 🔄 Why Install the Windows Add-on on the Forwarder?

### Role of the Forwarder:
- The Splunk Universal Forwarder (UF) or Heavy Forwarder (HF) is responsible for collecting and forwarding raw Windows event logs, performance metrics, security logs, etc. to an indexer.
- The Windows Add-on (TA) includes scripts and inputs (`inputs.conf`) that define what data to collect (e.g., Event Logs, PerfMon, WMI, etc.).
- Without this add-on, the forwarder wouldn't know how to collect Windows logs properly.

✅ **Key Purpose on Forwarder:** Data Collection & Forwarding

## 🔍 Why Install the Windows Add-on on the Search Head?

### Role of the Search Head:
- The Search Head (SH) is where users run searches, dashboards, and reports on the collected data.
- The Windows Add-on contains knowledge objects (like field extractions, event types, tags, and lookups) that structure the raw Windows data into meaningful fields.
- Without the add-on, searches and dashboards might not work correctly because the raw data lacks field extractions.

✅ **Key Purpose on Search Head:** Data Parsing, Field Extractions, and Enrichment for Search & Reports

## 🚀 Summary: Different Purpose on Each Component

| Splunk Component | Why Install Windows Add-on? |
|------------------|----------------------------|
| **Forwarder**    | Collects & forwards raw Windows logs |
| **Search Head**  | Applies field extractions & enriches search results |

So, forwarders collect data, indexers store it, and search heads interpret it—each with a different role in the pipeline! 🎯

## 📌 Why Do You Need to Manually Configure `inputs.conf` on the Forwarder?

- The forwarder (UF/HF) is responsible for monitoring file paths, event logs, registry keys, WMI queries, etc.
- The Windows Add-on (TA) provides default configurations (`default/inputs.conf`), but they are disabled by default.
- To enable data collection, you must manually create a local copy (`local/inputs.conf`) and specify what logs to collect.

### Example configuration (`local/inputs.conf` on the forwarder):
```ini
[WinEventLog://Security]
disabled = 0
index = wineventlog
```
This tells Splunk to start collecting Windows Security Event Logs and send them to the `wineventlog` index.

## 📌 Why Don’t You Configure `inputs.conf` on the Search Head?

- The search head does not collect or forward data; it only runs searches and provides dashboards, reports, and alerts.
- The Windows Add-on (TA) installed on the search head is used only for:
  - Field extractions
  - Event types and tags
  - Lookups and CIM (Common Information Model) normalization
- The `inputs.conf` file is not needed on the search head because it does not need to monitor files, event logs, or registry keys.

## 🔥 Key Difference

| Component | Needs `inputs.conf`? | Why? |
|-----------|----------------|------|
| **Forwarder** | ✅ Yes (Manually in `local/`) | It collects Windows logs and forwards them |
| **Search Head** | ❌ No | It only processes and searches indexed data |

That’s why on a forwarder, you configure `inputs.conf` manually, but on the search head, you don’t touch it—because the search head is only for searching, not collecting! 🚀

Hope that clears it up! Let me know if you need more details. 🔥


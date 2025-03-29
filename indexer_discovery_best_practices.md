# ✅ Best Practice for Indexer Discovery Configuration

You only need **one** app (or system-level config) on the forwarder that handles:

```
[indexer_discovery:<name>]
[tcpout:<group>]
[tcpout]
```

This should be placed in a dedicated outputs app, such as:

```
/opt/splunkforwarder/etc/apps/indexer_discovery_outputs/local/outputs.conf
```

---

## 💡 Why?
- Forwarder needs **only one** definition of how it discovers indexers and routes data.
- Every other app should only define:
  - **Inputs** (`inputs.conf`)
  - **Transforms** (`transforms.conf`)
  - **Props** (`props.conf`)
  - Any other **data-related configurations**

🔴 **No other app should redefine `outputs.conf`** unless you're doing advanced multi-destination routing.

---

## ✅ Rule of Thumb:

- Only your **output handling app** should have the `indexer_discovery` and `tcpout` stanzas.
- Other apps **must not** define `outputs.conf` unless required for special routing.

This ensures:

✔ **Clean configuration**  
✔ **No accidental overrides**  
✔ **Easier maintenance**  
✔ **Forwarder avoids confusion from multiple conflicting outputs**  

---

# 📁 Recommended Splunk Universal Forwarder Directory Structure

```
/opt/splunkforwarder/etc/apps/

├── indexer_discovery_outputs/          # Only this handles outputs
│   └── local/
│       └── outputs.conf                 # Contains [indexer_discovery], [tcpout:<group>], [tcpout]

├── app1_collect_logs/                   # Example input app
│   └── local/
│       └── inputs.conf                  # Inputs only (monitors, scripts, etc.)

├── app2_windows_eventlogs/              # Example input app
│   └── local/
│       └── inputs.conf                  # Inputs for Windows EventLogs

├── app3_parse_data/                     # Example for props/transforms
│   └── local/
│       ├── props.conf                   # Parsing rules
│       └── transforms.conf              # Field extractions, routing rules

└── search_app/                          # Optional search-time configurations
    └── local/
        ├── props.conf
        └── transforms.conf
```

---

## ✅ Key Takeaways:

🟢 `outputs.conf` **ONLY** exists in `indexer_discovery_outputs` or a dedicated outputs app.  
🟢 Other apps **only** handle data ingestion and parsing, **nothing related to outputs**.  
🟢 This avoids:
  - ❌ **Conflicts**
  - ❌ **Multiple tcpout definitions**
  - ❌ **Forwarder confusion**
  - ❌ **Troubleshooting nightmares**

---

## 🔍 Extra Tip:

Always validate your configuration with:

```bash
$SPLUNK_HOME/bin/splunk btool outputs list --debug
```

This ensures your forwarder uses the correct output settings. 🚀



# Splunk: Enabling Multiple Ingestion Pipelines – Configuration Guide

## 🔧 1. Enable Multiple Pipeline Sets on an Indexer
**Component:** ✅ Indexer only  
**File:** `$SPLUNK_HOME/etc/system/local/server.conf`

```ini
[general]
parallelIngestionPipelines = 2
pipelineSetSelectionPolicy = weighted_random
```

✅ **Add this to:** Indexer — to enable parallel ingestion pipelines.  
❌ **Do NOT add this to:** Search Head or Cluster Master.

**Why:** Only Indexers and Heavy Forwarders perform data ingestion that benefits from parallel pipelines.

---

## ⚙️ 2. (Optional) Fine-Tune Weighted Random Policy
**Component:** ✅ Indexer  
**File:** `$SPLUNK_HOME/etc/system/local/server.conf`

```ini
[general]
pipelineSetWeightsUpdatePeriod = 10
pipelineSetNumTrackingPeriods = 6
```

✅ **Add this to:** Indexer — only if using `weighted_random` policy and want more refined control.  
❌ **Do NOT add this to:** SH, CM, or Forwarders.

**Why:** These settings tune how Splunk balances ingestion load.

---

## 🧰 3. Resource-Aware Settings in Other Conf Files

### ➤ limits.conf
**Component:** ✅ Indexer  
**File:** `$SPLUNK_HOME/etc/system/local/limits.conf`

```ini
[thruput]
maxKBps = 10240
```

✅ **Add this to:** Indexer  
❌ **Do NOT add this to:** SH or CM

**Why:** Each pipeline set respects this throughput limit independently. With 2 pipelines, max is 20MB/s.

### ➤ indexes.conf
**Component:** ✅ Indexer  
**File:** `$SPLUNK_HOME/etc/system/local/indexes.conf`

```ini
[default]
maxHotBuckets = 4
```

✅ **Add this to:** Indexer  
❌ **Do NOT add this to:** SH, CM, or Forwarders

**Why:** Each pipeline can maintain 4 hot buckets. 2 pipelines = 8 hot buckets.

---

## 📊 4. Monitor Pipeline Set Activity
**Component:** ✅ Monitoring Console (Search Head)  
**UI Path:** `Settings > Monitoring Console > Indexing > Indexing Performance: Advanced`

✅ **Use this on:** Monitoring Console connected to Indexers.  
**Why:** Observe per-pipeline ingestion metrics.

---

## 📡 5. Configure Multiple Pipelines on Forwarders
**Component:** ✅ Universal or Heavy Forwarder  
**File:** `$SPLUNK_HOME/etc/system/local/server.conf`

```ini
[general]
parallelIngestionPipelines = 2
pipelineSetSelectionPolicy = weighted_random
```

✅ **Add this to:** Heavy Forwarders (for data parsing/indexing tasks)  
❌ **Do NOT add this to:** Deployment Server, Cluster Master, or SH

**Why:** Only data-heavy forwarders benefit from parallel pipelines.

---

## ❌ 6. Avoid for Streaming Inputs
**Applies To:** ✅ All ingestion components (Indexers or Forwarders)  
❌ **DO NOT use with:** TCP or UDP inputs  
✅ **Use instead:** HTTP Event Collector (HEC)

**Why:** Streaming inputs need ordered processing. Parallelization may cause data corruption.

---

## ✅ 7. Summary Table of Component Usage

| Configuration                     | Component(s) Affected | File Location / Tool | Add To      | Avoid On       | Why                                        |
|----------------------------------|------------------------|----------------------|-------------|----------------|---------------------------------------------|
| Enable multiple pipelines        | Indexer, Forwarder     | server.conf          | Indexer, HF | SH, CM         | Only ingestion layers benefit               |
| Weighted random tuning           | Indexer                | server.conf          | Indexer     | Others         | Optimizes pipeline balancing                |
| Per-pipeline throughput settings | Indexer                | limits.conf          | Indexer     | Others         | Each pipeline gets this limit               |
| Per-pipeline hot bucket settings | Indexer                | indexes.conf         | Indexer     | Others         | Affects how many buckets per pipeline       |
| Monitor pipeline activity        | Monitoring Console (SH)| Console UI           | SH          | N/A            | For observing ingestion performance         |
| Avoid with TCP/UDP               | Indexer, Forwarder     | Use HEC instead      | Use HEC     | TCP/UDP        | Prevents streaming order loss              |

---

**Generated on:** {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}

[Managing Indexers and Clusters of Indexers](https://docs.splunk.com/Documentation/Splunk/latest/Indexer/Pipelinesets)

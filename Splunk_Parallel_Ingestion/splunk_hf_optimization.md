
# 📌 Use Case / Question

**"As a new Splunk engineer, your company is tripling the data they are receiving from syslogs and cloud sources via Heavy Forwarders. If your Heavy Forwarder already has sufficient resources, what are the best practices to optimize it without adding hardware?"**

---

## 🎯 Goal

Ensure the existing Heavy Forwarder (HF) handles 3× more data volume effectively, by optimizing ingestion performance, resource usage, and data forwarding throughput, without increasing hardware.

---

## 🔍 Step 1: Internal Assessment — Can the HF Handle More?

Before any tuning, answer these questions:

### ✅ CPU Capacity

- Is average CPU utilization below 60%?
- Do you have at least 3–4 available cores for pipeline processing?

**Check with:**

```bash
top
```

or

```spl
index=_internal sourcetype=splunkd component=Metrics group=per_process
| stats avg(cpu_seconds) by process
```

### ✅ Memory Headroom

- Is memory usage consistently under 75%?
- Is there no swapping?

**Check with:**

```bash
free -m
```

or

```spl
index=_internal sourcetype=splunkd component=Metrics group=per_process
| stats avg(mem_used) by process
```

### ✅ Disk I/O

- Are you using SSD-backed storage for $SPLUNK_HOME/var?
- Is I/O wait time low?

**Check with:**

```bash
iostat -x 1
```

or

```spl
index=_internal sourcetype=splunkd component=Metrics group=disk_usage
```

### ✅ Network Bandwidth

- Is outbound network throughput well below interface limits?
- No signs of TCP retransmits or slow sends?

**Check with:**

```bash
iftop
```

### ✅ Queue Health

- Are ingestion and forwarding queues not consistently full?

**Use SPL:**

```spl
index=_internal sourcetype=splunkd component=Metrics group=queue
| stats avg(current_size_kb), max(current_size_kb) by name
```

---

## 🟩 Decision Point

| Resource        | Threshold for Tuning | Proceed with Optimization? |
|----------------|----------------------|-----------------------------|
| CPU < 60%       | ✅ YES               | ✔️                          |
| Memory < 75%    | ✅ YES               | ✔️                          |
| Disk: SSD, low iowait | ✅ YES         | ✔️                          |
| Network OK      | ✅ YES               | ✔️                          |
| Queues not full | ✅ YES               | ✔️                          |

✅ **If all answers are green (YES), proceed to configuration.**

---

## 🛠 Step 2: Optimize Heavy Forwarder Configurations

### 🔄 1. Enable Multiple Ingestion Pipelines

**server.conf**

```ini
[general]
parallelIngestionPipelines = 2
pipelineSetSelectionPolicy = weighted_random
```

### ⚖️ 2. Optional: Tune Load Balancing Policy

**server.conf**

```ini
[general]
pipelineSetWeightsUpdatePeriod = 10
pipelineSetNumTrackingPeriods = 6
```

### ⚙️ 3. Tune Throughput and Queue Sizes

**limits.conf**

```ini
[thruput]
maxKBps = 0  # 0 = unlimited, as long as your disk & net can support it
```

**server.conf**

```ini
[queue=parsingQueue]
maxSize = 100MB
```

### 📤 4. Enable Efficient Multi-threaded Forwarding

**outputs.conf**

```ini
[tcpout]
defaultGroup = indexers

[tcpout:indexers]
server = indexer1:9997,indexer2:9997
maxQueueSize = 512MB
autoLBFrequency = 30
sendCookedData = true
useACK = true
```

### 🧼 5. Reduce Parsing Overhead (if applicable)

- Avoid unnecessary `EVAL-*` and `TRANSFORMS-*` in props.conf
- Only use `INDEXED_EXTRACTIONS` when truly needed
- Use file-based ingestion for syslog (via rsyslog or syslog-ng), not direct TCP

### 🧹 6. Remove Unused Inputs & Apps

- Delete unused modular inputs
- Remove UI-heavy apps that load unnecessary resources
- Keep only active TA and parsing logic

### 📊 7. Monitor Ongoing Health

Use Monitoring Console or custom SPL dashboards:

```spl
index=_internal sourcetype=splunkd component=Metrics group=queue
| stats avg(current_size_kb), max(current_size_kb) by name
```

---

## 🧾 Summary Table

| Area                     | Optimization Step                                |
|--------------------------|--------------------------------------------------|
| CPU/Memory/Disk Assessment | Check utilization before enabling features     |
| Ingestion Pipeline        | Enable 2 pipelines with parallelIngestionPipelines |
| Load Balancing            | Use weighted_random for better distribution     |
| Throughput                | Set maxKBps = 0 with proper hardware            |
| Forwarding Performance    | Use multiple indexers with ACK and queueing     |
| Parsing Overhead          | Simplify props.conf, avoid unnecessary transforms |
| App Bloat                 | Remove unused or heavy apps                     |
| Monitoring                | Use _internal metrics to track health           |

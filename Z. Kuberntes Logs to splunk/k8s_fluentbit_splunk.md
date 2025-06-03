
# 📘 Fluent Bit and Forward Kubernetes Logs to Splunk

## ✅ Overview
**Goal**: Use Fluent Bit as a lightweight log forwarder to send container logs from Kubernetes to Splunk's HTTP Event Collector (HEC).

## 🧱 Prerequisites
- **Kubernetes Cluster**: Running and accessible (e.g., EKS, AKS, GKE, or Minikube).
- **Splunk Instance**:
  - HEC enabled (`Settings > Data Inputs > HTTP Event Collector`).
  - Token generated and accessible.
- `kubectl` access.
- `Helm` (recommended for Fluent Bit installation).

## 🚀 Step-by-Step Setup

### 1. 🔧 Enable and Get Splunk HEC Token
In Splunk:

- Go to **Settings > Data Inputs > HTTP Event Collector**.
- Enable HEC if it's not already.
- Create a new token (e.g., `fluentbit-token`).

**Note**:
- Token (e.g., `ABCD-1234...`)
- HEC Endpoint: `https://<splunk-host>:8088`

### 2. 📦 Install Fluent Bit via Helm

Add the Fluent Bit Helm repo:
```bash
helm repo add fluent https://fluent.github.io/helm-charts
helm repo update
```

Install Fluent Bit with Splunk configuration:
```bash
helm install fluent-bit fluent/fluent-bit \
  --namespace kube-system \
  --set backend.type=splunk \
  --set backend.splunk.host=<splunk-host> \
  --set backend.splunk.port=8088 \
  --set backend.splunk.token=<your-hec-token> \
  --set backend.splunk.tls=on \
  --set backend.splunk.tls.verify=off \
  --set backend.splunk.sourcetype=_json \
  --set backend.splunk.index=kubernetes \
  --set backend.splunk.hec_key=event \
  --set backend.splunk.time_key=time \
  --set backend.splunk.time_key_nanos=true
```

Replace:
- `<splunk-host>` with your Splunk server (IP or DNS)
- `<your-hec-token>` with the HEC token from step 1

### 3. 🧪 Verify Logs in Splunk

Search in Splunk:
```spl
index=kubernetes sourcetype=_json
```

You should start seeing Kubernetes container logs coming in.

### 🔍 Optional: Customize Fluent Bit Filters

To enrich logs with Kubernetes metadata via Helm:
```bash
--set filters.kubernetes.enable=true
--set filters.kubernetes.match=*
```

This attaches pod labels, namespace, container name, etc., to logs.

### 📁 Alternative: Apply Manifests Without Helm

If you don’t want to use Helm, manually deploy Fluent Bit using YAML manifests from:

📁 https://github.com/fluent/fluent-bit-kubernetes-logging

Edit `fluent-bit.conf` and `outputs.conf` to configure Splunk as the output.

### 🧠 Tips

- Use index filtering in Splunk to separate logs logically.
- Monitor Fluent Bit pods:
```bash
kubectl logs -n kube-system -l app.kubernetes.io/name=fluent-bit
```
- For Splunk Cloud, ensure HEC endpoint is externally reachable.

---

## 🥇 Fluent Bit – Most Popular & Lightweight

### ✅ Why it’s the best choice:

| Feature                | Fluent Bit                                 |
|------------------------|---------------------------------------------|
| 🪶 Lightweight         | Written in C, uses very low memory/CPU      |
| ⚙️ Kubernetes native  | Official DaemonSet, Helm charts, auto-enrichment |
| 🔌 Splunk support     | Has a native Splunk HEC output plugin       |
| 🧠 Smart routing      | Supports filtering, parsing, tagging        |
| 🚀 Performance        | Optimized for high-volume clusters          |

### 🔥 Most cloud-native environments use Fluent Bit:
- **AWS EKS** default
- **GCP GKE** via Ops Agent
- **Azure AKS** (with custom Fluent Bit solutions)

---

## 🥈 Fluentd – More Flexible but Heavier

### ✅ Why you’d use it:

| Feature               | Fluentd                             |
|----------------------|--------------------------------------|
| 🔌 Plugin ecosystem  | Over 1000 plugins                    |
| 📦 Great for routing | Can chain multiple filters/outputs   |
| 🧰 Mature            | Long-standing project in CNCF        |

### ❌ Downsides:
- Higher memory usage
- Slightly harder to configure
- Overkill for simple log forwarding

---

## 🥉 Logstash – Powerful but Less Kubernetes-native

### ✅ Pros:

| Feature                  | Logstash                              |
|--------------------------|----------------------------------------|
| 🧠 Processing logic     | Ideal for enrichment and transformation |
| 🌐 Splunk plugin        | Official HEC output                     |

### ❌ Not ideal for Kubernetes:
- Heavier than Fluent Bit/Fluentd
- No native DaemonSet support
- Better for centralized ingestion

---

## 🛑 NXLog – Niche Use Case

### ✅ Good for:
- **Windows-based nodes**
- Hybrid environments (Windows + Linux)
- Compliance-heavy setups

### ❌ Not popular in Kubernetes:
- No official DaemonSet
- Less Kubernetes integration

---

## 🔚 Final Recommendation

| Use Case                          | Best Tool      |
|----------------------------------|----------------|
| General Kubernetes log forwarding| Fluent Bit ✅   |
| Complex routing/transformations  | Fluentd         |
| Centralized ingestion & enrichment| Logstash       |
| Windows/legacy environments      | NXLog           |

> 💡 **Use Fluent Bit unless you have a strong reason not to.** It's fast, Kubernetes-native, widely adopted, and integrates well with Splunk.

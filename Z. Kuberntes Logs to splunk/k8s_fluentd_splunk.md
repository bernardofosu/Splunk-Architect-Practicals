
# ✅ Overview
**Goal:** Use Fluentd to collect and ship logs from Kubernetes containers to Splunk's HTTP Event Collector (HEC).

## 🧱 Prerequisites
- Kubernetes cluster (Minikube, EKS, etc.)
- Splunk instance:
  - HEC enabled (Settings > Data Inputs > HTTP Event Collector)
  - HEC token created
- `kubectl` installed
- (Optional) Helm (if using Helm method)

## 🔐 Step 1: Enable and Configure Splunk HEC
In Splunk:

- Go to: **Settings > Data Inputs > HTTP Event Collector**
- Enable HEC if disabled
- Create a new HEC token (e.g., `fluentd-token`)

**Note the following:**

- Token (e.g., `ABCDEF-1234...`)
- Endpoint: `https://<splunk-host>:8088`

## 📦 Step 2: Install Fluentd DaemonSet in Kubernetes

### Option 1: Use Official Fluentd Kubernetes Manifests
Clone the official repo:

```bash
git clone https://github.com/fluent/fluentd-kubernetes-daemonset
cd fluentd-kubernetes-daemonset/fluentd-daemonset-splunk
```

### Option 2: Apply Manifest with Splunk Config

#### 🔧 fluentd-configmap.yaml
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: fluentd-config
  namespace: kube-system
data:
  fluent.conf: |
    <source>
      @type tail
      path /var/log/containers/*.log
      pos_file /var/log/fluentd-containers.log.pos
      tag kubernetes.*
      format json
      read_from_head true
    </source>

    <filter kubernetes.**>
      @type kubernetes_metadata
    </filter>

    <match **>
      @type splunk_hec
      hec_host https://<splunk-host>
      hec_port 8088
      hec_token <your-hec-token>
      hec_ssl true
      index kubernetes
      source fluentd
      sourcetype _json
    </match>
```

#### 🔧 fluentd-daemonset.yaml
```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluentd
  namespace: kube-system
spec:
  selector:
    matchLabels:
      name: fluentd
  template:
    metadata:
      labels:
        name: fluentd
    spec:
      serviceAccountName: fluentd
      containers:
      - name: fluentd
        image: fluent/fluentd-kubernetes-daemonset:v1.16-debian-splunk-1.1
        env:
          - name: FLUENTD_CONF
            value: "fluent"
        volumeMounts:
          - name: config-volume
            mountPath: /fluentd/etc/fluent.conf
            subPath: fluent.conf
          - name: varlog
            mountPath: /var/log
          - name: varlibdockercontainers
            mountPath: /var/lib/docker/containers
            readOnly: true
      volumes:
        - name: config-volume
          configMap:
            name: fluentd-config
        - name: varlog
          hostPath:
            path: /var/log
        - name: varlibdockercontainers
          hostPath:
            path: /var/lib/docker/containers
```

### 🚀 Apply the Config and DaemonSet
```bash
kubectl apply -f fluentd-configmap.yaml
kubectl apply -f fluentd-daemonset.yaml
```

## 🧪 Step 3: Verify Logs in Splunk
Search in Splunk:

```spl
index=kubernetes sourcetype=_json
```

You should see logs from containerized workloads.

## 🧠 Tips
- Use `@type kubernetes_metadata` to enrich logs with pod/namespace info.
- Validate logs via:

```bash
kubectl logs -n kube-system -l name=fluentd
```

- Adjust log level or filters inside the `fluent.conf` to tune what gets forwarded.

## 📌 Fluentd vs Fluent Bit

| Feature         | Fluentd       | Fluent Bit      |
|----------------|----------------|------------------|
| Language        | Ruby (heavier) | C (lightweight)  |
| Use Case        | Complex routing| Lightweight edge agent |
| Plugin support  | Many plugins   | Fewer plugins    |
| Resource usage  | Higher         | Lower            |

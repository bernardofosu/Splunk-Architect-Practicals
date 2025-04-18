# ❌ Deprecated: `splunk-sdk-python`

- 📦 Repo: [github.com/splunk/splunk-sdk-python](https://github.com/splunk/splunk-sdk-python)
- 🚫 Status: **Deprecated** and no longer actively maintained.
- 📉 Reason: Splunk is modernizing its SDKs to follow more standard REST client patterns and improve maintainability across different languages.

---

## ✅ What You Can Use Instead

### 1. Direct REST API Calls via Python

You can use Python libraries like `requests` to interact with Splunk's REST API directly.

Example:

```python
import requests
from requests.auth import HTTPBasicAuth

SPLUNK_HOST = 'https://splunk.mycompany.com:8089'
USERNAME = 'admin'
PASSWORD = 'your_password'

response = requests.get(
    f'{SPLUNK_HOST}/services/search/jobs',
    auth=HTTPBasicAuth(USERNAME, PASSWORD),
    verify=False  # Only if using self-signed certs
)

print(response.text)
```

> 🔐 Tip: Always store credentials securely (e.g., environment variables or secret managers).

> 📘 [Splunk REST API Reference](https://docs.splunk.com/Documentation/Splunk/latest/RESTREF/RESTprolog)

### 2. Community or Updated SDKs

There are unofficial SDKs and wrappers that keep the Python experience fresh, including:

- 🐍 `splunklib` (from older SDK, still usable but not future-proof)
- 🤝 Third-party community libraries (often built for specific use cases like sending events, alerts, etc.)

Let me know your use case, and I can recommend the best Python pattern or wrapper.

---

## 🧠 When You Should Use Which

| Use Case                        | Recommended Approach           |
|--------------------------------|--------------------------------|
| Quick search, index interaction| 🔄 Direct REST with requests   |
| Custom integrations            | 🔌 REST API + Python           |
| Automation or batch scripts    | ⚙️ Python + REST               |
| Enterprise-grade tools         | 💼 Consider Golang or JS SDKs |

---

## 📄 Use Case: Search Splunk Logs via API (Python + requests)

This script:

- ✅ Authenticates with Splunk's REST API
- 🧾 Submits a search job (e.g., error logs from last 15 mins)
- ⏳ Waits for the job to finish
- 📦 Fetches and prints results

---

## ✅ Requirements

- 🐍 Python 3.x
- 📦 `requests` library (`pip install requests`)

---

## 🐍 `splunk_search.py`

```python
import time
import requests
from requests.auth import HTTPBasicAuth

# 🌐 Splunk Settings
SPLUNK_HOST = "https://localhost:8089"
USERNAME = "admin"
PASSWORD = "changeme"  # 🔐 Use env vars in production!

# 🔍 Search Query
SEARCH_QUERY = 'search index=_internal sourcetype=splunkd ERROR'
SEARCH_PARAMS = {
    "search": f"| {SEARCH_QUERY}",
    "exec_mode": "normal",  # blocking or normal
}

# 🚀 Step 1: Submit the search job
print("[+] Submitting search job...")
response = requests.post(
    f"{SPLUNK_HOST}/services/search/jobs",
    data=SEARCH_PARAMS,
    auth=HTTPBasicAuth(USERNAME, PASSWORD),
    verify=False  # only disable in test/dev
)

if response.status_code != 201:
    print("[-] Failed to submit search job:", response.text)
    exit(1)

sid = response.json()["sid"]
print(f"[✓] Search Job SID: {sid}")

# ⏳ Step 2: Wait for job to complete
job_url = f"{SPLUNK_HOST}/services/search/jobs/{sid}"
while True:
    resp = requests.get(job_url, auth=HTTPBasicAuth(USERNAME, PASSWORD), verify=False)
    content = resp.text
    if "<s:key name=\"isDone\">1</s:key>" in content:
        print("[✓] Job completed!")
        break
    print("[...] Waiting for job to finish...")
    time.sleep(2)

# 📦 Step 3: Fetch results
results_url = f"{job_url}/results?output_mode=json"
results_resp = requests.get(results_url, auth=HTTPBasicAuth(USERNAME, PASSWORD), verify=False)

if results_resp.status_code == 200:
    results = results_resp.json()["results"]
    print(f"[✓] Got {len(results)} results:\n")
    for result in results:
        print(result)
else:
    print("[-] Failed to get results:", results_resp.text)
```

---

## 🛠️ Customize It!

You can change:

- 🔄 `SEARCH_QUERY` to target any index/sourcetype
- ⚡ Switch to `exec_mode=oneshot` if you want results immediately
- 📥 Add filtering or output to CSV/JSON

---

## 🔐 Security Tips

- 📁 Use environment variables or `.env` files for credentials
- 🔒 Validate SSL in production (`verify=True`)
- 🔄 Rotate API credentials regularly

---

Want an example for:

- 🔔 Sending alerts?
- 📥 Uploading logs to Splunk?
- 📊 Creating or editing dashboards?

Let me know! 🚀


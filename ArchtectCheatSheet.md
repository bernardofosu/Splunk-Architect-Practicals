# 💼 Splunk Search Head Cluster (SHC) Admin Mini-Kit

## ✅ Day-to-Day SHC Admin Cheatsheet

| Task | Command |
|------|---------|
| Check SHC status | `./splunk show shcluster-status -auth admin:pass` |
| Check conf replication status | `./splunk show shcluster-replication-status -auth admin:pass` |
| Bootstrap Captain (only once) | `./splunk bootstrap shcluster-captain -servers_list "<list>" -auth admin:pass` |
| Rolling Restart | `./splunk rolling-restart shcluster-members -auth admin:pass` |
| Apply Deployer Bundle | `./splunk apply shcluster-bundle -target https://deployer:8089 -auth admin:pass` |
| Remove Search Head from SHC | `./splunk remove shcluster-member -auth admin:pass` |

---

## ✅ Best REST APIs for Monitoring & Troubleshooting

| Purpose | REST Endpoint |
|---------|--------------|
| Captain Status | `GET /services/shcluster/captain/info` |
| Members Status | `GET /services/shcluster/member/info` |
| Search Head Peers | `GET /services/shcluster/members` |
| Conf Replication Status | `GET /services/shcluster/status` |
| Search Jobs Running | `GET /services/search/jobs` |
| Current Bundle Check | `GET /services/shcluster/config` |

💡 Example Command:
```bash
curl -ku admin:pass https://<SH>:8089/services/shcluster/status?output_mode=json | jq
```

---

## ✅ `shcluster-status` Output Explained (Field-by-Field)

| Field | Description |
|-------|------------|
| `dynamic_captain` | Is this node currently acting as captain? `1=Yes` |
| `elected_captain` | Timestamp when this captain election happened |
| `id` | Unique SHC member ID |
| `initialized_flag` | Is SHC initialized on this node? `1=Yes` |
| `kvstore_maintenance_status` | KV Store maintenance status (important for Captain) |
| `label` | Friendly name of the search head |
| `mgmt_uri` | Management URI of the SH |
| `min_peers_joined_flag` | Minimum peers joined? (`1=Yes`, all is OK) |
| `rolling_restart_flag` | Is a rolling restart in progress? |
| `service_ready_flag` | Is the cluster fully operational? `1=Yes` |
| `last_conf_replication` | Last time this member received replicated configurations |
| `status` | `Up` means the SH is online and participating |

---

## 🟣 Extra Pro Tip

You can monitor the SHC using REST calls in **Grafana, Nagios, or any monitoring tool** by querying `/services/shcluster/status` periodically.

✨ If you want, I can also provide:

- 🛠 **Troubleshooting flowchart for SHC**
- 🚀 **Most common SHC problems & fixes**
- 📄 **Captain election logic diagram**

Let me know! 🎯


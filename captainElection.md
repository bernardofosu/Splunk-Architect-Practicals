# ✅ Search Head Captain Election Explained

Since you ran:

```bash
./splunk bootstrap shcluster-captain -servers_list "https://172.31.24.196:8089,https://172.31.28.177:8089,https://172.31.86.130:8089" -auth admin:splunk123
```

👉 The node you executed this command on becomes the Captain immediately after successful bootstrap.

💡 **Why?**

- The bootstrap command triggers a captain election automatically.
- Since no other captain exists yet, the node you run it on will always win the election.
- Afterward, it will start managing:
  - 🍰 **Configuration Replication**
  - 🔄 **Rolling Restarts**
  - 🕵️‍♂️ **Search Artifact Replication**
  - 🧩 **Bundle Distribution**

---

## ✅ Pro Tips (Optional)

If you want, I can also show you:

- ✅ The full **Captain election rules** Splunk uses behind the scenes.
- ✅ How to **force a new election** safely if needed.
- ✅ How to **check if your SHC is in a healthy state** before & after captain bootstrapping.


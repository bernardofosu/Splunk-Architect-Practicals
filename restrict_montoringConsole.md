## ⚠️ Monitoring Console Data Access Warning

If the **Monitoring Console (MC)** is not properly configured with restricted permissions, it can potentially access actual data from indexers or search peers.

---

## 🛡️ Why This Happens

- **Distributed Search Access:** If the MC is connected to search peers and has search-level access, it could query and view all indexed data.
- **Role-Based Access Control (RBAC):** Without proper role management, MC users might inherit permissions that allow them to access sensitive data.
- **Incorrect Configuration:** If the MC is mistakenly given the `admin` role or a similar role with broad access, it can view both monitoring data and event data.

---

## 🛠️ How to Prevent Data Access from the Monitoring Console

Follow these steps to ensure the Monitoring Console only accesses monitoring data:

### 1. **Create a Dedicated Monitoring Role**
- Go to **Settings → Access Controls → Roles**.
- Create a role with limited capabilities, ensuring it has access only to monitoring indexes (`_internal`, `_audit`, `_introspection`).

### 2. **Assign Limited Access**
- Assign the newly created role to users who only need MC access.

### 3. **Configure Index Permissions**
- Ensure that the role has no access to production or sensitive data indexes.

### 4. **Set Monitoring Console to Only View Metrics**
- On the Monitoring Console, ensure it is only collecting health metrics and operational data.
- Prevent it from executing search queries that may fetch event data.

---

✅ This way, even if the MC connects to search peers, it will only view **operational data** and not actual log data.

🔎 Need further clarification? Feel free to ask!


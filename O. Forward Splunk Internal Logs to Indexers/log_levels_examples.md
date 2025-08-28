# 🔹 Common Log Levels with Real-World Examples

## 🔍 DEBUG -- Detailed troubleshooting info

**Meaning:** Very detailed, step-by-step logging to trace why something
isn't working.

**Examples:**\
- Web server:
`DEBUG: TLS handshake failed on attempt 2, cipher=TLS_AES_128_GCM_SHA256`\
- Database:
`DEBUG: Executing SQL query: SELECT * FROM users WHERE id=42`\
- Network:
`DEBUG: Retrying connection to 10.0.0.5:443 after timeout=500ms`

👉 **Use case:** When analyzing failed connections, misconfigurations,
or tracing step-by-step execution.

------------------------------------------------------------------------

## ℹ️ INFO -- Normal operations

**Meaning:** Confirms that things worked as expected.

**Examples:**\
- Web server: `INFO: User john.doe logged in successfully`\
- Database: `INFO: Connection pool established with 10 clients`\
- System: `INFO: Service nginx started on port 80`

👉 **Use case:** For audit trails, success confirmations, and
operational reporting.

------------------------------------------------------------------------

## ⚠️ WARNING -- Something unusual, could become a problem

**Meaning:** Alerts you before something breaks.

**Examples:**\
- Disk usage: `WARNING: /var/log is 85% full`\
- Authentication: `WARNING: 5 failed login attempts for user admin`\
- Performance:
`WARNING: API response time degraded: avg=950ms (threshold=800ms)`

👉 **Use case:** Capacity planning, anomaly detection, early alerts.

------------------------------------------------------------------------

## ❌ ERROR -- Something failed

**Meaning:** Indicates a problem that stopped functionality.

**Examples:**\
- Web server: `ERROR: Failed to write log file: Permission denied`\
- Database: `ERROR: Could not connect to PostgreSQL on 127.0.0.1:5432`\
- System: `ERROR: Payment service returned 500 – Internal Server Error`

👉 **Use case:** Incident response, alerting, things users are already
experiencing as broken.

------------------------------------------------------------------------

## 🚨 CRITICAL / FATAL -- System crash or unrecoverable failure

**Meaning:** The system cannot continue running.

**Examples:**\
- Database: `FATAL: Out of memory – shutting down PostgreSQL`\
- OS: `CRITICAL: Kernel panic – not syncing: Attempted to kill init!`\
- App: `CRITICAL: Service crashed, unhandled exception in main()`

👉 **Use case:** Urgent alerting & escalation → requires immediate
action.

------------------------------------------------------------------------

# 📌 Quick Way to Remember

-   🔍 **Debug** = why it failed (deep details).\
-   ℹ️ **Info** = what succeeded.\
-   ⚠️ **Warning** = about to fail.\
-   ❌ **Error** = failed now.\
-   🚨 **Critical** = system is dead.

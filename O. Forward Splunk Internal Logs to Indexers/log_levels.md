# 🔹 Common Log Levels & Their Meaning

## 🔍 Debug

**Meaning:** Very detailed information intended for
developers/troubleshooting.\
Captures everything --- function calls, variable values, system state.

**Example:** `DEBUG: Connection retry count = 3`

**When to monitor:**\
- During development or deep troubleshooting.\
- Usually not enabled in production because it generates massive volumes
of logs.

------------------------------------------------------------------------

## ℹ️ Info

**Meaning:** General runtime events that confirm things are working as
expected.\
Normal operations like starting services, successful connections,
completed tasks.

**Example:** `INFO: User login successful for ID=1234`

**When to monitor:**\
- Always useful for baseline monitoring.\
- Helps in auditing system behavior without overwhelming log storage.

------------------------------------------------------------------------

## ⚠️ Warning

**Meaning:** Something unexpected happened, but the system can continue
running.\
Could indicate a future problem if ignored.

**Example:** `WARN: Disk usage at 85% capacity`

**When to monitor:**\
- In production, warnings should trigger alerts for preventive action.\
- Useful for capacity planning and early detection of issues.

------------------------------------------------------------------------

## ❌ Error

**Meaning:** A failure occurred that prevented some functionality from
working.

**Example:** `ERROR: Database connection failed`

**When to monitor:**\
- Always in production monitoring.\
- Critical for incident response because errors indicate lost
functionality.

------------------------------------------------------------------------

## 🚨 Critical / Fatal

**Meaning:** System failure or unrecoverable error --- application may
crash or shut down.

**Example:** `FATAL: Out of memory, shutting down`

**When to monitor:**\
- Must be part of alerting/monitoring dashboards.\
- Immediate incident response required.

------------------------------------------------------------------------

# 🔹 Which Levels Matter Most for Analysis?

-   **Debug:** For deep troubleshooting, not continuous monitoring.\
-   **Info:** For normal operations tracking.\
-   **Warning + Error + Critical:** For monitoring & alerting in
    production.

👉 **Best practice:**\
- **Production systems:** Focus on Info, Warning, Error, Critical.\
- **Troubleshooting sessions:** Enable Debug temporarily to dig into
issues.

------------------------------------------------------------------------

# 🔹 How to Think About Log Levels in Monitoring

-   🔍 **DEBUG → Why didn't it work?**\
    Extremely detailed, step-by-step logging.\
    Use when investigating why a connection or process failed (root
    cause analysis).\
    Example: `Retry #3 connecting to DB with timeout=500ms`.

-   ℹ️ **INFO → What worked successfully?**\
    Records normal operations (things that went right).\
    Useful for audits, history, and confirming that services are
    functioning.\
    Example: `User authenticated successfully`.

-   ⚠️ **WARNING → What might go wrong soon?**\
    Something is unusual but hasn't failed yet.\
    Good for proactive monitoring (catch issues before they break).\
    Example: `Disk space at 85%`.

-   ❌ **ERROR → What is broken right now?**\
    Indicates failures that stopped something from working properly.\
    Must be monitored and usually alerts are tied here.\
    Example: `Database connection failed — unable to write log entry`.

-   🚨 **CRITICAL/FATAL → What killed the system?**\
    Unrecoverable failures → system crash or shutdown.\
    Always alert immediately.\
    Example: `Out of memory — terminating process`.

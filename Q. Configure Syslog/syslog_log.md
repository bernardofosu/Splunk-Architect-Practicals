🔢 Syslog Severity Levels (There are 8 total)
Level	Code	Description	Typical Use
0 🔥	emerg	System is unusable	Rare, system-wide failure
1 🚨	alert	Immediate action required	Hardware faults, auth server down
2 ❗	crit	Critical conditions	Kernel panic, database crash
3 ❌	err	Error conditions	Failed login, service failure
4 ⚠️	warn	Warning conditions	Disk usage high, retries
5 🔔	notice	Normal but significant	Service started, config loaded
6 ℹ️	info	Informational	User login success, cron jobs
7 🐞	debug	Debug-level messages	Internal variables, code flow

🔒 Which Levels Are Security-Relevant (for Splunk)?
Generally:

err, crit, alert, and emerg → ✅ Security-focused

Logs like:

Failed/successful login attempts

Firewall alerts

IDS/IPS messages

Auth errors, sudo usage

These should be routed to Splunk or your SIEM.

📈 Which Levels Are for Observability (Grafana/ELK)?
info, notice, warn, and some debug → ✅ Observability-focused

Logs like:

Service start/stop

Metrics, heartbeat

Performance logs (latency, CPU, etc.)

These are useful for Grafana, Elastic Stack (ELK), or Prometheus to track app health, availability, and performance.

📬 Example Routing in Cribl:
js
Copy code
if (event.syslog_severity <= 3) {
  route.to("splunk");
} else {
  route.to("grafana");
}
✅ Summary
Severity Range	Use For	Send To
0–3 (emerg to err)	Security, Audit Logs	✅ Splunk / SIEM
4–7 (warn to debug)	Observability, Health	✅ Grafana / ELK
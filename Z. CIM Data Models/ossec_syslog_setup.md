
# 📡 How to Set Up Syslog Output in OSSEC

## 🔧 Configuring the Syslog Servers

OSSEC allows you to send alerts to one or more syslog servers. You can configure different alert levels for different servers.

### Example Configuration

```xml
<syslog_output>
  <server>192.168.4.1</server>
</syslog_output>

<syslog_output>
  <level>10</level>
  <server>10.1.1.1</server>
</syslog_output>
```

## 🖥️ Enabling `client-syslog`

After configuring the syslog servers, run the following commands:

```bash
/var/ossec/bin/ossec-control enable client-syslog
/var/ossec/bin/ossec-control start
```

## 🧪 Checking the Configuration

After restarting OSSEC, you should see `ossec-csyslogd` starting:

```
OSSEC HIDS v1.6 Stopped
Starting OSSEC HIDS v1.6 (by Third Brigade, Inc.).
Started ossec-csyslogd.
```

Check logs using:

```bash
tail -n 1000 /var/ossec/logs/ossec.log | grep csyslog
```

Expected output:

```
INFO: Started (pid: 19412).
INFO: Forwarding alerts via syslog to: 192.168.4.1:514
INFO: Forwarding alerts via syslog to: 10.1.1.1:514
```

## 📥 Syslog Server Output Example

On the syslog server, you should see messages like:

```
Jul 25 12:17:41 enigma ossec: Alert Level: 3; Rule: 5715 - SSHD authentication success.; Location: (jul) 192.168.2.0->/var/log/messages; srcip: 192.168.2.190; user: root; Jul 25 13:26:24 slacker sshd[20440]: Accepted password for root from 192.168.2.190 port 49737 ssh2
```

---

📚 **Documentation Source**: OSSEC Documentation 1.0  
© 2019, OSSEC Project. Created using Sphinx 1.1.3.

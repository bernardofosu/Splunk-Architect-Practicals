# 🛡️ How to Install and Configure OSSEC on Ubuntu Linux

## 📌 Overview

**OSSEC** is an open-source, host-based intrusion detection system (HIDS) that provides real-time log analysis, integrity checking, Windows registry monitoring, rootkit detection, and active response.

This guide shows how to install and configure OSSEC (v2.9.0) and the OSSEC Web UI on Ubuntu 16.04.

---

## 🖥️ System Requirements

* Ubuntu 16.04 Server
* Static IP: `192.168.15.189`
* Hostname: `localhost`

---

## 🔧 Step 1: Install Required Dependencies

```bash
apt-get update -y
apt-get upgrade -y

apt-get install build-essential gcc make apache2 \
libapache2-mod-php7.0 php7.0 php7.0-cli php7.0-common \
apache2-utils unzip wget sendmail inotify-tools -y
```

---

## 📥 Step 2: Download and Extract OSSEC

```bash
wget https://github.com/ossec/ossec-hids/archive/2.9.0.tar.gz
tar -xvzf 2.9.0.tar.gz
cd ossec-hids-2.9.0
```

---

## ⚙️ Step 3: Install OSSEC

```bash
sh install.sh
```

* Language: `en`
* Installation type: `local`
* Enable email notification: `y`
* Email address: `root@localhost`
* Use SMTP server `127.0.0.1`: `y`
* Enable integrity check daemon: `y`
* Enable rootkit detection: `y`
* Enable active response: `y`
* Enable firewall-drop response: `y`
* Add white list IPs: `n`
* Enable remote syslog: `y`

After installation:

```bash
/var/ossec/bin/ossec-control start
```

---

## 🛠️ Step 4: Configure OSSEC

### Edit Main Config:

```bash
vi /var/ossec/etc/ossec.conf
```

Add or modify:

```xml
<global>
  <email_notification>yes</email_notification>
  <email_to>root@localhost</email_to>
  <smtp_server>127.0.0.1</smtp_server>
  <email_from>ossecm@localhost</email_from>
</global>

<syscheck>
  <frequency>79200</frequency>
  <alert_new_files>yes</alert_new_files>
</syscheck>

<directories report_changes="yes" realtime="yes" check_all="yes">/etc,/usr/bin,/usr/sbin</directories>
<directories report_changes="yes" realtime="yes" check_all="yes">/var/www,/bin,/sbin</directories>
```

### Edit Local Rules:

```bash
vi /var/ossec/rules/local_rules.xml
```

Add:

```xml
<rule id="554" level="7" overwrite="yes">
  <category>ossec</category>
  <decoded_as>syscheck_new_entry</decoded_as>
  <description>File added to the system.</description>
  <group>syscheck,</group>
</rule>
```

Restart OSSEC:

```bash
/var/ossec/bin/ossec-control restart
```

---

## 🌐 Step 5: Install OSSEC Web UI

```bash
wget https://github.com/ossec/ossec-wui/archive/master.zip
unzip master.zip
mv ossec-wui-master /var/www/html/ossec
cd /var/www/html/ossec
./setup.sh
```

* Username: `admin`
* Password: your choice
* Web user: `www-data`

Restart Apache:

```bash
systemctl restart apache2
```

---

## ✅ Step 6: Test OSSEC

Modify files like:

```bash
/etc/network/interfaces
/etc/rc.local
/etc/fstab
```

Check email alerts:

```bash
mail
```

Typical alerts:

```
Integrity checksum changed for: '/etc/aliases'
Integrity checksum changed for: '/etc/fstab'
...
```

Also, access the OSSEC Web UI via browser to verify it's working.

---

## 📬 Common OSSEC Commands

```bash
/var/ossec/bin/ossec-control start       # Start OSSEC
/var/ossec/bin/ossec-control stop        # Stop OSSEC
/var/ossec/bin/ossec-control restart     # Restart OSSEC
/var/ossec/bin/manage_agents             # Manage agents
/var/ossec/bin/ossec-control enable client-syslog
```

---

## 📚 References

* [Official OSSEC Docs](https://www.ossec.net/docs/)
* [GitHub: OSSEC HIDS](https://github.com/ossec/ossec-hids)

---

> 🛡️ OSSEC is now installed, configured, and ready to defend your system!

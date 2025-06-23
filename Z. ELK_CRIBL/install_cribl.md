# 🐧 Cribl Stream Full Linux Install Guide (Manual, Self-Hosted)

🔐 Open Port **9000** in your Security Group

✅ **1. Create a Dedicated `cribl` User**
```bash
sudo su
sudo useradd --system --shell /bin/bash --create-home cribl
passwd cribl
sudo usermod -aG sudo cribl
```
- `--system`: marks the user as a system account  
- `--create-home`: creates `/home/cribl`

**Manual Way:**
```bash
sudo visudo -f /etc/sudoers.d/cribl
```
Then add:
```bash
cribl ALL=(ALL) NOPASSWD:ALL
```

### 🧪 CLI Command:
```bash
echo 'cribl ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/cribl
```

📥 **2. Download and Install Cribl**

[📥 Cribl Download Page](https://cribl.io/download/) 

![Download Cribl](download-crible.jpg) 
```bash
cd /opt
sudo curl -Lso - $(curl https://cdn.cribl.io/dl/latest-x64) | tar zxv

ll or ls -l /opt/cribl # to check ownership
```
This installs Cribl into your home directory (`/home/cribl/cribl`)

🧠 What it does, step-by-step:
```sh
curl https://cdn.cribl.io/dl/latest-x64
```
🔍 This fetches a dynamic URL pointing to the latest Cribl Stream .tar.gz release for 64-bit Linux.

Example output: https://cdn.cribl.io/dl/cribl-4.5.2-x64.tgz
```sh
curl -Lso - [URL]
```
📦 Downloads the .tgz file from that URL:
- -L follows redirects
- -s runs silently
- -o - writes the output to stdout

**| tar zxv**: 📂 This pipes the downloaded file directly to tar for extraction:
- z: unzip (gzip)
- x: extract
- v: verbose (list files as they're unpacked)

✅ **3. Run Cribl Stream (First Time)**
```bash
cd /opt/cribl/bin
sudo ./cribl boot-start enable
sudo systemctl status cribl
sudo systemctl start cribl

sudo ./cribl version
sudo ./cribl status
Cribl#2025!
```
Web UI usually available at: `http://<your-server>:9000`  
Default username/password: `admin / changeme` (you’ll be prompted to change it)

For Cribl, the directory /opt/cribl can remain owned by root while ensuring the service runs properly with the necessary permissions granted through systemd. There is no need to change ownership to the cribl user. However, you should ensure the correct permissions are applied for specific Cribl user needs, and the boot-start enable command should be run with root privileges, which is what you did.

![Download Cribl for Windows](./download-crible-windows.jpg)

🔗 **Resources**  
- [📥 Cribl Download Page](https://cribl.io/download/)  
- [▶️ YouTube: Cribl Stream Installation Guide](https://www.youtube.com/watch?v=_ujfK4gk-1I)
- [▶️ YouTube: Cribl Stream and Cribl Edge](https://www.youtube.com/watch?v=bHoX79QFWtU)


![Cribl First Page](./crible-first-page.jpg)

![Cribl Second Page](./crible-second-page.jpg)

![Cribl Home Page](./crible-interface.jpg)


```sh
● cribl.service - Systemd service file for Cribl Stream.
     Loaded: loaded (/etc/systemd/system/cribl.service; enabled; preset: enabled)
     Active: active (running) since Thu 2025-04-17 01:08:58 UTC; 4s ago
    Process: 2765 ExecStart=/opt/cribl/bin/cribl start (code=exited, status=0/SUCCESS)
   Main PID: 2692 (cribl)
      Tasks: 0 (limit: 4674)
     Memory: 4.0K (peak: 156.2M)
        CPU: 1.268s
     CGroup: /system.slice/cribl.service
             ‣ 2692 /opt/cribl/bin/cribl server
```

```sh
cribl@ip-172-31-86-19:/opt/cribl/bin$ sudo ./cribl status
Address: http://172.31.86.19:9000
Mode: single
Status: Up
Software Version: 4.11.0-91dddbde
Config Version: ce9ce0d
PID: 2692
GUID: 88a23c8a-835d-454e-9775-10dbbdc6a089
```
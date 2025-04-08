# 🛠️ Cribl Installation Guide with Emojis

Cribl is a powerful data routing and shaping platform to manage log processing and forwarding. Below are installation methods for different environments: Linux, Docker, Kubernetes, and cloud platforms.

---

## 1️⃣ Install Cribl on Linux (Ubuntu/Debian)

🧰 **Step-by-step guide:**

1. **Download and Install Cribl:**
```bash
curl -sSL https://www.cribl.io/downloads/cribl-linux-x86_64.tar.gz -o cribl.tar.gz
```

2. **Extract the tarball:**
```bash
tar -xvzf cribl.tar.gz
cd cribl-<version>/bin
```

3. **Start Cribl:**
```bash
./cribl start
```

4. **🌐 Access Cribl UI:** [http://localhost:9000](http://localhost:9000) or your machine IP.

5. **⚙️ Configure Cribl:** via the web UI.

6. **🧹 Uninstall:**
```bash
./cribl stop
rm -rf /path/to/cribl
```

---

## 2️⃣ Install Cribl Using Docker 🐳

1. **Pull Docker Image:**
```bash
docker pull cribl/cribl:latest
```

2. **Run Cribl container:**
```bash
docker run -d --name cribl -p 9000:9000 cribl/cribl:latest
```

3. **🛑 Stop container:**
```bash
docker stop cribl
```

4. **🗑️ Remove container:**
```bash
docker rm cribl
```

---

## 3️⃣ Install Cribl on Kubernetes ☸️

1. **Add Helm repo:**
```bash
helm repo add cribl https://cribl.github.io/cribl-helm/
helm repo update
```

2. **Install Cribl:**
```bash
helm install cribl cribl/cribl
```

3. **🌐 Access Cribl UI:** via [Cluster IP]:9000

4. **🧹 Uninstall:**
```bash
helm uninstall cribl
```

---

## 4️⃣ Install Cribl on AWS EC2 ☁️ (Amazon Linux)

1. **Update system & install packages:**
```bash
sudo yum update -y
sudo yum install -y curl wget
```

2. **Download and start Cribl:**
```bash
curl -sSL https://www.cribl.io/downloads/cribl-linux-x86_64.tar.gz -o cribl.tar.gz
tar -xvzf cribl.tar.gz
cd cribl-<version>/bin
./cribl start
```

3. **🌐 Access Cribl UI:** [http://<EC2-Public-IP>:9000](http://<EC2-Public-IP>:9000)

---

## 5️⃣ Install Cribl on Azure VM ☁️ (Ubuntu)

1. **Install dependencies:**
```bash
sudo apt-get update -y
sudo apt-get install -y curl wget
```

2. **Download & start Cribl:**
```bash
curl -sSL https://www.cribl.io/downloads/cribl-linux-x86_64.tar.gz -o cribl.tar.gz
tar -xvzf cribl.tar.gz
cd cribl-<version>/bin
./cribl start
```

3. **🌐 Access Cribl UI:** [http://<VM-Public-IP>:9000](http://<VM-Public-IP>:9000)

---

## 6️⃣ Install Cribl with Docker Compose 🐳📦

1. **Create `docker-compose.yml`:**
```yaml
version: '3'
services:
  cribl:
    image: cribl/cribl:latest
    ports:
      - "9000:9000"
    environment:
      - CRIBL_USERNAME=admin
      - CRIBL_PASSWORD=admin
    volumes:
      - cribl-data:/cribl/data

volumes:
  cribl-data:
```

2. **Run Docker Compose:**
```bash
docker-compose up -d
```

3. **🌐 Access Cribl UI:** [http://localhost:9000](http://localhost:9000)

---

## 7️⃣ Install Cribl on Google Cloud ☁️ (GCE Ubuntu)

1. **SSH into instance:**
```bash
gcloud compute ssh <instance-name>
```

2. **Install Cribl:**
```bash
curl -sSL https://www.cribl.io/downloads/cribl-linux-x86_64.tar.gz -o cribl.tar.gz
tar -xvzf cribl.tar.gz
cd cribl-<version>/bin
./cribl start
```

3. **🌐 Access Cribl UI:** [http://<GCE-Public-IP>:9000](http://<GCE-Public-IP>:9000)

---

## ✅ Conclusion

You can install Cribl using multiple methods:

- 🖥️ Manual Linux/cloud setup
- 🐳 Docker & Docker Compose
- ☸️ Kubernetes (Helm)

Each environment offers flexibility and scalability—choose what fits your infrastructure best. 🎯


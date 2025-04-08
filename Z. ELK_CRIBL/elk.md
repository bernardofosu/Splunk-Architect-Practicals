# ELK Stack Installation Guide (Elasticsearch, Logstash, Kibana) 🐘📊🔍

This guide provides comprehensive steps for installing the ELK stack both manually and using Docker. 🚀🐳

---

## 1. Manual Installation of ELK Stack 🛠️

### Step 1: Install Java ☕ (Required for Elasticsearch and Logstash)

#### For Ubuntu/Debian:
```bash
sudo apt update
sudo apt install openjdk-11-jre
java -version
```

#### For CentOS/RHEL:
```bash
sudo yum install java-11-openjdk
java -version
```

### Step 2: Install Elasticsearch 📦

#### Add Elasticsearch APT Repository (for Debian/Ubuntu):
```bash
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo sh -c 'echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" > /etc/apt/sources.list.d/elastic-7.x.list'
sudo apt update
```

#### Install Elasticsearch:
```bash
sudo apt install elasticsearch
```

#### Enable and Start Elasticsearch:
```bash
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch
```

#### Verify Elasticsearch is Running:
Open your browser and go to `http://localhost:9200`. 🌐 You should see JSON output confirming Elasticsearch is running. ✅

### Step 3: Install Logstash 📥

#### Add Logstash APT Repository:
```bash
sudo sh -c 'echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" > /etc/apt/sources.list.d/elastic-7.x.list'
sudo apt update
```

#### Install Logstash:
```bash
sudo apt install logstash
```

#### Configure Logstash:
Create a configuration file, e.g., `/etc/logstash/conf.d/logstash.conf`:
```plaintext
input {
  file {
    path => "/var/log/syslog"
    start_position => "beginning"
  }
}
output {
  elasticsearch {
    hosts => ["http://localhost:9200"]
  }
}
```

#### Enable and Start Logstash:
```bash
sudo systemctl enable logstash
sudo systemctl start logstash
```

#### Verify Logstash:
```bash
curl -XGET 'localhost:9200/_search?q=syslog'
```

### Step 4: Install Kibana 📈

#### Install Kibana:
```bash
sudo apt install kibana
```

#### Configure Kibana:
Edit `/etc/kibana/kibana.yml`:
```yaml
server.host: "0.0.0.0"
elasticsearch.hosts: ["http://localhost:9200"]
```

#### Enable and Start Kibana:
```bash
sudo systemctl enable kibana
sudo systemctl start kibana
```

#### Access Kibana:
Open a browser and go to `http://localhost:5601`. 🧭 You should see the Kibana dashboard. 🎉

### Step 5: Accessing the Stack 🌐
- **Elasticsearch:** http://localhost:9200
- **Kibana:** http://localhost:5601

---

## 2. Docker Installation of ELK Stack 🐳📦

You can use Docker to easily deploy the ELK stack. Here’s a quick guide using Docker Compose. ⚙️

### Step 1: Install Docker & Docker Compose 🔧
- Follow the official Docker and Docker Compose installation guides for your system.

### Step 2: Create Docker Compose Configuration 📝

#### Create a new directory:
```bash
mkdir elk-stack && cd elk-stack
```

#### Create `docker-compose.yml`:
```yaml
version: '3.7'

services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.10.0
    environment:
      - discovery.type=single-node
      - cluster.name=elasticsearch
      - bootstrap.memory_lock=true
    ulimits:
      memlock:
        soft: -1
        hard: -1
    networks:
      - elk
    ports:
      - "9200:9200"

  logstash:
    image: docker.elastic.co/logstash/logstash:7.10.0
    environment:
      - "LS_JAVA_OPTS=-Xmx256m -Xms256m"
    ports:
      - "5044:5044"
    networks:
      - elk
    depends_on:
      - elasticsearch

  kibana:
    image: docker.elastic.co/kibana/kibana:7.10.0
    ports:
      - "5601:5601"
    networks:
      - elk
    depends_on:
      - elasticsearch

networks:
  elk:
    driver: bridge
```

### Step 3: Run Docker Compose ▶️
```bash
docker-compose up -d
```

### Step 4: Verify Services 🔍
```bash
docker ps
```
You should see services for:
- elasticsearch: 9200
- logstash: 5044
- kibana: 5601

### Step 5: Accessing the Stack 🌍
- **Elasticsearch:** http://localhost:9200
- **Kibana:** http://localhost:5601

### Step 6: Stop the Stack ⏹️
```bash
docker-compose down
```

---

## Summary 📚
- **Manual Installation:** Full control and flexibility, but more complex. 🧠
- **Docker Installation:** Quick and easy, ideal for testing and isolated environments. ⚡


# 🚀 Quick Recap

## 📌 Summary of Discussion

### 🔹 Progress and Testing Environment Requirements
Charles discussed the progress of their environment and the need to ship it today. He also mentioned the need to change instance types. Charles suggested that they continue their current process, which has been ongoing for about 4 to 5 weeks. He emphasized the importance of practical questions and the need to cross-check answers with a strong document. He also warned against relying solely on online documents, as they may contain incorrect information or changes after software upgrades.

### 🌐 Updating Deployment Server's IP Address
Charles encountered an issue using the internal IP address instead of the public IP when accessing AWS instances from his local machine. Some team members figured out the solution. He emphasized problem-solving skills and encouraged learning from experiences. Charles guided the team through updating the deployment server's IP address, demonstrating how to use the command line to make changes and restart the service. He stressed the importance of checking command history for troubleshooting and explained that the public IP needs updating whenever instances stop and restart.

### 🔄 Configuring Server Classes and Disaster Recovery
Charles demonstrated adding clients to a server class in a Splunk configuration for disaster recovery. He showed the structure with one app and two server classes (Linux and Windows), explaining how clients can be included or excluded from a specific server class. He reviewed the app’s contents, including the disaster recovery configuration, and discussed pushing this app to clients.

### 🖥️ Linux Deployment Server Command Demonstration
Charles demonstrated how to run a command on a Linux deployment server, updating the configuration with the correct IP address. He explained the importance of running the command from the correct directory and with the right permissions. The team verified the configuration update in the UI, adding clients to the application and discussing client inclusion and exclusion. The process concluded with successfully deploying the app to Linux and Windows clients.

### 🛠️ Troubleshooting App Deployment and Replication Issues
Charles and Lawrence discussed troubleshooting app deployment. They confirmed the app's location and attempted to enable a listener on indices. When pushing the configuration, they encountered replication factor errors. Charles initiated a data rebalancing process to resolve the issue.

### 🔄 System Reboot and Index Creation Meeting
Charles and Lawrence discussed rebooting the system to resolve an issue. Charles was hesitant but agreed after Lawrence reassured him it wouldn't affect instances. They proceeded with creating indices for storing Windows and Linux logs. Bernard assisted with removing an unwanted directory, and the team collaborated on renaming files and folders for consistency.

### 📂 Configuring Elasticsearch Index Tiers and Path
Charles explained the configuration of Elasticsearch indices, focusing on setting up different data tiers (hot, warm, cold) and managing data volumes. He emphasized tailoring settings based on the client’s needs and data volumes. Nana asked about path configuration for hot and warm tiers, which Charles explained.

### 🔒 Configuring Index Access for Security
Charles explained the importance of pushing incremental configurations to indices for easier troubleshooting. He demonstrated checking the status of applied changes and confirmed the presence of indices on the servers. He then showed how to disable access to indices via the UI for security reasons and explained managing access based on user roles and permissions.

### 🛠️ Lances Installation and Instances Configuration
Charles reviewed Lances installation, explaining that it can be installed on either a manager node or a deployment server, which becomes the Lances master. Other instances are configured as Lances slaves. He demonstrated installation using the smart web interface and showed how to add instances to the Lances manager by updating configurations.

### 🔍 Setting Up Distributed Search Environment
Charles provided instructions on configuring search peers in Splunk. He guided the team through using internal IPs of instances and setting passwords. He demonstrated adjustments for roles and settings, including the license manager and deployment server. He instructed the team to complete steps G through L of a document, which includes installing an app for normalizing logs. He emphasized the importance of practicing and preparing to rebuild the environment independently. Next week, they will complete the multi-cluster setup and conduct a full rebuild as a final exercise.

---

## ⏭️ Next Steps

- ✅ All students to complete steps G through K of the infrastructure setup process.
- ✅ Ensure the monitoring console is working properly.
- 📌 Charles to add the Indesa discovery information to the shared document.
- 📄 Charles to send additional materials and documents to students.
- ✍️ Students to take detailed notes and prepare to rebuild the infrastructure independently.
- 🔧 Charles to cover multi-cluster setup and finalize the topic in the next session.
- 🔄 Charles to guide students through destroying and rebuilding the infrastructure in an upcoming session.


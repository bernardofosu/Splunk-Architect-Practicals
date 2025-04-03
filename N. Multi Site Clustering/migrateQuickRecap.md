# 📢 **Quick Recap**

Charles led a technical discussion on setting up and managing a multi-site Splunk environment, covering topics such as EC2 instance configuration, replication factors, and conversion from single-site to multi-site deployments. The team addressed challenges related to cloud resource management, costs, and software compatibility. Charles emphasized the importance of understanding course materials and putting in effort, as graduation and job interviews approach.

---

## 🛠 **Next Steps**

- ✅ **Team:** Build a multi-site cluster environment with 3 indexers for site one and 3 indexers for site two, plus two search heads.
- ✅ **Team:** Configure the multi-site cluster following these steps:
  - Enable maintenance mode.
  - Configure site settings on the manager node and indexers.
  - Configure search heads.
  - Disable maintenance mode.
- 📹 **Charles:** Share today's session video recording once completed.
- 🎥 **Charles:** Create and share video tutorials for cluster configuration and class content.
- 📄 **Charles:** Share last week's documentation and configuration slides for the app setup.
- 💳 **Team:** Apply for $300 AWS training credits through the provided link.
- 🎤 **Team:** Prepare 2-minute presentations to demonstrate the multi-site cluster environment.
- 📚 **Team:** Review Splunk documentation on legacy bucket migration and multi-site configuration details.
- 📝 **Team:** Study and review all provided documentation to prepare for upcoming interviews and senior management questions.
- 💰 **Team:** Reduce AWS costs by properly terminating instances and managing credit card information.
- 🛠 **Lawrence:** Consider switching from Splunk Enterprise version 9.3.0 to 9.1.6 to resolve monitoring console issues.
- 📖 **Becky-Elithia:** Complete last week's assignment after receiving the video tutorial.
- 🌐 **Shakibu:** Reestablish AWS environment after applying for credits.

---

## 🚀 **Summary**

### ⚙️ **EC2 Windows Instance Connection Issues**
Charles addressed technical issues related to accessing EC2 Windows instances due to a password change. He demonstrated how to connect using the remote desktop file and decryption key. After encountering a CPU limit error when starting an instance, Bernard and Joanan suggested turning off other instances or using a different availability zone.

---

### 🏢 **Multi-Site Environment and Disaster Recovery**
Charles discussed implementing a multi-site Splunk environment, involving two or more clusters connected for data redundancy. He highlighted the importance of disaster recovery, explaining how data from one site can be accessed from the other in case of failure. He also covered the role of the manager node and explained site replication factors.

---

### 📊 **Replication Factor Calculation**
Charles explained how to calculate replication factors to distribute data copies across multiple sites. The formula considers the original site and other sites, with the original site maintaining two copies. The search factor follows a similar calculation but must be equal to or lower than the replication factor.

---

### 🔄 **Converting Single-Site to Multi-Site**
Charles described the process of converting a single-site Splunk environment to a multi-site setup. While existing data remains single-site, new data will replicate across sites. The manager node's settings for replication and search factors must be configured correctly, ensuring replication factors match the number of indexers per site.

---

### 🛠 **Configuring Multi-Site Deployment**
Steps to configure a multi-site deployment:
1. Enable maintenance mode on the manager node.
2. Configure existing indexers as Site 1 and new indexers as Site 2.
3. Run necessary commands to complete the configuration.
4. Ensure the correct manager node IP and replication port are set.
5. Disable maintenance mode once configuration is done.

Charles expects the configuration to take about 15-20 minutes and requests a completed setup within 30-45 minutes.

---

### 💰 **Cloud Credit Offer and Account Management**
Charles encouraged the team to apply for a $1000 cloud credit offer to offset AWS costs. He addressed cloud resource management challenges and suggested managing accounts efficiently to avoid unexpected expenses. For those facing version compatibility issues, he recommended downgrading to Splunk Enterprise 9.1.6.

---

### 🎓 **Importance of Course and Graduation**
Charles emphasized reading and understanding course materials, noting that graduation is approaching. He reminded the team to put in their best effort to prepare for upcoming interviews. Sharing his personal journey, Charles encouraged the team to maximize their learning opportunities and be proactive in their career growth.

🚀 **Stay focused and keep pushing forward!**


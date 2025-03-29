# ✔️ Steps to Increase EBS Volume of an EC2 Instance

## Step 1: Go to EC2 Console

🔹 **Navigate to EC2** → **Volumes**

🔹 **Find the volume** attached to your indexer (e.g., `/dev/xvda`)

🔹 **Right-click** → **Modify Volume**

---

## Step 2: Set New Size

🔹 Enter a **larger size** like **50 GB** or **100 GB** (up to you)

🔹 Click **Modify** → **Confirm**

---

## Step 3: Expand Partition Inside the Instance (VERY IMPORTANT)

After modifying the EBS volume, go back to the instance and run:

```bash
# Check disk name (usually xvda)
lsblk

# Grow the partition
sudo growpart /dev/xvda 1

# Resize filesystem
sudo resize2fs /dev/xvda1

# Check disk again
df -h
```

✅ **You will now see your disk as 50GB or more**, and Splunk will exit detention automatically after restart or timeout.

---

## ✅ Notes:

✔️ **Your data will not be lost.**

✔️ **You do not need to stop the EC2 instance.**

✔️ **You do not need to change instance type** unless you want more CPU/RAM.

✔️ **This is 100% safe** if you only resize EBS. 🚀


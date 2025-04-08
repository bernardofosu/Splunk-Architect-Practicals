from pathlib import Path

markdown_content = """
# Splunk Frozen Data Archiving to S3

This document contains everything needed to automate the process of archiving frozen Splunk index buckets to Amazon S3.

---

## 🧩 `install_and_archive_to_s3.sh`

```bash
#!/bin/bash

### ✅ CONFIGURATION ###
S3_BUCKET="s3://splunk-archive"
FROZEN_DIR="/opt/splunk/var/lib/splunk"  # Adjust if your frozen path is custom
AWS_REGION="us-east-1"
INDEX_LIST=("main" "_internal")  # Add your index names here

### 🔧 1. INSTALL AWS CLI IF NOT INSTALLED ###
if ! command -v aws &>/dev/null; then
  echo "[INFO] AWS CLI not found. Installing..."
  if [ -f /etc/debian_version ]; then
    sudo apt-get update && sudo apt-get install -y awscli
  elif [ -f /etc/redhat-release ]; then
    sudo yum install -y awscli
  else
    echo "[ERROR] Unsupported OS. Please install AWS CLI manually."
    exit 1
  fi
fi

### 🔐 2. SET AWS CREDENTIALS (optional for on-prem, skip if using IAM roles) ###
if [ ! -f ~/.aws/credentials ]; then
  echo "[INFO] AWS credentials not found. Creating..."
  mkdir -p ~/.aws
  cat > ~/.aws/credentials <<EOF
[default]
aws_access_key_id = YOUR_ACCESS_KEY
aws_secret_access_key = YOUR_SECRET_KEY
EOF

  cat > ~/.aws/config <<EOF
[default]
region = $AWS_REGION
output = json
EOF
  echo "[WARN] Replace placeholder credentials in ~/.aws/credentials!"
fi

### 📦 3. ARCHIVE FROZEN BUCKETS TO S3 ###
HOSTNAME=$(hostname -s)
for INDEX in "${INDEX_LIST[@]}"; do
  INDEX_FROZEN_PATH="$FROZEN_DIR/$INDEX/frozendb"
  
  if [ ! -d "$INDEX_FROZEN_PATH" ]; then
    echo "[WARN] No frozen path for index: $INDEX"
    continue
  fi

  echo "[INFO] Archiving frozen buckets for index: $INDEX"

  for BUCKET in "$INDEX_FROZEN_PATH"/*; do
    [ -d "$BUCKET" ] || continue  # Skip non-dirs
    BUCKET_NAME=$(basename "$BUCKET")

    DEST_S3="$S3_BUCKET/$INDEX/$HOSTNAME/$BUCKET_NAME"

    echo "[INFO] Uploading $BUCKET to $DEST_S3"
    aws s3 cp "$BUCKET" "$DEST_S3" --recursive

    if [ $? -eq 0 ]; then
      echo "[INFO] Successfully uploaded. Deleting local bucket: $BUCKET"
      rm -rf "$BUCKET"
    else
      echo "[ERROR] Failed to upload $BUCKET to S3"
    fi
  done
done

### 🐧 4. DONE!
echo "[✅] All available frozen buckets archived and cleaned from $HOSTNAME"
```


📝 Usage

    Save as /opt/splunk/scripts/install_and_archive_to_s3.sh

    Make it executable:

Always show details

chmod +x /opt/splunk/scripts/install_and_archive_to_s3.sh

    Run manually or via cron:

Always show details

crontab -e
# Archive daily at 2am
0 2 * * * /opt/splunk/scripts/install_and_archive_to_s3.sh >> /var/log/splunk_s3_archive.log 2>&1

🔧 Optional: Integrate with Splunk config

Add to indexes.conf:

Always show details

[main]
coldToFrozenScript = /opt/splunk/scripts/install_and_archive_to_s3.sh

⚠️ IMPORTANT

    Update the AWS credentials in the script if you're not using IAM roles

    Add any other indexes you want to INDEX_LIST

    Test it first with echo or --dryrun if needed

✅ Alternatives

    Add KMS encryption support

    Upload with pre-signed URLs

    Configure Glacier lifecycle rules

Want help setting any of that up? Just ask! """
Save to markdown file

output_path = Path("/mnt/data/splunk_s3_archive_setup.md") output_path.write_text(markdown_content)

output_path.name

Always show details

Result

'splunk_s3_archive_setup.md'
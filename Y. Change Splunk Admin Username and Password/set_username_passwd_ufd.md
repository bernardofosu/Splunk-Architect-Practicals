Splunk Universal Forwarder (UF) does not have a Web UI, you need to manually set up an admin user using the CLI. Here’s how:
1️⃣ Set Up an Admin User for the Forwarder

Run the following command on the forwarder:

sudo /opt/splunkforwarder/bin/splunk enable boot-start -user splunk

Then, set up a user by creating a password file:

sudo touch /opt/splunkforwarder/etc/system/local/user-seed.conf
sudo chmod 600 /opt/splunkforwarder/etc/system/local/user-seed.conf

Now, edit the file:

sudo nano /opt/splunkforwarder/etc/system/local/user-seed.conf

Add the following lines:
```ini
[user_info]
USERNAME = admin
PASSWORD = YourSecurePassword
```

Save and exit (Ctrl+X → Y → Enter).
2️⃣ Restart the Forwarder

Apply the changes by restarting the Splunk Forwarder:

sudo /opt/splunkforwarder/bin/splunk restart

Now, you can authenticate using:

/opt/splunkforwarder/bin/splunk list forward-server

It will prompt for a username/password. Use admin and the password you set.
3️⃣ Alternative: Disable Authentication

If you don’t want to set up a user, you can disable authentication on the forwarder by modifying server.conf:

sudo nano /opt/splunkforwarder/etc/system/local/server.conf

Add:

[general]
disableDefaultPort = true

[authentication]
authType = Splunk

Restart the forwarder:

sudo /opt/splunkforwarder/bin/splunk restart

Now, authentication should no longer be required.

After doing this, try:

/opt/splunkforwarder/bin/splunk list forward-server
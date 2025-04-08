<powershell>
# ----------------------------------------
# EC2 Windows User Data - Install Splunk Universal Forwarder
# ----------------------------------------

# Configuration
$downloadUrl = "https://download.splunk.com/products/universalforwarder/releases/9.1.6/windows/splunkforwarder-9.1.6-a28f08fac354-x64-release.msi"
$installerPath = "$env:TEMP\splunkforwarder.msi"
$installDir = "C:\Program Files\SplunkUniversalForwarder"
$splunkUser = "splunkfwd"
$splunkPass = "ChangeMe123!"  # Replace or randomize if needed

# Step 1: Download Splunk UF Installer
Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath

# Step 2: Install silently
Start-Process msiexec.exe -ArgumentList "/i `"$installerPath`" AGREETOLICENSE=Yes /quiet INSTALLDIR=`"$installDir`"" -Wait

# Step 3: Create local user to run Splunk
$securePassword = ConvertTo-SecureString $splunkPass -AsPlainText -Force
New-LocalUser -Name $splunkUser -Password $securePassword -NoPasswordExpiration -UserMayNotChangePassword
Add-LocalGroupMember -Group "Administrators" -Member $splunkUser

# Step 4: Enable boot-start with credentials
& "$installDir\bin\splunk.exe" enable boot-start -user $splunkUser -password $splunkPass --accept-license --answer-yes --no-prompt

# Step 5: Apply minimal SSL config
$serverConf = @"
[sslConfig]
sslVersions = tls1.2
"@
$confPath = Join-Path "$installDir\etc\system\local" "server.conf"
$serverConf | Out-File -FilePath $confPath -Encoding UTF8

# Step 6: Start Splunk
Start-Process "$installDir\bin\splunk.exe" -ArgumentList "start" -Wait

# Step 7: Optional log message
"Splunk Universal Forwarder setup completed at $(Get-Date)" | Out-File -FilePath "C:\splunk-uf-install.log" -Append
</powershell>

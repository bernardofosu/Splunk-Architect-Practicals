✅ SPLUNK CLOUD MIGRATION CHECKLIST
🔹 1. Pre-Migration Planning

Identify all existing on-prem Splunk components (Search Head, Indexers, DS, HF, UF, etc.)

Audit apps and add-ons in use (check compatibility with Splunk Cloud)

Confirm Splunk Cloud subscription type (Victoria or Classic stack)

Estimate daily ingest volume and retention needs

Identify critical dashboards, saved searches, alerts, scheduled reports

Confirm supported authentication (SAML, LDAP, etc.)

Plan user roles and access controls in Splunk Cloud

Determine data sources and logging endpoints (files, APIs, cloud logs)

    Review compliance/security requirements (HIPAA, FedRAMP, etc.)

🔹 2. Infrastructure Setup (Splunk Cloud Environment)

Provision Splunk Cloud environment via Splunk support or sales engineer

Configure SSO or SAML integration

Set up user accounts and roles in Splunk Cloud

Request needed indexes to be created in Splunk Cloud

Enable HEC (HTTP Event Collector) if needed

    Open firewall for outbound traffic to Splunk Cloud ingestion endpoint (e.g., 9997, 443)

🔹 3. Forwarder Preparation (UF / HF)

Upgrade forwarders to a supported version

Update outputs.conf to point to Splunk Cloud ingestion endpoint

Apply appropriate TLS certificates (provided by Splunk)

Validate SSL connection to Splunk Cloud

Configure inputs.conf for desired data sources

    Use Deployment Server to manage forwarders (if already in use)

🔹 4. App and Configuration Migration

Package approved apps/add-ons for Splunk Cloud (as .spl or .tgz)

Submit apps to Splunk for vetting (Splunkbase or private)

Migrate saved searches, alerts, macros, lookup tables

Rebuild unsupported features using Cloud-safe alternatives

    Reconfigure indexes if necessary (Splunk Support required)

🔹 5. Data Onboarding

Reconfigure Heavy Forwarders or log shippers to send to Splunk Cloud

Onboard cloud-native data sources (AWS, GCP, Azure, O365, etc.)

Validate index routing (ensure data is going to correct index)

Tag and categorize source types

    Normalize data with CIM (Common Information Model) as needed

🔹 6. Validation and Testing

Validate forwarder connectivity and ingestion

Confirm search functionality and data availability

Test critical dashboards, alerts, and reports

Perform role-based access validation

    Confirm app functionality and performance

🔹 7. Cutover and Decommissioning

Finalize data forwarding to Splunk Cloud

Update documentation and runbooks

Notify users of new access URLs and authentication

Decommission unused on-prem Splunk infrastructure (indexers, SH, LM)

    Retain Deployment Server (DS) and HF/UF infrastructure

🔹 8. Post-Migration

Monitor ingestion, indexing latency, and license usage

Tune searches and dashboards for cloud performance

Set up alerting and health checks in Monitoring Console (Cloud version)

Set up scheduled backups for lookups, saved searches, knowledge objects

Establish a support relationship with Splunk Cloud Support (raise cases as needed)
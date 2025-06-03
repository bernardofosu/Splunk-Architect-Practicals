# 📘 What is an eventtype in Splunk?

An eventtype in Splunk is a saved search or search pattern that is given a name and optionally a tag. Once defined, you can reuse the eventtype as a label to identify and categorize similar events across multiple searches, dashboards, and alerts.

## 🔹 Why Use Eventtypes?

- To group similar events (e.g., all failed logins, all web access errors)
- To tag events for use in dashboards or security correlation
- To standardize searches across teams
- Required by Common Information Model (CIM) and Enterprise Security for normalization

---

# 🏗️ How to Create an Eventtype

You can create an eventtype in two ways:

## ✅ Method 1: From the Splunk Web UI

- Run a search in the Search & Reporting app  
  Example:
  ```spl
  sourcetype=access_combined status=404
  ```
- Click **Save As > Event Type**
- Give your eventtype:
  - **Name** (e.g., `web_404_errors`)
  - **(Optional) Tag(s)** (e.g., `web`, `error`)
  - **Permissions** (Private or Shared)
  - Click **Save**

## ✅ Method 2: Using eventtypes.conf File (Advanced)

Add to `$SPLUNK_HOME/etc/apps/<your_app>/local/eventtypes.conf`:

```ini
[web_404_errors]
search = sourcetype=access_combined status=404
tags = web error
```

---

# 🧪 How to Use an Eventtype in a Search

You can call the eventtype by its name like this:

```spl
eventtype=web_404_errors
```

You can also combine it:

```spl
eventtype=web_404_errors | stats count by uri
```

---

# 📎 Notes:

- Eventtypes are resolved at search time.
- You can view/edit all eventtypes in **Settings > Event types**.
- Tags can be mapped in `tags.conf` to enable faster threat correlation or categorization.

---

# ✅ Steps to Create an Eventtype via Settings

You can directly create an eventtype from the Splunk UI without running a search first:

- Go to **Settings > Event types**
- Click **New Event Type**
- Fill out the form:
  - **Name:** Give a unique name (e.g., `failed_logins`)
  - **Search string:** Enter your SPL (e.g., `sourcetype=linux_secure "Failed password"`)
  - **(Optional) Tags:** Add tags like `authentication`, `failure`
  - **App context** and **permissions**
- Click **Save**

---

# 🔍 What is a Saved Search in Splunk?

A saved search in Splunk is a predefined SPL query that you save for later use. It can be scheduled to run automatically and used for:

- Dashboards
- Alerts
- Reports
- Scheduled data summaries (summary indexing)
- Reuse in other searches (e.g., macros, eventtypes)

## 📌 Key Features of Saved Searches:

- **Name:** A unique identifier
- **SPL query:** The logic to run
- **Schedule (optional):** Automate the search
- **Alerting options:** Trigger notifications or actions
- **Permissions:** Private or shared

## ✅ How to Save a Search in Splunk UI:

- Run your SPL query in the Search app
- Click **Save As** (top-right)
- Choose:
  - **Alert:** To trigger actions
  - **Report:** For scheduled data/reporting
- Fill in:
  - **Title**
  - **Description**
  - **Permissions**
  - **Schedule** (optional)
  - **Trigger conditions** (for alerts)
- Click **Save**

### 🧠 Example:

Search:

```spl
index=syslog sourcetype=linux_secure "Failed password"
```

Save it as:

- A **report** to review daily
- An **alert** to notify if more than 10 failures in 5 minutes

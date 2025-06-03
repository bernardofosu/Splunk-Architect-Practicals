# 📘 1. What is a Data Model in Splunk?

A data model is a structured, hierarchical mapping of indexed data that provides a schema-on-top of unstructured data.

It enables faster searching and powers Pivot reports and accelerated dashboards.

Typically used in Splunk Enterprise Security, Pivot Tool, and by users who prefer GUI-based reports over SPL.

**Key Concepts:**

- **Root Event Dataset:** Defines raw log events.
- **Root Search Dataset:** Based on a saved search.
- **Child Dataset:** Refines or extends a parent dataset with constraints or calculated fields.

---

# 📐 2. Design Considerations When Creating a Data Model

When designing a data model, consider the following:

- **Naming:** Use intuitive names for data models and fields.
- **Field Normalization:** Align fields with CIM (Common Information Model) for compatibility with apps like Splunk ES.
- **Reusability:** Structure data models to allow for multiple child datasets (e.g., Web > Apache, Nginx).
- **Performance:** Keep data models lean; avoid unnecessary fields and lookups.
- **Acceleration Requirements:** Only accelerate if the model is frequently queried.

---

# 🏗️ 3. How to Create a Data Model in Splunk

### 🔹 Via Splunk Web:

- Navigate to **Settings > Data Models**.
- Click **Create New Data Model**.
- Define:
  - Title
  - App context
  - Permissions

### 🔹 Add Datasets:

- **Root Dataset:**
  - Type: Event or Search
  - Constraints: base search like `sourcetype=access_combined`
- **Child Datasets:**
  - Add fields, calculations, or lookups
  - Apply constraints (e.g., `status=500`)

---

# 🧭 4. "pivot" and "datamodel" SPL Commands

- **pivot:**

  Used to generate tabular data from a data model without writing SPL.

  **Syntax:**


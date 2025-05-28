
# 🔍 Splunk Parsing & Data Masking Guide

---

## 1️⃣ What is the main key that Splunk uses to parse data?

🔑 **Splunk primarily uses the `sourcetype` to determine how to parse data.**

📦 The `sourcetype` acts as a key that links your data to parsing rules defined in `props.conf` (and sometimes `transforms.conf`).

❌ Without a `sourcetype`, Splunk wouldn’t know which parsing or extraction rules to apply.

---

## 2️⃣ Are Splunk sourcetypes built-in or custom?

✅ **Both!**

- 🧰 Splunk provides many **built-in sourcetypes** for common log types and data sources.
- 🧑‍🔧 You can also create **custom sourcetypes** for your unique or proprietary data formats.

### 🔎 Summary

| Question                            | Answer                                                    |
|-------------------------------------|------------------------------------------------------------|
| What does Splunk use to parse data? | The `sourcetype`, which links data to rules in props.conf. |
| Are sourcetypes built-in or custom? | Splunk has both built-in and custom sourcetypes.           |

---

## 🔐 Example of a log with sensitive data

```
2025-05-27 10:15:42,123 INFO User login: user=john.doe@example.com credit_card=4111-1111-1111-1111 amount=100.00
```

### ✅ Why hash or mask?
- To protect sensitive info like emails or credit card numbers.
- For compliance with **GDPR**, **PCI-DSS**, **HIPAA**.

### 🔧 Example of hashing using `transforms.conf`

```ini
[hash_credit_card]
REGEX = credit_card=(\d{4}-\d{4}-\d{4}-\d{4})
FORMAT = credit_card::hash::$1
HASHED = true
```

In `props.conf`:

```ini
[your_sourcetype]
TRANSFORMS-hash_cc = hash_credit_card
```

Result:
```
credit_card=HASHEDVALUE
```

---

## 🛡️ Example for hiding some values with `XXX`

### ✅ Log line:
```
credit_card=4111-1111-1111-1111
```

### 👇 Goal:
Mask as `credit_card=XXX-XXX-XXX-XXXX`

### `transforms.conf`:

```ini
[mask_credit_card]
REGEX = (credit_card=)(\d{4}-\d{4}-\d{4}-\d{4})
FORMAT = $1XXX-XXX-XXX-XXXX
```

### `props.conf`:

```ini
[your_sourcetype]
TRANSFORMS-mask_cc = mask_credit_card
```

---

## ✂️ Partial Masking – Keep Last 4 Digits

### Original:

```
credit_card=4111-1111-1111-1111
```

### Masked:

```
credit_card=XXX-XXX-XXX-1111
```

### `transforms.conf`:

```ini
[partial_mask_credit_card]
REGEX = (credit_card=)\d{4}-\d{4}-\d{4}-(\d{4})
FORMAT = ${1}XXX-XXX-XXX-${2}
```

### `props.conf`:

```ini
[your_sourcetype]
TRANSFORMS-partial_mask_cc = partial_mask_credit_card
```

---

## 💡 Explanation: `${1}`, `${2}`

- `${1}` → first captured group (e.g. `credit_card=`)
- `${2}` → last 4 digits

Regex:

```
(credit_card=)\d{4}-\d{4}-\d{4}-(\d{4})
```

Final Format:
```
credit_card=XXX-XXX-XXX-1111
```

---

## 🔍 Capture All 4 Groups Separately

### Regex:

```regex
(credit_card=)(\d{4})-(\d{4})-(\d{4})-(\d{4})
```

### Groups:
- `${1}` = credit_card=
- `${2}` = first 4 digits
- `${3}` = second 4 digits
- `${4}` = third 4 digits
- `${5}` = last 4 digits

### Example Mask Format (only show last 4):

```ini
FORMAT = ${1}XXX-XXX-XXX-${5}
```

### Final Output:

```
credit_card=XXX-XXX-XXX-1111
```

Or show 1st and last:

```ini
FORMAT = ${1}${2}-XXX-XXX-${5}
```

➡️ Result:

```
credit_card=4111-XXX-XXX-1111
```

# UCPM Embedded Collection Points  
**Creation, Embedding & Contribution Guide**

This document provides an **end-to-end guide** for working with **UCPM Embedded Collection Points**.

By following this guide, you will be able to:
1. Create an Embedded Collection Point in OneTrust  
2. Embed it in a standalone HTML page  
3. Add it to this repository so it appears in the shared Collection Points library  
4. Use Copilot to generate new embedded Collection Point demos consistently  

---

## Table of Contents

- Overview
- What is a UCPM Embedded Collection Point?
- Part 1: How to Create a UCPM Embedded Collection Point
  - Step 1: Create the Embedded Web Form in OneTrust
  - Step 2: Publish the Collection Point
  - Step 3: Understand Loading Methods
  - Step 4: Use Embedded Web Form Events
- Part 2: How to Add Your Collection Point to This Repository
  - Step 5: Create a Standalone HTML Demo
  - Step 6: Add a Description
  - Step 7: Commit and Publish
  - Step 8: View Your Collection Point in the Library
- Why GitHub and GitHub Pages?
- Using Copilot to Generate an Embedded Collection Point
- Best Practices & Notes

---

## Overview

This repository acts as a **shared library of UCPM Embedded Collection Point demos**.

Each demo:
- Is implemented as a **single HTML file**
- Embeds a OneTrust Embedded Web Form
- Can be opened directly in a browser
- Is automatically indexed and published via GitHub Pages

This makes the repository ideal for:
- Demos
- Enablement
- Proofs of concept
- Internal sharing and reuse

---

## What is a UCPM Embedded Collection Point?

A **UCPM Embedded Collection Point** is a web form that:
- Is created and configured inside **OneTrust Universal Consent & Preference Management**
- Is rendered on your own page using the **OneTrust Web Form JavaScript SDK**
- Sends consent and preference data directly to OneTrust

Unlike hosted forms, embedded Collection Points allow you to:
- Control page layout and styling
- Decide when the form loads
- React to form lifecycle events
- Embed the form into any custom experience

The form logic and data processing remain fully managed by OneTrust.

---

# Part 1: How to Create a UCPM Embedded Collection Point

## Step 1: Create the Embedded Web Form in OneTrust

1. Navigate to **Universal Consent & Preference Management**
2. Go to **Interfaces → Collection Points**
3. Click **Add New**
4. Select **OneTrust Embedded Web Form**
5. Complete required metadata (name, description, language)

Use the **Builder** tab to configure data elements, purposes, validation rules, and translations.

---

## Step 2: Publish the Collection Point

Publishing activates the Collection Point and generates integration scripts.

After publishing, open the **Integrations** tab to access **Test** and **Production** scripts.

---

## Step 3: Understand Loading Methods

### Instant Loading
The form loads automatically on page load.

### Manual Loading (Recommended)

```javascript
OneTrust.webform.InstallCP("COLLECTION_POINT_ID");
```

Manual loading provides full control over when the form is displayed.

---

## Step 4: Use Embedded Web Form Events

```javascript
window.addEventListener('OnetrustFormLoaded', (event) => {
  console.log('Form loaded', event.detail);
});

window.addEventListener('OneTrustWebFormSubmitted', (event) => {
  console.log('Form submitted', event.detail);
});
```

Events enable confirmation messages, redirects, and demo logging.

---

# Part 2: How to Add Your Collection Point to This Repository

## Step 5: Create a Standalone HTML Demo

- Single self-contained HTML file
- Include OneTrust integration script
- Reference a published Collection Point ID

Place the file in the `demo/` folder.

---

## Step 6: Add a Description

At the top of the HTML file:

```html
<!-- Description: Embedded UCPM web form with manual load and submission handling -->
```

---

## Step 7: Commit and Publish

1. Add file to `demo/`
2. Commit changes
3. Push to `main`

---

## Step 8: View Your Collection Point in the Library

Open:
https://alvarobarrosomato.github.io/UCPM-Library

Updates may take a couple of minutes to appear.

---

## Why GitHub and GitHub Pages?

- No infrastructure required
- Automatic updates on commit
- Live, shareable URLs
- Full version control

---

## Using Copilot to Generate an Embedded Collection Point

```text
Create a single, self-contained HTML file that embeds a OneTrust UCPM Embedded Web Form Collection Point.

Requirements:
- Include OneTrust SDK script
- Use manual InstallCP loading
- Listen for OnetrustFormLoaded and OneTrustWebFormSubmitted
- Log events to console
- Add top-level Description comment

Use placeholders for Collection Point ID and script URL.
```

---

## Best Practices & Notes

- Keep demos simple
- Prefer manual loading
- Always include descriptions
- Treat demos as examples, not production

---

Created and maintained by **Alvaro Barroso**  
Madrid, Españita 🇪🇸

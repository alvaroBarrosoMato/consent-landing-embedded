Below is **one single, self‑contained Markdown file** that includes **everything** we discussed:

*   What UCPM Embedded Collection Points are
*   How to **create** them in OneTrust
*   How to **embed** them using the SDK (methods & events)
*   How to **add/upload** them to this repository
*   Why GitHub + GitHub Pages are used
*   A **Copilot prompt** so anyone can generate their own embedded HTML demo

This file is ready to be saved as **`README.md`** or **`UCPM_EMBEDDED_COLLECTION_POINTS.md`** and committed as-is.

***

````markdown
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

This section explains how to create and configure the Embedded Web Form in OneTrust.

---

## Step 1: Create the Embedded Web Form in OneTrust

Embedded Collection Points are created **inside the OneTrust UI**, not in HTML.

From OneTrust:

1. Go to **Universal Consent & Preference Management**
2. Navigate to **Interfaces → Collection Points**
3. Click **Add New**
4. Select **OneTrust Embedded Web Form**
5. Complete the creation details:
   - Name
   - Description
   - Default language
   - Organization / responsible user (if applicable)

After creation, use the **Builder** tab to configure:
- Data elements (identifiers, attributes)
- Purposes and preferences
- Visibility rules
- Validation rules
- Branding and translations

At this stage, you define **what data is collected and under which conditions**.

---

## Step 2: Publish the Collection Point

Before embedding, the Collection Point must be **published**.

Publishing:
- Activates the Collection Point
- Makes the **Integrations** tab available
- Generates **Test** and **Production** integration scripts

After publishing, open the Collection Point and go to:
**Integrations → Integration Scripts**

You will use the provided script in your HTML page.

---

## Step 3: Understand Loading Methods

OneTrust Embedded Web Forms support two loading modes:

### Instant loading
- The form renders automatically when the page loads

### Manual loading (recommended)
- The form is loaded programmatically
- Gives you full control over when the form appears

Manual loading uses the `InstallCP` method:

```javascript
OneTrust.webform.InstallCP("COLLECTION_POINT_ID");
````

Manual loading is ideal for:

*   Demos
*   Embedded experiences
*   Pages with custom UI flows

***

## Step 4: Use Embedded Web Form Events

OneTrust exposes browser events that allow your page to react to form lifecycle actions.

Common events include:

### Form loaded

Triggered when the embedded web form is successfully loaded.

```javascript
window.addEventListener('OnetrustFormLoaded', (event) => {
  console.log('Form loaded', event.detail);
});
```

### Form submitted

Triggered when the form is submitted and a consent receipt is created.

```javascript
window.addEventListener('OneTrustWebFormSubmitted', (event) => {
  console.log('Form submitted', event.detail);
});
```

These events can be used to:

*   Show confirmation messages
*   Trigger redirects
*   Log demo behavior
*   Control surrounding UI elements

***

# Part 2: How to Add Your Collection Point to This Repository

Once your Collection Point exists and is published, you can add a demo to this repository.

***

## Step 5: Create a Standalone HTML Demo

Your demo **must be a single HTML file**.

Requirements:

*   Self-contained (HTML, CSS, JS in one file)
*   Includes the OneTrust integration script in the `<head>`
*   Uses Instant or Manual loading
*   References a published Collection Point ID

Place the file inside the **`demo/` folder**:

```text
demo/
└── ucpm-my-embedded-form.html
```

***

## Step 6: Add a Description

At the very top of your HTML file, add a description comment.

This description is automatically extracted and displayed in the Collection Points library.



***

## Step 7: Commit and Publish

To publish your demo:

1.  Add the HTML file to the `demo/` folder
2.  Commit the change
3.  Push to the `main` branch

No additional deployment steps are required.

***

## Step 8: View Your Collection Point in the Library

After committing, open the Collection Points index:

👉 **<https://alvarobarrosomato.github.io/consent-landing-embedded/index.html>**

From there you can:

*   Browse all Collection Points
*   Read their descriptions
*   Open each demo directly in the browser

⏱ **Note:**\
GitHub Pages may take a couple of minutes to rebuild and refresh the site after a commit.

***

## Why GitHub and GitHub Pages?

GitHub Pages is used because it:

*   Hosts static HTML with no infrastructure
*   Automatically updates on every commit
*   Provides live, shareable URLs
*   Keeps everything version-controlled
*   Scales easily as the library grows

This makes it the simplest and most reliable way to maintain a shared demo library.

***

## Using Copilot to Generate an Embedded Collection Point

You can use the following prompt with **Copilot** to generate a complete embedded Collection Point demo.

### Copilot Prompt

```text
Create a single, self-contained HTML file that embeds a OneTrust UCPM Embedded Web Form Collection Point.

Requirements:
- Include the OneTrust Embedded Web Form SDK script in the <head>
- Use the Manual load method (InstallCP) to load the Collection Point
- Add a container where the form will render
- Listen for these events:
  - OnetrustFormLoaded
  - OneTrustWebFormSubmitted
- Log event details to the console
- Include simple CSS to center and frame the form
- Add an HTML comment at the top starting with:
  <!-- Description: ... -->

Use placeholders for:
- Collection Point ID
- OneTrust script URL

Assume the Collection Point is already created and published in OneTrust.
```

This prompt allows anyone to generate a working embedded Collection Point demo aligned with OneTrust best practices.

***

## Best Practices & Notes

*   Keep demos **simple and focused**
*   Prefer **manual loading** for flexibility
*   Always include a clear description
*   Avoid unnecessary external dependencies
*   Treat demos as **examples**, not production deployments

***

Created and maintained by **Alvaro Barroso**\
Madrid, Españita 🇪🇸

```

---

If you want next, we can:
- Extract this into a **short README + deep‑dive guide**
- Add a **starter HTML template** in `/templates`
- Add **troubleshooting scenarios**
- Add **demo patterns** (banner-style, modal-style, full-page)

Just tell me how you want to evolve this library.
```

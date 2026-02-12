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
You are an expert web developer implementing a OneTrust UCPM Embedded Web Form Collection Point as a single-file demo page (one .html file with embedded CSS + JS). Your goal is to generate a reliable, copy/paste-ready HTML file that embeds a published OneTrust Embedded Web Form Collection Point.

IMPORTANT: Before generating the final HTML, you MUST do this:

STEP 0 — Validate inputs (fail-safe)
- If any of the required values are missing, ask me for them in a short checklist, then STOP.
- Only generate the HTML after all required values are provided.

REQUIRED VALUES (ask me for any missing):
1) COLLECTION_POINT_ID (the OneTrust Embedded Web Form collection point id)
2) ONE_TRUST_EMBED_SCRIPT (the “Integration Script” URL/snippet from the Collection Point → Integrations tab; specify whether it’s Test or Production)
3) LOAD_METHOD: Instant or Manual
4) (If Manual) TRIGGER_METHOD: “auto on page load” OR “button click” (choose one)
5) TARGET_CONTAINER_ID (the DOM element id where the web form should render)
6) BRANDING: Explain the look and feel of the website you want to achieve.
7) PREFILL_MODE: None OR Prefill via query parameters
8) (If Prefill) List of fields to prefill in this format:
   - FormFieldLabel1=Example Value
   - FormFieldLabel2=Example Value
   Note: these labels must match the “Form Field Label” configured in OneTrust for that field.
9) OPTIONAL: redirect behavior after submit (none / show success message / redirect URL)

WHERE TO FIND THE REQUIRED VALUES (explain briefly in your answer):
- COLLECTION_POINT_ID and ONE_TRUST_EMBED_SCRIPT: go to OneTrust UCPM → Interfaces → Collection Points → open the Embedded Web Form → Integrations tab. The Integrations tab is available after publishing and provides Test/Production scripts. Also, the integration settings indicate whether the form is set to Manual vs Instant load. (Source: OneTrust docs) 
- Manual loading uses InstallCP to force the form to load. (Source: OneTrust docs)

REFERENCES YOU MUST FOLLOW (do not invent APIs):
- Manual load: Use InstallCP to load the web form when load method is Manual.
- Events: Implement listeners for:
  - OnetrustFormLoaded (form successfully loaded)
  - OneTrustWebFormSubmitted (form submitted; consent receipt payload details available in event)
- Prefill (if enabled): Explain that prefilling is done by passing query parameters using the “Form Field Label” from OneTrust, and that values must be URL-encoded (e.g. “+” becomes “%2B”), and multiple fields are separated by “&”.

STEP 1 — Generate the single HTML file
Generate a single .html file with:
A) Top-of-file comment:
   <!-- Description: <one sentence describing what this demo does> -->

B) <head> includes:
   - Basic meta tags
   - The OneTrust Embedded Web Form SDK integration script (from Integrations tab). It must be included in the <head> as required.

C) <body> structure:
   - A clean, responsive layout with:
   - A completely self designed interface that interacts with CSS and JS to create an experience that replicates the use case that the user specified.
   - Make sure that you implement the TARGET_CONTAINER_ID

D) JavaScript behavior:
   1) Provide a single configuration object at the top of the script that includes:
      - collectionPointId
      - loadMethod
      - containerId
      - optionalRedirectUrl
      - prefillMode
   2) Implement Manual vs Instant:
      - If Instant: do not call InstallCP manually (assume it appears on page load).
      - If Manual: call InstallCP either on page load or on button click or at any other point following web design strategy.
   3) Add event listeners:
      - window.addEventListener('OnetrustFormLoaded', ...) -> update status UI + console.log details
      - window.addEventListener('OneTrustWebFormSubmitted', ...) -> show a success message + console.log details
   4) Add robust fail-safe checks:
      - If SDK/global objects aren’t available yet, show a clear error in the status UI and console.
      - Avoid duplicate InstallCP calls (idempotent guard).
   5) Prefill guidance:
      - If PREFILL_MODE is enabled: include a short helper that reads query parameters and prints which fields are present (for debugging).
      - IMPORTANT: Do NOT try to “set” fields by manipulating the DOM unless the docs explicitly provide a method. Prefill should rely on query parameters passed to the form URL and the OneTrust “Form Field Label” approach.

E) Responsiveness:
   - CSS must be responsive using modern layout primitives (flex/grid) and a mobile breakpoint. Use your best design capabilities to build the best interface posible visually with CSS and great visuals.
   - The layout must remain usable on phones (stacked sections, readable buttons, no horizontal scrolling).

STEP 2 — Output format constraints
- Output ONLY the final HTML file content (no extra commentary), once all required values are available.
- The HTML must be a single file containing CSS and JS inline.
- Use placeholders ONLY when I explicitly tell you a value is unknown.

NOW: If required values are missing, ask me for them in a checklist.
Otherwise, generate the HTML file.
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

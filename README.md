# UCPM Collection Points Library

This repository is a shared library of **UCPM Collection Point demos**, implemented as standalone HTML files.

Each Collection Point represents a self-contained consent or preference experience that can be easily reviewed, shared, and reused by internal teams or during customer demos.

---

## Table of Contents

- [What is this repository?](#what-is-this-repository)
- [How this repository works](#how-this-repository-works)
- [How to upload your Collection Point](#how-to-upload-your-collection-point)
  - [1. Create your Collection Site](#1-create-your-collection-site)
  - [2. Commit the file](#2-commit-the-file)
  - [3. Access the Collection Points library](#3-access-the-collection-points-library)
- [How to create a Collection Point](#how-to-create-a-collection-point)
- [Why GitHub and GitHub Pages?](#why-github-and-github-pages)
- [Contribution guidelines](#contribution-guidelines)

---

## What is this repository?

This repository contains a collection of **UCPM Collection Point demos**, each stored as a **single HTML file**.

The purpose of this repository is to:

- Maintain a **centralized library** of Collection Point demos
- Make it easy to **add, discover, and preview** Collection Sites
- Provide **live URLs** that can be shared with customers or internal teams
- Keep demos **versioned, traceable, and easy to update**

---

## How this repository works

This repository uses **GitHub Pages** to host static HTML files.

At a high level:

- Each Collection Point is a **single `.html` file**
- Files are stored in the repository and committed to `main`
- GitHub Pages automatically:
  - Rebuilds the site
  - Regenerates the index of Collection Points
  - Hosts each file as a live URL

No servers, deployments, or build pipelines are required.

---

## How to create your own UCPM Embedded Collection Point

This guide explains how to **create and embed a UCPM Embedded Web Form Collection Point** using OneTrust and host it as a standalone HTML demo in this repository.

An **Embedded Collection Point** is a web form created in OneTrust that is injected into your own HTML page using the OneTrust JavaScript SDK. The form is rendered and managed by OneTrust, while the surrounding page layout and behavior remain fully under your control. [1](https://developer.onetrust.com/onetrust/docs/embedded-web-forms-methods-and-events)

---

### Overview of the approach

At a high level, creating an embedded Collection Point involves:

1. Creating and configuring the Embedded Web Form in OneTrust
2. Publishing the Collection Point
3. Embedding the OneTrust integration script into a custom HTML page
4. (Optional) Controlling when and how the form loads using SDK methods and events

The resulting HTML file can be committed to this repository and previewed via GitHub Pages.

---

## Step 1: Create the Embedded Web Form in OneTrust

Embedded Collection Points are created and configured **inside the OneTrust application**, not directly in HTML.

From the OneTrust UI:

1. Go to **Universal Consent & Preference Management**
2. Navigate to **Interfaces → Collection Points**
3. Select **Add New**
4. Choose **OneTrust Embedded Web Form**
5. Complete the required metadata (name, description, language, etc.)
6. Use the **Builder** tab to configure:
   - Data elements
   - Purposes and preferences
   - Validation and visibility rules
   - Translations and branding

Once created, the Embedded Web Form sends consent data directly to OneTrust when submitted. [3](https://my-onetrust-com.proxy.uchicago.edu/s/article/UUID-dc3d2758-c221-f344-fef0-e51d7b394dca?topicId=0TO3q000000kKEGGA2)

---

## Step 2: Publish the Collection Point

Before it can be embedded, the Collection Point must be **published**.

Publishing makes the **Integration script** available and enables deployment options.

After publishing:

- The **Integrations** tab becomes available
- You can access **Test** and **Production** integration scripts
- The Collection Point can be loaded via:
  - Automatic deployment (via cookies script), or
  - Manual embedding (recommended for demos and custom pages)

[2](https://my.onetrust.com/s/article/UUID-1cb23a90-36a7-8215-d1b3-479f61970e1c?language=en_US)

---

## Step 3: Embed the Collection Point in an HTML page

Embedded Web Forms are integrated by including the **OneTrust Web Form SDK script** in your HTML page.

The script must be added to the `<head>` of the page, using the code provided in the **Integrations** tab of the Collection Point.

At minimum, your HTML page must:

- Include the OneTrust integration script
- Provide a container where the form will render
- Optionally control loading behavior using SDK methods

OneTrust supports two loading modes:

### Instant loading
The form renders automatically when the page loads.

### Manual loading
The form is loaded programmatically using the `InstallCP` method, allowing full control over when the form appears. This is often preferred for demos and embedded experiences. [1](https://developer.onetrust.com/onetrust/docs/embedded-web-forms-methods-and-events)

Example (manual loading concept):

```javascript
OneTrust.webform.InstallCP("COLLECTION_POINT_ID");

### 1. Create your Collection Site

- Your Collection Point **must be a single HTML file**
- The file should be fully self-contained:
  - HTML
  - CSS
  - JavaScript
- Place the file inside the **`demo/` folder**

Example structure:

```text
demo/
└── ucpm-basic-banner.html

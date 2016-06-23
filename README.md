Civi**REBUX**
=============

**RE**port  **BU**ilding module e**X**tension for
==============

<img src="https://upload.wikimedia.org/wikipedia/commons/5/5a/Civicrm_Logo.png" width="300">

This repository contains the design and implementation of a report building module extension for CiviCRM, built as a part of the **Google Summer of Code 2016** program. 

----------


This extension provides a new interface to CiviCRM Reports page, which is **much similar** to the most popular spreadsheet softwares, yet **very different** from them in terms of its **drag'n'drop UI** and extended functionality for **data exploration and analysis**. *Currently, I am working on supporting just CiviCRM Contribution data*.

Installation
------

- Download the repository and place it in the CiviCRM extensions dir of your Wordpress site.
- From your CiviCRM dashboard, goto `Administer -> System Settings -> Manage Extensions (for CiviCRM < 4.7)` or,  `Administer -> System Settings -> Extensions (for CiviCRM >= 4.7)`
- Install **CiviREBUX** (org.civicrm.civirebux) extension.

Usage
------

After installing the new page is available from the menu bar in your CiviCRM dashboard: `Reports -> CiviREBUX`

What's New?
------

I am using [Pivottable.js](http://nicolas.kruchten.com/pivottable) along with [Civix](https://github.com/totten/civix) to build CiviREBUX. Here is a brief description of what these are - 

>  PivotTable.js

PivotTable.js implements a drag'n'drop UI to pivot tables, similar to most of the popular spreadsheet softwares. User can drag attributes into/out of the row/column areas, and specify rendering, aggregation and filtering options. 

Pivottable.js enables data exploration and analysis by turning the CiviCRM Contribution data into a summary table and then allows the user to manipulate this summary table and render it graphically.

> Civix

Civix is a command-line tool for building CiviCRM extensions.

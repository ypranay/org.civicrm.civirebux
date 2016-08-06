Civi**REBUX**
=============

**RE**port  **BU**ilding module e**X**tension for
==============

<img src="https://upload.wikimedia.org/wikipedia/commons/5/5a/Civicrm_Logo.png" width="300">

This repository contains the implementation of a report building module extension for CiviCRM LLC, built as a part of the **Google Summer of Code 2016** program. Please read the [wiki](https://github.com/ypranay/org.civicrm.civirebux/wiki) for detailed information about CiviREBUX.


![](https://img.shields.io/badge/codecov-unknown-lightgrey.svg)
[![HitCount](https://hitt.herokuapp.com/{username||org}/{project-name}.svg)](https://github.com/ypranay/org.civicrm.civirebux)

----------

**CiviREBUX** is a drag-n-drop report builder interface for making CiviCRM-style reports. It supports multiple data transformation functionalities like pivoting, filtering, sorting and can render the results both in a tabular format as well as graphically in real-time. It can be referred to as a spreadsheet software running seamlessly on your browser.   

*Currently supports CiviCRM Contribution and Membership data only.*

Installation
------

- Download the repository and place it in the CiviCRM extensions dir of your Wordpress site.
- From your CiviCRM dashboard, goto `Administer -> System Settings -> Manage Extensions (for CiviCRM < 4.7)` or,  `Administer -> System Settings -> Extensions (for CiviCRM >= 4.7)`
- Install **CiviREBUX** (org.civicrm.civirebux) extension.

Usage
------

After installing the new page is available from the menu bar in your CiviCRM dashboard: `Reports -> CiviREBUX`


New Features
-------------

* Drag-n-Drop functionality - 
  Add/Remove attributes (rows and columns in your report) into/out of the scope by simply dragging them into/out of the rows (left) and column (top) space in the UI.

* Rendering -
  Selecting how the data will be displayed - tabular (default), bar charts, row and column heatmaps, scatter plots et cetera.

* Exporting into TSV/CSV - 
  Exporting the report template into CSV and TSV formats (available for download).

* Aggregators - 
  Defining what will be displayed in the cells - unique count, sum, average, trimmed mean, minimum, maximum et cetera along with dynamic aggregators viz. Monthly, Daily and Yearly.

* Filtering - 
  Filtering and searching to locate specific records to be included in the report.

* Saving and Loading Report Templates:
  Saving a report template which can be loaded later. Added support for overwriting an already saved report template as well. 

* Adding Report to Navigation Menu:
  Adding the most frequently used report template directly into the CiviCRM Navigation Menu under Reports >> CiviREBUX.

* Viewing Saved Report Templates:
  Loading a report template by simply clicking the row corresponding to that template from a tabular list of previously saved report templates.

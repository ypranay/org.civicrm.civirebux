<div id="banner">
<strong>CiviREBUX</strong> is similar to the modern presentation softwares, yet different! Built using Pivottable.js, <strong>CiviREBUX</strong> comes equipped with a drag-n-drop interface which also supports multiple data transformation functionalities like pivoting, filtering, sorting et cetera. <a href="#" class="show">Expand</a> to discover its many use-cases!
<div id="hidden-banner">
<ul>
<li><strong>Adding or Removing Attributes:</strong></li>
To add an attribute into the pivot table, simply drag and drop the attribute from the pooled list just above the pivot table.
<br>To remove an attribute from the pivot table, simply drag and drop the attribute out of the table, back into the pooled list. 
<br><br>
<li><strong>Using Renderers:</strong></li>
The renderer defines you will actually see. The topmost drop-down contains several options for rendering - table (default), table barchart, heatmaps, scatter plots, export to TSV et cetera. Choose the one which you would like to see in the report.
<br><br>
<li><strong>Using Aggregators:</strong></li>
The aggregators define what will end up in the cells of the pivot table. In a nutshell, aggregators are functions which gets called once per cell in the pivot table. The other drop-down contains the list of aggregators viz. count (default), sum, average, minimum, maximum, sum over sum. 
<br><br>
<li><strong>Filtering:</strong></li>
See the tiny down-arrow next to each of the attributes? Click it to see the distinct values of that attribute and select the ones which you want to filter out. Also feel free to type in the search string in the search bar that appears when you click the said down-arrow!
<br><br>
<li><strong>Using Custom Attributes:</strong></li>
We have added support for a few custom attributes like Month-wise, Date-wise, Day-wise and Year-wise contribution receipts which you can include in your report as well.
<br><br>
<li><strong>Ordering:</strong></li>
You can also change the order in which the attributes appear in the report by dragging and dropping them at desired positions!   
</ul>
<div id="instr"><em>...click elsewhere to automatically minimize...</em></div>
</div>
</div>
<br>
<form id="whichDataType" method="post">
Select which CiviCRM data do you want to use? (<em>default: Contribution</em>) 
<select name="CRMData" id="CRMData">
{html_options options=$options_array selected=$CRMDataType}
</select>
<input type="submit" value="Go"/>
</form>
<br><br>
<h3>{$CRMDataType} Summary Pivot Table</h3>
<div id="reportPivotTable"></div>
{literal}
<script type="text/javascript">
    CRM.$(function () {
        var data = {/literal}{$contribData}{literal};
        var derivers = jQuery.pivotUtilities.derivers;
	var sortAs = jQuery.pivotUtilities.sortAs;
	jQuery("#reportPivotTable").pivotUI(data, {
            rendererName: "Table",
            renderers: CRM.$.extend(
                jQuery.pivotUtilities.renderers, 
		jQuery.pivotUtilities.c3_renderers,
                jQuery.pivotUtilities.export_renderers
            ),
            vals: ["Total"],
            rows: ["Sort Name","Date Received","Total Amount"],
            cols: [],
            aggregatorName: "Count",
	    derivedAttributes: {
		"Month-wise Receipts": derivers.dateFormat("Date Received", "%n"),
		"Date-wise Receipts": derivers.dateFormat("Date Received","%d"),
	    	"Year-wise Receipts": derivers.dateFormat("Date Received","%y"),
		"Day-wise Receipts": derivers.dateFormat("Date Received","%w")
	    },
	    sorters: function(attr) {
                if(attr == "Month-wise Receipts") {
                        return sortAs(["Jan","Feb","Mar","Apr", "May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]);
                }
                if(attr == "Day-wise Receipts") {
                        return sortAs(["Mon","Tue","Wed", "Thu","Fri","Sat","Sun"]);
                }
            },
	    autoSortUnusedAttrs: true,
            unusedAttrsVertical: false
        }, false);
    });
</script>
{/literal}

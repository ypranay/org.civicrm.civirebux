
<h3>Contribution Summary Pivot Table</h3>
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
		"Day-wise Receipts": derivers.dateFormat("Date Received","%d"),
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

<h3>Contribution Summary Pivot Table</h3>
<div id="reportPivotTable"></div>
{literal}
<script type="text/javascript">
    CRM.$(function () {
        var data = {/literal}{$contribData}{literal};
        var derivers = jQuery.pivotUtilities.derivers;
	jQuery("#reportPivotTable").pivotUI(data, {
            rendererName: "Table",
            renderers: CRM.$.extend(
                jQuery.pivotUtilities.renderers, 
		jQuery.pivotUtilities.c3_renderers,
                jQuery.pivotUtilities.export_renderers
            ),
            vals: ["Total"],
            rows: [],
            cols: [],
            aggregatorName: "Count",
	    derivedAttributes: {
		"Month-wise Receipts": derivers.dateFormat("Date Received", "%m-%n"),
		"Day-wise Receipts": derivers.dateFormat("Date Received","%d")
            },
            unusedAttrsVertical: false,
        }, false);
    });
</script>
{/literal}

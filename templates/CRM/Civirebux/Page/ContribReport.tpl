<h3>Contribution Summary Pivot Table</h3>
<div id="reportPivotTable"></div>
{literal}
<script type="text/javascript">
    CRM.$(function () {
        var data = {/literal}{$contribData}{literal};
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
            unusedAttrsVertical: false,
        }, false);
    });
</script>
{/literal}

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
<br>
<h3>{$CRMDataType} Summary Pivot Table</h3>
<div id="results"></div>
<div id="reportPivotTable"></div>
{literal}
<script type="text/javascript">
	
	/* Saves config json every time onRefresh() is called. Adds a field to indicate it was a user-initiated save or otherwise. Finds the last non-user initiated saved config and 		adds the new config json in the list. Otherwise, the list will keep on getting bigger with time without deleting older config */
	function saveCurrentConfig(jsonobj){
		var getConfigs = JSON.parse(localStorage.getItem('pivotTableConfigurations') || [];
		jsonobj['userFlag'] = false;
		delete getConfigs[getLastUnsavedConfiguration(getConfigs,getConfigs.length-1)];	
		getConfigs.push(jsonobj);
		localStorage.setItem('pivotTableConfigurations', JSON.stringify(getConfigs));
	}

	function getRows(){
		var e = document.getElementById("CRMData");
		var datatype = e.options[e.selectedIndex].value;
		if(datatype == 'Contribution'){
			rows = ['Display Name','Date Received', 'Total Amount'];
		}
		else{
			rows = ['ID','Contact ID','Member Since','Membership Name','Relationship Name'];
		}
		return rows;
	}
	function getDerivedAttributes(derivers){
                var e = document.getElementById("CRMData");
                var datatype = e.options[e.selectedIndex].value;
		if(datatype == 'Contribution'){
                        dict_functions = {
                                "Month-wise Receipts": derivers.dateFormat("Date Received", "%n"),
                                "Date-wise Receipts": derivers.dateFormat("Date Received","%d"),
                                "Year-wise Receipts": derivers.dateFormat("Date Received","%y"),
                                "Day-wise Receipts": derivers.dateFormat("Date Received","%w")
                        };
                }
                else{
                        dict_functions = {
                                "Month-wise New Members": derivers.dateFormat("Membership Start Date", "%n"),
                                "Date-wise New Members": derivers.dateFormat("Membership Start Date","%d"),
                                "Year-wise New Members": derivers.dateFormat("Membership Start Date","%y"),
                                "Day-wise New Members": derivers.dateFormat("Membership Start Date","%w")
                        };
                }
                return dict_functions;
        }
	CRM.$(function () {
        	var data = {/literal}{$pivotData}{literal};
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
            		rows: getRows(),
            		cols: [],
            		aggregatorName: "Count",
	    		derivedAttributes: getDerivedAttributes(derivers),
	    		sorters: function(attr) {
                		if(attr == "Month-wise Receipts" || attr == "Month-wise New Members") {
                        		return sortAs(["Jan","Feb","Mar","Apr", "May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]);
                		}
                		if(attr == "Day-wise Receipts" || attr == "Day-wise New Members") {
                        		return sortAs(["Mon","Tue","Wed", "Thu","Fri","Sat","Sun"]);
                		}
            		},
	    		autoSortUnusedAttrs: true,
           		unusedAttrsVertical: false,
                	onRefresh: function (config) {
                    		var config_copy = JSON.parse(JSON.stringify(config));
				delete config_copy["rendererOptions"];
                    		delete config_copy["localeStrings"];
				saveCurrentConfig(config_copy,false);
                	}
        	}, false);
    	});
</script>
{/literal}

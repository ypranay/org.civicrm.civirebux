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
<input type="button" value="Save" id="save" />
<input type="button" value="Load" id="load" />
<br><br>
<div id="saveDialog" style="display:none;">
<label for="saveReportAs">{ts}Save Report As{/ts}:</label>
<input id="saveReportAs" size="40">
</div>
<div id="loadDialog" style="display:none;">
<label for="loadDialogList">{ts}Select One of the Saved Reports:{/ts}</label><br>
<div id="loadDialogList" style="width: 50px;"> </div>
</div>
<div id="results"></div>
<div id="reportPivotTable"></div>
{literal}
<script type="text/javascript">
	var currConfig={};

	currConfig['vals'] = "Total";
	currConfig['rows'] = getRows();
	currConfig['cols'] = "";
	currConfig['rendererName'] = "Table";
	currConfig['aggregatorName'] = "Count";	

	function getTimeStamp() {
  		var now = new Date();
  		var currdate = [ now.getFullYear(), now.getMonth()+1, now.getDate()];
  		var time = [ now.getHours(), now.getMinutes(), now.getSeconds() ];
  		var suffix = ( time[0] < 12 ) ? "AM" : "PM";
  		time[0] = ( time[0] < 12 ) ? time[0] : time[0] - 12;
  		time[0] = time[0] || 12;
  		for ( var i = 1; i < 3; i++ ) {
    			if ( time[i] < 10 ) {
      				time[i] = "0" + time[i];
    			}
  		}
  		return currdate.join("-") + " " + time.join(":") + suffix;
	}

	var crmAjaxURL = CRM.url('civicrm/civirebux/ajax/save');
	
	cj("#save").click( function(){
		var currTimeStamp = getTimeStamp();
		cj("#saveReportAs").attr("placeholder","CiviREBUX Report "+currTimeStamp);
		cj("#saveDialog").dialog({
			width: 400,
			modal: true,	
			dialogClass: "no-close",
			title: "Save Report",
			buttons: {
				"OK": function(){
					var name = cj("#saveReportAs").val();
					if(name == ''){
						name = "CiviREBUX Report "+currTimeStamp;
					}
					jQuery.ajax({
						type: "POST",
						url: crmAjaxURL,
						data: 'name='+name+'&renderer='+currConfig['rendererName']+'&aggregator='+currConfig['aggregatorName']+'&vals='+currConfig['vals']+'&rows='+currConfig['rows']+'&cols='+currConfig['cols'],
					}).done(function (data){
						cj("#saveDialog").dialog("close");
						CRM.alert(ts('Configuration Saved!!'),'CiviREBUX: Success','success',{'expires':3000});
					}).fail(function (data){
						CRM.alert(ts('Error Saving!!'),'CiviREBUX: Error','error',{'expires':3000});
					});
				},
				"Cancel": function(){
					cj("#saveDialog").dialog("close");
					CRM.alert(ts('Configuration was not saved!!'),'CiviREBUX: Alert','alert',{'expires':1500});
					return;
				}
			}
		})});

	var crmLoadAllAjaxURL = CRM.url('civicrm/civirebux/ajax/loadAll');	
	var crmLoadAjaxURL = CRM.url('civicrm/civirebux/ajax/load');

	cj("#load").click( function(){
                cj("#loadDialog").dialog({
			width: 400,
			modal: true,
                        dialogClass: "no-close",
                        title: "Load Report",
                        open: function() {
				jQuery.ajax({
                                	type: "POST",
                                        url: crmLoadAllAjaxURL
                                }).done(function (data){
					var htmlstring = '<select id="listofreports">'
					for(var i=0; i < data.length; i++){
						htmlstring += '<option value="'+data[i].id+'">'+data[i].name+'</option>';
					}
					htmlstring += '</select>'
					cj("#loadDialogList").html(htmlstring);
                                }).fail(function (data){
                                        CRM.alert(ts('Error Loading!!'),'CiviREBUX: Error','error',{'expires':3000});
                                });
    			},
			buttons: {
                                "OK": function(){
					var sel = cj("#listofreports option:selected").val();
					jQuery.ajax({
                                                type: "POST",
                                                url: crmLoadAjaxURL,
                                                data: 'id='+sel,
                                        }).done(function (data){
                                                cj("#loadDialog").dialog("close");
						var reportData = {/literal}{$pivotData}{literal};
                				var derivers = jQuery.pivotUtilities.derivers;
                				var sortAs = jQuery.pivotUtilities.sortAs;
						jQuery("#reportPivotTable").pivotUI(reportData, {
                        				rendererName: data['renderer'],
                       					renderers: CRM.$.extend(
                                				jQuery.pivotUtilities.renderers,
                                				jQuery.pivotUtilities.c3_renderers,
                                				jQuery.pivotUtilities.export_renderers
                        				),
                        				vals: data['vals'].split(','),
                        				rows: data['rows'].split(','),
                        				cols: data['cols'].split(','),
                       					aggregatorName: data['aggregator'],
                        				derivedAttributes: getDerivedAttributes(derivers),
                        				sorters: function(attr) {
                               					if(attr == "Month-wise Receipts" || attr == "Month-wise New Members") {
                                       					return sortAs(["Jan","Feb","Mar","Apr", "May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]);
                               					}
                               					if(attr == "Day-wise Receipts" || attr == "Day-wise New Members") {
                                       					return sortAs(["Mon","Tue","Wed", "Thu","Fri","Sat","Sun"]);
                               					}
                       					},
                       					onRefresh: function(config) {
                               					var config_copy = JSON.parse(JSON.stringify(config));
                               					currConfig = {
                                       					"rows": config_copy["rows"],
                                       					"cols": config_copy["cols"],
                                       					"aggregatorName": config_copy["aggregatorName"],
                                       					"rendererName": config_copy["rendererName"],
                                       					"vals": config_copy["vals"]
                               					};
                       					},
                       					autoSortUnusedAttrs: true,
                       					unusedAttrsVertical: false
               					}, true);								
                                                CRM.alert(ts('Configuration Loaded!!'),'CiviREBUX: Success','success',{'expires':3000});
                                        }).fail(function (data){
                                        	cj("#loadDialog").dialog("close");
					        CRM.alert(ts('Error Loading!!'),'CiviREBUX: Error','error',{'expires':3000});
                                        });
                                },
                                "Cancel": function(){
					cj("#loadDialog").dialog("close");
                                        CRM.alert(ts('Configuration was not loaded!!'),'CiviREBUX: Alert','alert',{'expires':1500});
                                }
                        }
                })});	

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
			onRefresh: function(config) {
                    		var config_copy = JSON.parse(JSON.stringify(config));
                    		currConfig = {
					"rows": config_copy["rows"],
					"cols": config_copy["cols"],
					"aggregatorName": config_copy["aggregatorName"],
					"rendererName": config_copy["rendererName"],
					"vals": config_copy["vals"]
				};
			},
	    		autoSortUnusedAttrs: true,
           		unusedAttrsVertical: false
        	}, true);
    	});
</script>
{/literal}

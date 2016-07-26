{* FTUE Info text *}
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

{* For choosing amongst Membership and Contribution data *}
<form id="whichDataType" method="post">
Select which CiviCRM data do you want to use? (<em>default: Contribution</em>) 
<select name="CRMData" id="CRMData">
{html_options options=$options_array selected=$CRMDataType}
</select>
<input type="submit" value="Go"/>
</form>

<br>

{* Pivot Table Smarty Template *}
<h3>{$CRMDataType} Summary Pivot Table</h3>
<input type="button" value="Save" id="save" />
<input type="button" value="Load" id="load" />
<input type="button" value="Saved Reports" id="listOfSavedReports" />
<input type="button" value="< Back" id="goback" style="display:none;"/>
<input type="button" value="Add to Navigation" id="addToNav" />
<br><br>

{* jQuery Dialog for Saving Report Templates *}
<div id="saveDialog" style="display:none;">
<label for="saveReportAs">{ts}Save Report As{/ts}:</label>
<input id="saveReportAs" size="40">
</div>

{* jQuery Dialog for Loading saved Report Templates *}
<div id="loadDialog" style="display:none;">
<label for="loadDialogList">{ts}Select One of the Saved Reports:{/ts}</label><br>
<div id="loadDialogList" style="width: 50px;"> </div>
</div>

<div id="addToNavDialog" style="display:none;">
<label for="addToNavSaveReportAs">{ts}Save Report As{/ts}:</label>
<input id="addToNavSaveReportAs" size="40">
</div>

{* div containing Pivot table *}
<div id="results"></div>
<div id="reportPivotTable"></div>
{literal}
<script type="text/javascript">
	
	/*
	* Holds the current report configuration comprising of the rows, columns, renderer name, aggregator name and value of the pivot table.
	* Updated everytime onRefresh function is triggered, i.e. on any change in the pivot table viz. rows or col dragged into/out et cetera.
	* Default options for pivot table are set here.
	*/ 
	var currConfig={};
	currConfig['vals'] = [];
	currConfig['rows'] = getRows();
	currConfig['cols'] = [];
	currConfig['rendererName'] = "Table";
	currConfig['aggregatorName'] = "Count";	

	/*
	* Returns string-formatted current timestamp in 'YYYY-MM-DD HH:MM:SS AM/PM' style. Used for giving default names to report configurations while saving.
	* @param: void  
	*/
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

	// CiviCRM-style URL for directing Ajax calls while saving report configurations. Please refer to xml/Menu/civirebux.xml for more.
	var crmAjaxURL = CRM.url('civicrm/civirebux/ajax/save');
	
	// Trigger function on save button click
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
						data: 'name='+name+'&renderer='+currConfig['rendererName']+'&aggregator='+currConfig['aggregatorName']+'&vals='+currConfig['vals']+'&rows='+currConfig['rows']+'&cols='+currConfig['cols']+'&time='+currTimeStamp,
					}).done(function (data){
						cj("#saveDialog").dialog("close");
						CRM.alert(ts('Configuration Saved!!'),'CiviREBUX: Success','success',{'expires':3000});
					}).fail(function (data){
						CRM.alert(ts('Error Saving!!'),'CiviREBUX: Error','error',{'expires':3000});
					});
				},
				"Cancel": function(){
					cj("#saveDialog").dialog("close");
				}
			}
		})});

	// CiviCRM-style URL for directing Ajax calls to get a list of all saved configuration to output to user for selection while loading
	var crmLoadAllAjaxURL = CRM.url('civicrm/civirebux/ajax/loadAll');	

	// CiviCRM-style URL for directing Ajax calls to get a particular report configuration (uniquely id'ed by the `id` field) 
	var crmLoadAjaxURL = CRM.url('civicrm/civirebux/ajax/load');
		
	var crmAddToNavAjaxURL = CRM.url("civicrm/civirebux/ajax/addtonavigation");

	// Trigger function on load button click
	cj("#load").click( function(){
                cj("#loadDialog").dialog({
			width: 400,
			modal: true,
                        dialogClass: "no-close",
                        title: "Load Report",
                        open: function(){
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
                                  		// Loads the pivotUI with obtained configuration from the Ajax call
				              	cj("#loadDialog").dialog("close");
						var reportData = {/literal}{$pivotData}{literal};
                				var derivers = jQuery.pivotUtilities.derivers;
                				var sortAs = jQuery.pivotUtilities.sortAs;
						currConfig['vals'] = data['vals'];
                                                currConfig['rows'] = data['rows'];
                                                currConfig['cols'] = data['cols'];
                                                currConfig['aggregator'] = data['aggregator'];
					 	currConfig['renderer'] = data['renderer'];
						jQuery("#reportPivotTable").pivotUI(reportData, {
                        				rendererName: data['renderer'],
                       					renderers: CRM.$.extend(
                                				jQuery.pivotUtilities.renderers,
                                				jQuery.pivotUtilities.c3_renderers,
                                				jQuery.pivotUtilities.export_renderers
                        				),
                        				vals: data['vals'].split('#'),
                        				rows: data['rows'].split('#'),
                        				cols: data['cols'].split('#'),
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
                                       					"rows": config_copy["rows"].join('#'),
                                       					"cols": config_copy["cols"].join('#'),
                                       					"aggregatorName": config_copy["aggregatorName"],
                                       					"rendererName": config_copy["rendererName"],
                                       					"vals": config_copy["vals"].join('#')
                               					};
                       					},
                       					autoSortUnusedAttrs: true,
                       					unusedAttrsVertical: false
               					}, true);  // setting the override parameter to `true` to allow overriding of the existing pivotUI configuration	
                                                CRM.alert(ts('Configuration Loaded!!'),'CiviREBUX: Success','success',{'expires':3000});
                                        }).fail(function (data){
                                        	cj("#loadDialog").dialog("close");
					        CRM.alert(ts('Error Loading!!'),'CiviREBUX: Error','error',{'expires':3000});
                                        });
                                },
                                "Cancel": function(){
					cj("#loadDialog").dialog("close");
                                }
                        }
                })});	

	cj("#listOfSavedReports").click( function(){
        	jQuery.ajax({
                	type: "POST",
                 	url: crmLoadAllAjaxURL
           	}).done(function (data){
                        jQuery("#reportPivotTable").pivot(data, {
                        	rows: ['id','name','rows','cols','vals','renderer','aggregator','time']
                        });
			cj("#goback").show();
                }).fail(function (data){
                    	CRM.alert(ts('Error Loading!!'),'CiviREBUX: Error','error',{'expires':3000});
              	})});

	cj("#addToNav").click( function(){
		var currTimeStamp = getTimeStamp();
                cj("#addToNavSaveReportAs").attr("placeholder","CiviREBUX Report "+currTimeStamp);
                cj("#addToNavDialog").dialog({
                        width: 400,
                        modal: true,
                        dialogClass: "no-close",
                        title: "Add Report To Navigation",
                        buttons: {
                                "OK": function(){
                                        var name = cj("#addToNavSaveReportAs").val();
                                        if(name == ''){
                                                name = "CiviREBUX Report "+currTimeStamp;
                                        }
                                        jQuery.ajax({
                                                type: "POST",
                                                url: crmAddToNavAjaxURL,
                                                data: 'name='+name+'&renderer='+currConfig['rendererName']+'&aggregator='+currConfig['aggregatorName']+'&vals='+currConfig['vals']+'&rows='+currConfig['rows']+'&cols='+currConfig['cols']+'&time='+currTimeStamp
                                        }).done(function (data){
                                                cj("#addToNavDialog").dialog("close");
                                                CRM.alert(ts('Added To Navigation Menu!!'),'CiviREBUX: Success','success',{'expires':3000});
                                        }).fail(function (data){
                                                CRM.alert(ts('Error Adding To Navigation Menu!!'),'CiviREBUX: Error','error',{'expires':3000});
                                        });
                                },
                                "Cancel": function(){
                                        cj("#addToNavDialog").dialog("close");
                                }
                        }
                })});
	
	cj("#goback").click( function() {
		 cj("#goback").hide();
		 var reportData = {/literal}{$pivotData}{literal};
                 var derivers = jQuery.pivotUtilities.derivers;
             	 var sortAs = jQuery.pivotUtilities.sortAs;
                 jQuery("#reportPivotTable").pivotUI(reportData, {
                 	rendererName:	currConfig['renderer'],
                        renderers: CRM.$.extend(
                        	jQuery.pivotUtilities.renderers,
                             	jQuery.pivotUtilities.c3_renderers,
                                jQuery.pivotUtilities.export_renderers
                        ),
                       	vals: currConfig['vals'].split('#'),
                        rows: currConfig['rows'].split('#'),
                        cols: currConfig['cols'].split('#'),
                       	aggregatorName: currConfig['aggregator'],
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
                             		"rows": config_copy["rows"].join('#'),
                                  	"cols": config_copy["cols"].join('#'),
                                        "aggregatorName": config_copy["aggregatorName"],
                                        "rendererName": config_copy["rendererName"],
                                      	"vals": config_copy["vals"].join('#')
                     		};
                      	},
                        autoSortUnusedAttrs: true,
                        unusedAttrsVertical: false
                 }, true);	
	});


	/*
	* Returns default rows depending on the choice of report - Contribution or Membership
	* @param: void
	* @return: Array of row field names
	*/
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

	/*
	* Returns newly added derived attributes depending on the choice of report - Contribution or Membership
	* @param: an object corresponding to $,pivotUtilities.derivers
	* @return: dictionary of functions   
	*/
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
	
		/*
		* Loading the pivotUI for the div containing the pivot table. Set the override parameter for pivotUI to `true` to allow 
		* overriding of report configurations. Originally set to `false`.
		*/
		jQuery("#reportPivotTable").pivotUI(data, {
            		rendererName: "Table",
            		renderers: CRM.$.extend(
                		jQuery.pivotUtilities.renderers, 
				jQuery.pivotUtilities.c3_renderers,
                		jQuery.pivotUtilities.export_renderers
            		),
            		vals: [],
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
				/*
				* @param config handles comma-containing attribute names well. Rather than passing the 'rows','cols','vals' as Array 
				* objects, join them with a custom delimiter (in this case, #) and pass them as string. While loading, split them again using 
				* this custom delimiter and it works well. 
				*/
                    		var config_copy = JSON.parse(JSON.stringify(config));
				currConfig = {
					"rows": config_copy["rows"].join("#"),
					"cols": config_copy["cols"].join("#"),
					"aggregatorName": config_copy["aggregatorName"],
					"rendererName": config_copy["rendererName"],
					"vals": config_copy["vals"].join("#")
				};
			},
	    		autoSortUnusedAttrs: true,
           		unusedAttrsVertical: false
        	}, true);
    	});
</script>
{/literal}

{* FTUE Info text *}
<div id="banner">
<strong>CiviREBUX</strong> is a drag-n-drop report builder interface. It supports multiple data transformation functionalities like pivoting, filtering, sorting, and can display results in a table format as well as various chart displays. <a href="#" class="show">Read more...</a>
<div id="hidden-banner">
<ul>
<li><strong>Adding or Removing Attributes:</strong></li>
To add an attribute to the pivot table, drag and drop the attribute from the list above the pivot table to either the vertical or horizontal axis.<br>Remove an attribute by dragging it back to the field pool. Shifting how they appear in the listing will alter the order of display.
<br><br>
<li><strong>Using Renderers:</strong></li>
The renderer determines how the data will be displayed, and includes options such as a table listing (default), bar chart, heatmaps, scatter plots, and export options.
<br><br>
<li><strong>Using Aggregators:</strong></li>
The aggregator defines what will be displayed in the cells of the pivot table, and is found at the axis of the horizontal and vertical field list. They are functions which are called once per cell in the table. Options include count (default), sum, average, minimum, maximum, and many others. 
<br><br>
<li><strong>Filtering:</strong></li>
Click the drop-down arrow to the right of each field to expose filtering options. Use the search bar to locate specific records. 
<br><br>
<li><strong>Using Custom Attributes:</strong></li>
Several custom attributes (fields) have been included and may be used like standard fields when building your report. These include Month-wise, Date-wise, Day-wise, and Year-wise contribution receipts.
<br><br>
<li><strong>Saving and Loading Report Templates:</strong></li>
For a new report template, click on the 'Save New' button which opens a dialog where the report template can be assigned a name and a small description.<br>For loading an already saved report template, simply click on the 'Load' button to select from the list of saved report templates.<br>For overwriting the existing report template, click on 'Save' button and fill up the new name and description in the input fields.
<br><br>
<li><strong>Adding Report to Navigation Menu:</strong></li>
Click on 'Add To Navigation' menu to assign the report template a name and description and finally add it to the Navigation Menu under Reports >> CiviREBUX. This automatically saves the report as well.
<br><br>
<li><strong>Viewing Saved Report Templates:</strong></li>
Click on 'View Saved Reports' to see a list of previously saved report templates. Click on any row to load that particular report template.
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
<h3 id="title">{$CRMDataType} Summary Pivot Table</h3>

<input type="button" value="Save New" id="save" />
<input type="button" value="Load" id="load" />
<input type="button" value="View Saved Reports" id="listOfSavedReports" />
<input type="button" value="< Back" id="goback" style="display:none;"/>
<input type="button" value="Add to Navigation" id="addToNav" />
<br><br>

{* jQuery Dialog for Saving Report Templates *}
<div id="saveDialog" style="display:none;">
<label id="saveReportAsLabel">{ts}Save Report As{/ts}:</label>
<input id="saveReportAs" size="40"><br>
<label for="saveReportDesc">{ts}Add a Description{/ts}:</label>
<textarea id="saveReportDesc" style="height: 6em; width: 25em;"></textarea>
</div>

{* jQuery Dialog for Loading saved Report Templates *}
<div id="loadDialog" style="display:none;">
<label for="loadDialogList">{ts}Select One of the Saved Reports:{/ts}</label><br>
<div id="loadDialogList" style="width: 50px;"> </div>
</div>

<div id="addToNavDialog" style="display:none;">
<label for="addToNavSaveReportAs">{ts}Save Report As{/ts}:</label>
<input id="addToNavSaveReportAs" size="40"><br>
<label for="addToNavReportDesc">{ts}Add a Description{/ts}:</label>
<textarea id="addToNavReportDesc" style="height: 6em; width: 25em;"></textarea>
</div>

<div id="SavedReportsData" style="display:none;">
<table id="SavedReportsDataTable"></table>
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
	currConfig['name'] = "New Report";
	currConfig['id'] = 0;

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
		if(cj("#save").val() == "Save New"){
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
					var desc = cj("#saveReportDesc").val();
					if(name == ''){
						name = "CiviREBUX Report "+currTimeStamp;
					}
					jQuery.ajax({
						type: "POST",
						url: crmAjaxURL,
						data: 'name='+name+'&renderer='+currConfig['rendererName']+'&aggregator='+currConfig['aggregatorName']+'&vals='+currConfig['vals']+'&rows='+currConfig['rows']+'&cols='+currConfig['cols']+'&time='+currTimeStamp+'&desc='+desc+'&oldId=0',
					}).done(function (data){
						cj("#saveDialog").dialog("close");
						CRM.alert(ts('Report Template Saved!!'),'CiviREBUX: Success','success',{'expires':3000});
						var title = cj("#title").text();
						cj("#title").html(title.split(' | ')[0]+" | "+name);
						currConfig['name'] = name;
						currConfig['id'] = data['id'];
					}).fail(function (data){
						CRM.alert(ts('Error Saving!!'),'CiviREBUX: Error','error',{'expires':3000});
					});
				},
				"Cancel": function(){
					cj("#saveDialog").dialog("close");
				}
			}
		})}
		else if(cj("#save").val() == "Save"){
			var currTimeStamp = getTimeStamp();
                	cj("#saveReportAs").attr("placeholder","CiviREBUX Report "+currTimeStamp);
			cj("#saveReportAsLabel").html("Overwrite Report As: ");
                	cj("#saveDialog").dialog({
                        width: 400,
                        modal: true,
                        dialogClass: "no-close",
                        title: "Overwrite Report",
                        buttons: {
                                "OK": function(){
                                        var name = cj("#saveReportAs").val();
                			var desc = cj("#saveReportDesc").val();   
		                     	if(name == ''){
                                                name = "CiviREBUX Report "+currTimeStamp;
                                        }
                                        jQuery.ajax({
                                                type: "POST",
                                                url: crmAjaxURL,
                                                data: 'name='+name+'&renderer='+currConfig['rendererName']+'&aggregator='+currConfig['aggregatorName']+'&vals='+currConfig['vals']+'&rows='+currConfig['rows']+'&cols='+currConfig['cols']+'&time='+currTimeStamp+'&desc='+desc+'&oldId='+currConfig['id'],
                                        }).done(function (data){
                                                cj("#saveDialog").dialog("close");
                                                CRM.alert(ts('Report Template Updated!!'),'CiviREBUX: Success','success',{'expires':3000});
                                                var title = cj("#title").text();
                                                cj("#title").html(title.split(' | ')[0]+" | "+name);
                                                currConfig['name'] = name;
						currConfig['id'] = data['id'];
                                        }).fail(function (data){
                                                CRM.alert(ts('Error Saving!!'),'CiviREBUX: Error','error',{'expires':3000});
                                        });
                                },
                                "Cancel": function(){
                                        cj("#saveDialog").dialog("close");
                                }
                        }	
			});
		}
	});

	// CiviCRM-style URL for directing Ajax calls to get a list of all saved configuration to output to user for selection while loading
	var crmLoadAllAjaxURL = CRM.url('civicrm/civirebux/ajax/loadAll');	

	// CiviCRM-style URL for directing Ajax calls to get a particular report configuration (uniquely id'ed by the `id` field) 
	var crmLoadAjaxURL = CRM.url('civicrm/civirebux/ajax/load');
		
	var crmAddToNavAjaxURL = CRM.url("civicrm/civirebux/ajax/addtonavigation");

	var crmSavedReportsDataAjaxURL = CRM.url("civicrm/civirebux/ajax/getdataforsavedreports");
	
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
				              	cj("#loadDialog").dialog("close");
						var reportData = {/literal}{$pivotData}{literal};
                				var derivers = jQuery.pivotUtilities.derivers;
                				var sortAs = jQuery.pivotUtilities.sortAs;
						currConfig['vals'] = data['vals'];
                                                currConfig['rows'] = data['rows'];
                                                currConfig['cols'] = data['cols'];
                                                currConfig['aggregator'] = data['aggregator'];
					 	currConfig['renderer'] = data['renderer'];
						currConfig['name'] = data['name'];
						currConfig['id'] = data['id'];
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
                                       				currConfig["rows"] = config_copy["rows"].join('#');
                                       				currConfig["cols"] = config_copy["cols"].join('#');
                                       				currConfig["aggregatorName"] = config_copy["aggregatorName"];
                                       				currConfig["rendererName"] = config_copy["rendererName"];
                                       				currConfig["vals"] = config_copy["vals"].join('#');
                       					},
                       					autoSortUnusedAttrs: true,
                       					unusedAttrsVertical: false
               					}, true);  // setting the override parameter to `true` to allow overriding of the existing pivotUI configuration	
                                                CRM.alert(ts('Report Template Loaded!!'),'CiviREBUX: Success','success',{'expires':3000});
                                        	var title = cj("#title").text();
                        			cj("#title").html(title.split(' | ')[0]+" | "+data['name']);
						cj("#save").val("Save");
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
        	cj("#reportPivotTable").hide();
		cj("#addToNav").hide();
		cj("#SavedReportsData").show();
		jQuery.ajax({
                	type: "POST",
                 	url: crmSavedReportsDataAjaxURL
           	}).done(function (dataset){
                        cj("#SavedReportsDataTable").dataTable({
				"aaData": dataset,
				"bDestroy": true,
				"aoColumns": [{title:'ID'},{title:'Name of the Report'},{title:'Description'},{title: 'Last Modified Time'}],
                        	"fnRowCallback": function (nRow, aData, iDisplayIndex) {
					jQuery(nRow).click(function(){
						document.location = CRM.url('civicrm/civirebux/'+aData[0]);
					});
				}
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
                                        var desc = cj("#addToNavReportDesc").val();
					var name = cj("#addToNavSaveReportAs").val();
                                        if(name == ''){
                                                name = "CiviREBUX Report "+currTimeStamp;
                                        }
                                        jQuery.ajax({
                                                type: "POST",
                                                url: crmAddToNavAjaxURL,
                                                data: 'name='+name+'&renderer='+currConfig['rendererName']+'&aggregator='+currConfig['aggregatorName']+'&vals='+currConfig['vals']+'&rows='+currConfig['rows']+'&cols='+currConfig['cols']+'&time='+currTimeStamp+'&desc='+desc
                                        }).done(function (data){
                                                cj("#addToNavDialog").dialog("close");
						document.location = CRM.url('civicrm/civirebux/'+data['id']);
                                                CRM.alert(ts(data['name']+' \n added to Reports >> CiviREBUX in the Navigation Menu!!'),'CiviREBUX: Success','success',{'expires':3000});
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
		 cj("#SavedReportsData").hide();
		 cj("#reportPivotTable").show();
		 cj("#addToNav").show();
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
                               	currConfig["rows"] = config_copy["rows"].join('#');
                               	currConfig["cols"] = config_copy["cols"].join('#');
                             	currConfig["aggregatorName"] = config_copy["aggregatorName"];
                                currConfig["rendererName"] = config_copy["rendererName"];
                               	currConfig["vals"] = config_copy["vals"].join('#');
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
		var config = {/literal}{$report_config}{literal};
        	var derivers = jQuery.pivotUtilities.derivers;
		var sortAs = jQuery.pivotUtilities.sortAs;
	
		if(config.length != 0){
			CRM.alert(ts('Report Template Loaded!!'),'CiviREBUX: Success','success',{'expires':3000});	
			cj("#save").val("Save");		
			jQuery("#reportPivotTable").pivotUI(data, {
				rendererName: config['renderer'],
				renderers: CRM.$.extend(
					jQuery.pivotUtilities.renderers,
					jQuery.pivotUtilities.c3_renderers,
					jQuery.pivotUtilities.export_renderers
				),
				vals: config['vals'].split('#'),
				rows: config['rows'].split('#'),
				cols: config['cols'].split('#'),
				aggregatorName: config['aggregator'],
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
                                        currConfig["rows"] = config_copy["rows"].join('#');
                                       	currConfig["cols"] = config_copy["cols"].join('#');
                                       	currConfig["aggregatorName"] = config_copy["aggregatorName"];
                                       	currConfig["rendererName"] = config_copy["rendererName"];
                               		currConfig["vals"] = config_copy["vals"].join('#');
				},
				autoSortUnusedAttrs: true,
				unusedAttrsVertical: false
			}, true);
			var title = cj("#title").text();
                        cj("#title").html(title.split(' | ')[0]+" | "+config['name']);
			currConfig['id'] = config['id'];
		}
		else{
			cj("#save").val("Save New");
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
                                	currConfig["rows"] = config_copy["rows"].join('#');
                                     	currConfig["cols"] = config_copy["cols"].join('#');
                                      	currConfig["aggregatorName"] = config_copy["aggregatorName"];
                                        currConfig["rendererName"] = config_copy["rendererName"];
                                      	currConfig["vals"] = config_copy["vals"].join('#');				
				},
	    			autoSortUnusedAttrs: true,
           			unusedAttrsVertical: false
        		}, true);
			var title = cj("#title").text();
			cj("#title").html(title.split(' | ')[0]+" | New Report");
    		}
	});
</script>
{/literal}

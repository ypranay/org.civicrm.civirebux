<?php 
class CRM_Civirebux_BAO_Report{
	/**
	* Handle AJAX request to save report configuration 
	*/
	public static function save(){
		$renderer = isset($_REQUEST['renderer']) ? CRM_Utils_Type::escape($_REQUEST['renderer'], 'String') : 'Table';
		$aggregator = isset($_REQUEST['aggregator']) ? CRM_Utils_Type::escape($_REQUEST['aggregator'], 'String') : 'Count';
		$vals = isset($_REQUEST['vals']) ? CRM_Utils_Type::escape($_REQUEST['vals'], 'String') : 'Total';
		$rows = isset($_REQUEST['rows']) ? CRM_Utils_Type::escape($_REQUEST['rows'], 'String') : '';
		$cols = isset($_REQUEST['cols']) ? CRM_Utils_Type::escape($_REQUEST['cols'], 'String') : '';
		$name = isset($_REQUEST['name']) ? CRM_Utils_Type::escape($_REQUEST['name'], 'String') : 'Default';
		$dt = date('Y-m-d H:i:s');
		$ret = array();
    		$ret['renderer'] = $renderer;
		$ret['aggregator'] = $aggregator;
		$ret['vals'] = $vals;
		$ret['rows'] = $rows;
		$ret['cols'] = $cols;
		$ret['name'] = $name;
		$ret['time'] = $dt;
		$sql = "INSERT INTO civicrm_civirebux_configuration (`name`,`renderer`,`aggregator`,`vals`,`rows`,`cols`,`time`,`id`)
		VALUES ('".$name."','".$renderer."','".$aggregator."','".$vals."','".$rows."','".$cols."','".$dt."',NULL)";
		CRM_Core_DAO::executeQuery($sql);
    		CRM_Utils_JSON::output($ret);
	}
}

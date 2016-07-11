<?php 
class CRM_Civirebux_BAO_SaveReport{
	/**
	* Handle AJAX request to save report configuration 
	*/
	public static function save(){
		$renderer = isset($_REQUEST['renderer']) ? CRM_Utils_Type::escape($_REQUEST['renderer'], 'String') : 'Table';
		$aggregate = isset($_REQUEST['aggregate']) ? CRM_Utils_Type::escape($_REQUEST['aggregate'], 'String') : 'Count';
		$vals = isset($_REQUEST['vals']) ? CRM_Utils_Type::escape($_REQUEST['vals'], 'String') : 'Total';
		$rows = isset($_REQUEST['rows']) ? CRM_Utils_Type::escape($_REQUEST['rows'], 'String') : 'Display Name';
		$cols = isset($_REQUEST['cols']) ? CRM_Utils_Type::escape($_REQUEST['cols'], 'String') : '';
		$name = isset($_REQUEST['name']) ? CRM_Utils_Type::escape($_REQUEST['name'], 'String') : 'Default';
		$dt = date('Y-m-d H:i:s');
		$ret = array();
    		$ret['renderer'] = $renderer;
		$ret['aggregate'] = $aggregate;
		$ret['vals'] = $vals;
		$ret['rows'] = $rows;
		$ret['cols'] = $cols;
		$ret['name'] = $name;
		$ret['time'] = $dt;
    		CRM_Utils_JSON::output($ret);
	}
}

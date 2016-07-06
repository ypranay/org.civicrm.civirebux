<?php 
class CRM_Civirebux_BAO_SaveReport{
	/**
	* Handle AJAX request to save report configuration 
	*/
	static function save(){
		$data = $_POST['save'];
		$datajson = json_decode($data);
		foreach($datajson as $key=>$value){
			CRM_Core_Error::debug_var("key",$key);
		}
		$return = isset($_REQUEST['save']) ? CRM_Utils_Type::escape($_REQUEST['save'], 'String') : 'HAPPY!!' ;
	}
}

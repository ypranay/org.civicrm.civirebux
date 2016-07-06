<?php 
class CRM_Civirebux_BAO_SaveReport{
	/**
	* Handle AJAX request to save report configuration 
	*/
	static function save($data){
		foreach($data as $key=>$value){
			echo $key.":->".$value."<br>";
		}
		$log = new CRM_Utils_SystemLogger();
		$log->error('Reached', $data);
		$return = isset($_REQUEST['save']) ? CRM_Utils_Type::escape($_REQUEST['save'], 'String') : 'HAPPY!!' ;
		echo json_encode($return);
	}
}

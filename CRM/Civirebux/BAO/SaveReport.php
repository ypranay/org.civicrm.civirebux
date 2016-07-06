<?php 
class CRM_Civirebux_BAO_SaveReport{
	/**
	* Handle AJAX request to save report configuration 
	*/
	static function save($data){
	/*	foreach($data as $key=>$value){
			echo $key.":->".$value."<br>";
		}*/
		if(isset($_REQUEST['save'])){
			$config = $_POST['save'];
			$res = 'got it';
			die;
		}
		else{
			$res = 'nope!!';
			die;
		}
	}
}

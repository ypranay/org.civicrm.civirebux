<?php

require_once 'CRM/Core/Page.php';

class CRM_Civirebux_Page_ContribReport extends CRM_Core_Page {
  public function filter($contribdata){
	$newcontribdata = array(); 
	foreach($contribdata as $data) {
		$newdata = array();
		foreach(array_keys($data) as $key){
			if(!ctype_lower($key[0])){
				$newdata[$key] = $data[$key];
			}
		}
		array_push($newcontribdata,$newdata);
	}
	return $newcontribdata;
  }
  public function run() {
    	CRM_Utils_System::setTitle(ts('CiviREBUX: Contribution Report'));
	$this->assign('contribData', json_encode(self::filter(CRM_Civirebux_Data::get()))); 
    	parent::run();
  }
}

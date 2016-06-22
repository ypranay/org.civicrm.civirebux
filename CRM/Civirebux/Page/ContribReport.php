<?php

require_once 'CRM/Core/Page.php';

class CRM_Civirebux_Page_ContribReport extends CRM_Core_Page {
  /*
  * Hacky fix to remove duplicates. unset() wasn't working for unknown reasons. So, avoided the attributes which start with small letters <- Hack!!
  * Put the attributes which have uppercase initial letter into a new array and finally put the new array into another. ARRAYCEPTION!!
  *
  * @return array of arrays having contribution data with only useful and required attributes
  */
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

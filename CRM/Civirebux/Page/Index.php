<?php

require_once 'CRM/Core/Page.php';

class CRM_Civirebux_Page_Index extends CRM_Core_Page {
  public function run() {
    	CRM_Utils_System::setTitle(ts('CiviREBUX: Report Building Extension'));
	$CRMDataType = isset($_POST['CRMData']) ? $_POST['CRMData'] : 'Contribution';
	if($CRMDataType=='Contribution'){
		$this->assign('pivotData', json_encode(CRM_Civirebux_Data::getContributionData()));
	}
	else{
		$this->assign('pivotData', json_encode(CRM_Civirebux_Data::getMembershipData()));
	}
	$this->assign('CRMDataType',$CRMDataType);  
	$options_array = array('Contribution' => 'Contribution','Membership' => 'Membership');
	$this->assign('options_array',$options_array);  
	parent::run();
  }
}

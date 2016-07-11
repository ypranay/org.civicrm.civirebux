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
	
/*
	Create table. Will add support for creating table while installing the extension later

	$dao = CRM_Core_DAO::executeQuery("CREATE TABLE IF NOT EXISTS `civicrm_civirebux_configuration` (
	  `name` varchar(64) NOT NULL PRIMARY KEY,
	  `renderer` varchar(64) NOT NULL,
	  `aggregator` varchar(64) NOT NULL,
	  `vals` varchar(64) NOT NULL,
	  `rows` varchar(512),
	  `cols` varchar(512),
	  `time` timestamp NOT NULL)
	ENGINE=InnoDB DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci");
*/
/*
	Testing if Create Table worked. Works like a charm! civicrm_civirebux_configuration now is created.

	$dao = CRM_Core_DAO::executeQuery("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME LIKE 'civicrm_civir%'");
        $names= array();
	while ($dao->fetch()) {
                array_push($names,$dao->TABLE_NAME);
        }
        echo implode("|",$names);	
*/
/*
	Testing if values are populated into the database when saved! Voila!! Works like a charm!!
	
	$dao = CRM_Core_DAO::executeQuery("SELECT * FROM civicrm_civirebux_configuration");
        $names= array();
        while ($dao->fetch()) {
                array_push($names,$dao->name);
        }
        echo implode("<br>",$names);
*/
	parent::run();
  }
}

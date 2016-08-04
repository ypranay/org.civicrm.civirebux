<?php
class CRM_Civirebux_Page_Report extends CRM_Core_Page {

  public function run() {

    // Checking if the URL passed contains a trailing integer signifying the report which is to be loaded. Otherwise empty object is assigned to report_config.
    $url = CRM_Core_Config::singleton();
    $arg = explode('/', $_GET[$url->userFrameworkURLVar]);
    $reportId = 0;
    $config = array();
    if (sizeof($arg)>2){
      if(empty($_POST['CRMData'])){
        $reportId = $arg[2];
        $sql = "SELECT * FROM civicrm_civirebux_configuration WHERE id=".$reportId;
        $dao = CRM_Core_DAO::executeQuery($sql);
        while($dao->fetch()){
          $config['renderer'] = $dao->renderer;
          $config['aggregator'] = $dao->aggregator;
          $config['vals'] = $dao->vals;
          $config['rows'] = $dao->rows;
          $config['cols'] = $dao->cols;
          $config['name'] = $dao->name;
          $config['time'] = $dao->time;
          $config['id'] = $dao->id;
          $config['type'] = $dao->type;
        }
        if($config['type']=='Contribution'){
          $this->assign('pivotData', json_encode(CRM_Civirebux_Data::getContributionData()));
        }
        else{
          $this->assign('pivotData', json_encode(CRM_Civirebux_Data::getMembershipData()));
        }
        $this->assign('CRMDataType',$config['type']);  
      }
      else{
        $CRMDataType = $_POST['CRMData'];
        if($CRMDataType=='Contribution'){
          $this->assign('pivotData', json_encode(CRM_Civirebux_Data::getContributionData()));
        }
        else{
          $this->assign('pivotData', json_encode(CRM_Civirebux_Data::getMembershipData()));
        }
        $this->assign('CRMDataType',$CRMDataType);
      }
    }
    else{
      $CRMDataType = isset($_POST['CRMData']) ? $_POST['CRMData'] : 'Contribution';
      if($CRMDataType=='Contribution'){
        $this->assign('pivotData', json_encode(CRM_Civirebux_Data::getContributionData()));
      }
      else{
        $this->assign('pivotData', json_encode(CRM_Civirebux_Data::getMembershipData()));
      }
      $this->assign('CRMDataType',$CRMDataType);
    }
    $this->assign('report_config',json_encode($config));
    CRM_Utils_System::setTitle(ts('CiviREBUX: Report Building Extension'));
    $options_array = array('Contribution' => 'Contribution','Membership' => 'Membership');
    $this->assign('options_array',$options_array);
    parent::run();
  }
}

<?php 
/**
* Class handling all the ajax requests. Please view the wiki for a detailed explanation.
*/
class CRM_Civirebux_BAO_Report{
  
  /**
   * Outputs id of the newly added report template or the older report id, in case of overwriting an already saved report template.
   * For new reports, oldId=0 is passed and for overwriting, id of the report to be overwritten is passed as oldId
   * @function save
   * @return array $ret
   */
  public static function save(){
    $renderer = isset($_REQUEST['renderer']) ? CRM_Utils_Type::escape($_REQUEST['renderer'], 'String') : '';
    $aggregator = isset($_REQUEST['aggregator']) ? CRM_Utils_Type::escape($_REQUEST['aggregator'], 'String') : '';
    $vals = isset($_REQUEST['vals']) ? CRM_Utils_Type::escape($_REQUEST['vals'], 'String') : '';
    $rows = isset($_REQUEST['rows']) ? CRM_Utils_Type::escape($_REQUEST['rows'], 'String') : '';
    $cols = isset($_REQUEST['cols']) ? CRM_Utils_Type::escape($_REQUEST['cols'], 'String') : '';
    $name = isset($_REQUEST['name']) ? CRM_Utils_Type::escape($_REQUEST['name'], 'String') : '';
    $time = isset($_REQUEST['time']) ? CRM_Utils_Type::escape($_REQUEST['time'], 'String') : '';
    $oldid = isset($_REQUEST['oldId']) ? CRM_Utils_Type::escape($_REQUEST['oldId'], 'Integer') : 0;
    $desc = isset($_REQUEST['desc']) ? CRM_Utils_Type::escape($_REQUEST['desc'], 'String') : '';
    $type = isset($_REQUEST['type']) ? CRM_Utils_Type::escape($_REQUEST['type'], 'String') : '';
    $ret = array();
    if($oldid == 0){
      $sql = "INSERT INTO civicrm_civirebux_configuration (`id`,`name`,`renderer`,`aggregator`,`vals`,`rows`,`cols`,`time`,`desc`,`type`)
        VALUES (NULL,'".$name."','".$renderer."','".$aggregator."','".$vals."','".$rows."','".$cols."','".$time."','".$desc."','".$type."')";		
      CRM_Core_DAO::executeQuery($sql);
      $id=0;
      $dao = CRM_Core_DAO::executeQuery('SELECT `id` FROM civicrm_civirebux_configuration WHERE `name`="'.$name.'"');
      if($dao->fetch()){
        $id = $dao->id;
      }
      $ret['id'] = $id;
    }
    else{
      $sql = "UPDATE civicrm_civirebux_configuration SET `name`='".$name."',`renderer`='".$renderer."',`aggregator`='".$aggregator."',`vals`='".$vals."',`rows`='".$rows."',`cols`='".$cols."',`time`='".$time."',`desc`='".$desc."' WHERE `id`=".$oldid;
      CRM_Core_DAO::executeQuery($sql);
      $ret['id'] = $oldid;
    }
    CRM_Utils_JSON::output($ret);
  }

  /**
   * Outputs a JSON object with an array of JSON objects containing all the report configurations from the database.
   * @function loadAll
   * @return array $array_configs
   */
  public static function loadAll(){
    $type = isset($_REQUEST['type']) ? CRM_Utils_Type::escape($_REQUEST['type'], 'String') : '';
    $sql = "SELECT * FROM civicrm_civirebux_configuration WHERE `type`='".$type."'";
    $dao = CRM_Core_DAO::executeQuery($sql);
    $config = array();
    $array_configs = array();
    while($dao->fetch()){
      $config['renderer'] = $dao->renderer;
      $config['aggregator'] = $dao->aggregator;
      $config['vals'] = $dao->vals;
      $config['rows'] = $dao->rows;
      $config['cols'] = $dao->cols;
      $config['name'] = $dao->name;
      $config['time'] = $dao->time;
      $config['id'] = $dao->id;
      $config['desc'] = $dao->desc;
      $config['type'] = $dao->type;
      array_push($array_configs,$config);
    }
    CRM_Utils_JSON::output($array_configs);
  }

 /**
  * Outputs a JSON object with an array containing [id,name,type,desc,time] <- fields from all the report configurations from the database.
  * @function getDataForSavedReports
  * @return array $array_configs
  */
  public static function getDataForSavedReports(){
    $sql = "SELECT `id`, `name`, `type`, `desc`, `time` FROM civicrm_civirebux_configuration";
    $dao = CRM_Core_DAO::executeQuery($sql);
    $array_configs = array();
    while($dao->fetch()){
      $config = array();
      array_push($config,$dao->id);
      array_push($config,$dao->name);
      array_push($config,$dao->type);
      array_push($config,$dao->desc);
      array_push($config,$dao->time);
      array_push($array_configs,$config);
    }
    CRM_Utils_JSON::output($array_configs);
  }
  
  /**
  * Outputs a JSON object containing the report template which is to be loaded 
  * @function load
  * @return array $config
  */
  public static function load(){
    $id = isset($_REQUEST['id']) ? CRM_Utils_Type::escape($_REQUEST['id'], 'Integer') : 1;	
    $sql = "SELECT * FROM civicrm_civirebux_configuration WHERE id=".$id;
    $dao = CRM_Core_DAO::executeQuery($sql);
    $config = array();
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
    CRM_Utils_JSON::output($config);
  }
  
  /**
  * Outputs a JSON object containing the name and id of the report template which is both added to navigation as well as saved into the database. 
  * @function addToNavigation
  * @return array $config
  */
  public static function addToNavigation(){
    $renderer = isset($_REQUEST['renderer']) ? CRM_Utils_Type::escape($_REQUEST['renderer'], 'String') : '';
    $aggregator = isset($_REQUEST['aggregator']) ? CRM_Utils_Type::escape($_REQUEST['aggregator'], 'String') : '';
    $vals = isset($_REQUEST['vals']) ? CRM_Utils_Type::escape($_REQUEST['vals'], 'String') : '';
    $rows = isset($_REQUEST['rows']) ? CRM_Utils_Type::escape($_REQUEST['rows'], 'String') : '';
    $cols = isset($_REQUEST['cols']) ? CRM_Utils_Type::escape($_REQUEST['cols'], 'String') : '';
    $name = isset($_REQUEST['name']) ? CRM_Utils_Type::escape($_REQUEST['name'], 'String') : '';
    $time = isset($_REQUEST['time']) ? CRM_Utils_Type::escape($_REQUEST['time'], 'String') : '';
    $desc = isset($_REQUEST['desc']) ? CRM_Utils_Type::escape($_REQUEST['desc'], 'String') : ''; 
    $type = isset($_REQUEST['type']) ? CRM_Utils_Type::escape($_REQUEST['type'], 'String') : '';
    $sql = "INSERT INTO civicrm_civirebux_configuration (`id`,`name`,`renderer`,`aggregator`,`vals`,`rows`,`cols`,`time`,`desc`,`type`)
      VALUES (NULL,'".$name."','".$renderer."','".$aggregator."','".$vals."','".$rows."','".$cols."','".$time."','".$desc."','".$type."')";
    CRM_Core_DAO::executeQuery($sql);

    $dao = CRM_Core_DAO::executeQuery('SELECT `id` FROM civicrm_civirebux_configuration WHERE `name`="'.$name.'"');
    if($dao->fetch()){
      $id = $dao->id;
    }

    $reportsNavId = CRM_Core_DAO::getFieldValue('CRM_Core_DAO_Navigation', 'CiviREBUX', 'id', 'name');

    $params = array (
        'domain_id'  => CRM_Core_Config::domainID(),
        'label'      => $name,
        'name'       => 'Report ID = '.$id,
        'url'        => 'civicrm/civirebux/'.$id,
        'parent_id'  => $reportsNavId,
        'weight'     => 0,
        'permission' => 'access CiviCRM Civirebux',
        'separator'  => 1,
        'is_active'  => 1
        );

    $config = array();
    $config['name'] = $name;
    $config['id'] = $id;	

    $navigation = new CRM_Core_DAO_Navigation();
    $navigation->copyValues($params);
    $navigation->save();
    CRM_Core_BAO_Navigation::resetNavigation();
    CRM_Utils_JSON::output($config);
  }
}

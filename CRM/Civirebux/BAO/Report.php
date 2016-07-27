<?php 
class CRM_Civirebux_BAO_Report{
	/**
	* Handle AJAX request to save report configuration 
	*/
	public static function save(){
		$renderer = isset($_REQUEST['renderer']) ? CRM_Utils_Type::escape($_REQUEST['renderer'], 'String') : '';
		$aggregator = isset($_REQUEST['aggregator']) ? CRM_Utils_Type::escape($_REQUEST['aggregator'], 'String') : '';
		$vals = isset($_REQUEST['vals']) ? CRM_Utils_Type::escape($_REQUEST['vals'], 'String') : '';
		$rows = isset($_REQUEST['rows']) ? CRM_Utils_Type::escape($_REQUEST['rows'], 'String') : '';
		$cols = isset($_REQUEST['cols']) ? CRM_Utils_Type::escape($_REQUEST['cols'], 'String') : '';
		$name = isset($_REQUEST['name']) ? CRM_Utils_Type::escape($_REQUEST['name'], 'String') : '';
		$time = isset($_REQUEST['time']) ? CRM_Utils_Type::escape($_REQUEST['time'], 'String') : '';
		$ret = array();
    		$ret['renderer'] = $renderer;
		$ret['aggregator'] = $aggregator;
		$ret['vals'] = $vals;
		$ret['rows'] = $rows;
		$ret['cols'] = $cols;
		$ret['name'] = $name;
		$ret['time'] = $time;
		$sql = "INSERT INTO civicrm_civirebux_configuration (`id`,`name`,`renderer`,`aggregator`,`vals`,`rows`,`cols`,`time`)
		VALUES (NULL,'".$name."','".$renderer."','".$aggregator."','".$vals."','".$rows."','".$cols."','".$time."')";
		CRM_Core_DAO::executeQuery($sql);
    		CRM_Utils_JSON::output($ret);
	}

	public static function loadAll(){
		$sql = "SELECT * FROM civicrm_civirebux_configuration";
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
			array_push($array_configs,$config);
		}
		CRM_Utils_JSON::output($array_configs);
	}

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
                }
                CRM_Utils_JSON::output($config);
        }
	
	public static function addToNavigation(){
                $renderer = isset($_REQUEST['renderer']) ? CRM_Utils_Type::escape($_REQUEST['renderer'], 'String') : '';
                $aggregator = isset($_REQUEST['aggregator']) ? CRM_Utils_Type::escape($_REQUEST['aggregator'], 'String') : '';
                $vals = isset($_REQUEST['vals']) ? CRM_Utils_Type::escape($_REQUEST['vals'], 'String') : '';
                $rows = isset($_REQUEST['rows']) ? CRM_Utils_Type::escape($_REQUEST['rows'], 'String') : '';
                $cols = isset($_REQUEST['cols']) ? CRM_Utils_Type::escape($_REQUEST['cols'], 'String') : '';
                $name = isset($_REQUEST['name']) ? CRM_Utils_Type::escape($_REQUEST['name'], 'String') : '';
                $time = isset($_REQUEST['time']) ? CRM_Utils_Type::escape($_REQUEST['time'], 'String') : '';
        
	        $sql = "INSERT INTO civicrm_civirebux_configuration (`id`,`name`,`renderer`,`aggregator`,`vals`,`rows`,`cols`,`time`)
                VALUES (NULL,'".$name."','".$renderer."','".$aggregator."','".$vals."','".$rows."','".$cols."','".$time."')";
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
		
		$navigation = new CRM_Core_DAO_Navigation();
    		$navigation->copyValues($params);
    		$navigation->save();
    		CRM_Core_BAO_Navigation::resetNavigation();
    		return TRUE;	
        }
}

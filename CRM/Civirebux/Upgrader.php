<?php
class CRM_Civirebux_Upgrader extends CRM_Civirebux_Upgrader_Base {
  /**
   * While installing
   * 
   * @return boolean
   */
  public function install() {
    $this->upgrade_();
    return TRUE;
  }

  /**
   * While uninstalling
   * 
   * @return boolean
   */
  public function uninstall()
  {
    CRM_Core_DAO::executeQuery("DELETE FROM `civicrm_navigation` WHERE name = 'civirebux'");
    CRM_Core_BAO_Navigation::resetNavigation();
    return TRUE;
  }

  /**
   * Install Civirebux link under Reports menu.
   * 
   * @return boolean
   */
  public function upgrade_() {
    CRM_Core_DAO::executeQuery("DELETE FROM `civicrm_navigation` WHERE name = 'civirebux' and parent_id IS NULL");
    $reportsNavId = CRM_Core_DAO::getFieldValue('CRM_Core_DAO_Navigation', 'Reports', 'id', 'name');
    $navigation = new CRM_Core_DAO_Navigation();
    $params = array (
        'domain_id'  => CRM_Core_Config::domainID(),
        'label'      => ts('CiviREBUX'),
        'name'       => 'civirebux',
        'url'        => 'civicrm/civirebux',
        'parent_id'  => $reportsNavId,
        'weight'     => 0,
        'permission' => 'access CiviCRM Civirebux',
        'separator'  => 1,
        'is_active'  => 1
    );
    $navigation->copyValues($params);
    $navigation->save();
    CRM_Core_BAO_Navigation::resetNavigation();
    return TRUE;
  }

  /**
   * While enabling extension
   * 
   * @return boolean
   */
  public function onEnable() {
    CRM_Core_DAO::executeQuery("UPDATE civicrm_navigation SET is_active = 1 WHERE name = 'civirebux'");
    CRM_Core_BAO_Navigation::resetNavigation();
    return TRUE;
  }

  /**
   * While disabling extension
   * 
   * @return boolean
   */
  public function onDisable() {
    CRM_Core_DAO::executeQuery("UPDATE civicrm_navigation SET is_active = 0 WHERE name = 'civirebux'");
    CRM_Core_BAO_Navigation::resetNavigation();
    return TRUE;
  }
}

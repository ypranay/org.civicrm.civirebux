<?php
class CRM_Civirebux_Upgrader extends CRM_Civirebux_Upgrader_Base {
  /**
   * While installing
   * 
   * @return boolean
   */
  public function install() {
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

    CRM_Core_DAO::executeQuery("DROP TABLE IF EXISTS `civicrm_civirebux_configuration`");

    CRM_Core_DAO::executeQuery("CREATE TABLE `civicrm_civirebux_configuration` (
        `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
        `name` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
        `renderer` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
        `aggregator` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
        `vals` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
        `rows` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL,
        `cols` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL,
        `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        `desc` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
        `type` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
        PRIMARY KEY (`id`)
        ) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci");

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
    CRM_Core_DAO::executeQuery("DROP TABLE IF EXISTS `civicrm_civirebux_configuration`");
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

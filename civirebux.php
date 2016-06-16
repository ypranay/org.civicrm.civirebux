<?php

require_once 'civirebux.civix.php';

/**
 * Implements hook_civicrm_config().
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_config
 */
function civirebux_civicrm_config(&$config) {
  _civirebux_civix_civicrm_config($config);
}

/**
 * Implements hook_civicrm_xmlMenu().
 *
 * @param array $files
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_xmlMenu
 */
function civirebux_civicrm_xmlMenu(&$files) {
  _civirebux_civix_civicrm_xmlMenu($files);
}

/**
 * Implements hook_civicrm_install().
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_install
 */
function civirebux_civicrm_install() {
  _civirebux_civix_civicrm_install();
}

/**
 * Implements hook_civicrm_uninstall().
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_uninstall
 */
function civirebux_civicrm_uninstall() {
  _civirebux_civix_civicrm_uninstall();
}

/**
 * Implements hook_civicrm_enable().
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_enable
 */
function civirebux_civicrm_enable() {
  _civirebux_civix_civicrm_enable();
}

/**
 * Implements hook_civicrm_disable().
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_disable
 */
function civirebux_civicrm_disable() {
  _civirebux_civix_civicrm_disable();
}

/**
 * Implements hook_civicrm_upgrade().
 *
 * @param $op string, the type of operation being performed; 'check' or 'enqueue'
 * @param $queue CRM_Queue_Queue, (for 'enqueue') the modifiable list of pending up upgrade tasks
 *
 * @return mixed
 *   Based on op. for 'check', returns array(boolean) (TRUE if upgrades are pending)
 *                for 'enqueue', returns void
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_upgrade
 */
function civirebux_civicrm_upgrade($op, CRM_Queue_Queue $queue = NULL) {
  return _civirebux_civix_civicrm_upgrade($op, $queue);
}

/**
 * Implements hook_civicrm_managed().
 *
 * Generate a list of entities to create/deactivate/delete when this module
 * is installed, disabled, uninstalled.
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_managed
 */
function civirebux_civicrm_managed(&$entities) {
  _civirebux_civix_civicrm_managed($entities);
}

/**
 * Implements hook_civicrm_caseTypes().
 *
 * Generate a list of case-types.
 *
 * @param array $caseTypes
 *
 * Note: This hook only runs in CiviCRM 4.4+.
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_caseTypes
 */
function civirebux_civicrm_caseTypes(&$caseTypes) {
  _civirebux_civix_civicrm_caseTypes($caseTypes);
}

/**
 * Implements hook_civicrm_angularModules().
 *
 * Generate a list of Angular modules.
 *
 * Note: This hook only runs in CiviCRM 4.5+. It may
 * use features only available in v4.6+.
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_caseTypes
 */
function civirebux_civicrm_angularModules(&$angularModules) {
_civirebux_civix_civicrm_angularModules($angularModules);
}

/**
 * Implements hook_civicrm_alterSettingsFolders().
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_alterSettingsFolders
 */
function civirebux_civicrm_alterSettingsFolders(&$metaDataFolders = NULL) {
  _civirebux_civix_civicrm_alterSettingsFolders($metaDataFolders);
}

/**
 * Implementation of hook_civicrm_pageRun
 */
function civirebux_civicrm_pageRun($page) {
  if ($page instanceof CRM_Civirebux_Page_ContribReport) {
    CRM_Core_Resources::singleton()
      ->addScriptFile('org.civicrm.civirebux', 'js/pivottable/jquery-ui-1.9.2.custom.min.js')
      ->addScriptFile('org.civicrm.civirebux', 'js/pivottable/pivot.min.js', CRM_Core_Resources::DEFAULT_WEIGHT, 'page-header')
      ->addScriptFile('org.civicrm.civirebux', 'js/pivottable/c3.min.js')
      ->addScriptFile('org.civicrm.civirebux', 'js/pivottable/d3.min.js')
      ->addScriptFile('org.civicrm.civirebux', 'js/pivottable/d3.js')
      ->addScriptFile('org.civicrm.civirebux', 'js/pivottable/c3_renderers.js')
      ->addScriptFile('org.civicrm.civirebux', 'js/pivottable/export_renderers.js');
    CRM_Core_Resources::singleton()
      ->addStyleFile('org.civicrm.civirebux', 'css/pivottable/pivot.css')
      ->addStyleFile('org.civicrm.civirebux', 'css/pivottable/c3.min.css')
      ->addStyleFile('org.civicrm.civirebux', 'css/style.css');
  }
}

/**
 * Implementation of hook_civicrm_permission
 *
 * @param array $permissions
 * @return void
 */
function civirebux_civicrm_permission(&$permissions) {
  $prefix = ts('CiviCRM Reports') . ': '; // name of extension or module
  $permissions += array(
    'access CiviCRM Civirebux reports' => $prefix . ts('access CiviCRM Civirebux reports'),
  );
}
/**
 * Implements hook_civicrm_preProcess().
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_preProcess
 *
function civirebux_civicrm_preProcess($formName, &$form) {

} // */

/**
 * Implements hook_civicrm_navigationMenu().
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_navigationMenu
 *
function civirebux_civicrm_navigationMenu(&$menu) {
  _civirebux_civix_insert_navigation_menu($menu, NULL, array(
    'label' => ts('The Page', array('domain' => 'org.civicrm.civirebux')),
    'name' => 'the_page',
    'url' => 'civicrm/the-page',
    'permission' => 'access CiviReport,access CiviContribute',
    'operator' => 'OR',
    'separator' => 0,
  ));
  _civirebux_civix_navigationMenu($menu);
*/

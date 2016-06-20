<?php

require_once 'CRM/Core/Page.php';

class CRM_Civirebux_Page_ContribReport extends CRM_Core_Page {
  public function run() {
    // Example: Set the page-title dynamically; alternatively, declare a static title in xml/Menu/*.xml
    CRM_Utils_System::setTitle(ts('CiviREBUX'));

    $this->assign('contribData', json_encode(CRM_Civirebux_Data::get())); 

    parent::run();
  }
}

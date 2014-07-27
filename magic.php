<?php
require_once('config.inc.php');
require_once('db.inc.php');
require_once('smarty3.inc.php');

switch ($_REQUEST['stage']) {
   default:
      $smarty->display('magic/index.tpl');
}
?>
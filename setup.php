<?php
#  Version 1.0

require_once('db.inc.php');
require_once('smarty.inc.php');

switch ($_REQUEST[stage]) {
   default:
      $smarty->display('setup.tpl');
}
?>

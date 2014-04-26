<?php
#  Version 1

require_once('config.inc.php');
require_once('db.inc.php');
require_once('smarty.inc.php');

switch ($_REQUEST[stage]) {
   default:
      $smarty->display('setup_vorteile.tpl');
}
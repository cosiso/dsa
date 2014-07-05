<?php

require_once('config.inc.php');
require_once('db.inc.php');
require_once('smarty.inc.php');

function check_int($value, $zero=true) {
   if ($value and $value != intval($value)) {
	   return false;
	}
	if (! $value and ! $zero) {
	   return false;
	}
	return true;
}

function show() {
   global $db, $smarty, $debug;

   if (! check_int($_REQUEST[id], false)) {
      $smarty->assign('error', 'invalid character specified for view-bar');
   } else {
      $cid = $_REQUEST[id];

      $qry = "SELECT calc_mu($cid) AS mu, calc_kl($cid) AS kl, ";
      $qry .= "      calc_ch($cid) AS ch, calc_in($cid) AS in, ";
      $qry .= "      calc_ff($cid) AS ff, calc_ge($cid) AS ge, ";
      $qry .= "      calc_ko($cid) AS ko, calc_kk($cid) AS kk, ";
      $qry .= "      calc_fk($cid) AS fk, calc_ini($cid) AS ini ";
      $rid = $db->do_query($qry, true);
      $row = $db->get_array($rid);

      $smarty->assign($row);
   }
   return $smarty->fetch('value-bar.tpl');
}

echo show();
?>

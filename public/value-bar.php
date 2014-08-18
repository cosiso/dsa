<?php

require_once('config.inc.php');
require_once('db.inc.php');
require_once('smarty3.inc.php');

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

      $qry = "SELECT calc_mu($cid) AS mu, calc_kl($cid) AS kl, " .
         "calc_ch($cid) AS ch, calc_in($cid) AS in, " .
         "calc_ff($cid) AS ff, calc_ge($cid) AS ge, " .
         "calc_ko($cid) AS ko, calc_kk($cid) AS kk, " .
         "tot_fk($cid) AS fk, tot_ini($cid) AS ini, " .
         "cur_le($cid) AS le, COALESCE(le_used, 0) AS le_used, " .
         "cur_au($cid) AS au, COALESCE(au_used, 0) AS au_used, " .
         "cur_ae($cid) AS ae, COALESCE(ae_used, 0) AS ae_used " .
         "FROM basevalues WHERE character_id = $cid";

      $rid = $db->do_query($qry, true);
      $row = $db->get_array($rid);

      $smarty->assign($row);
      $smarty->assign('char_id', $cid);
   }
   return $smarty->fetch('divs/valuebar/value-bar.tpl');
}

function set_lost() {
   global $db, $debug;

   if (! check_int($_REQUEST['char_id'], false)) return;

   $id = trim($_REQUEST['id']);
   if ($id != 'le' and $id != 'au' and $id != 'ae') return;

   if (! check_int($_REQUEST['value'], true)) return;

   $qry = 'UPDATE basevalues SET %s = %d WHERE character_id = %d';
   $qry = sprintf($qry, $id . '_used', ($_REQUEST['value']) ? $_REQUEST['value'] : 0, $_REQUEST['char_id']);
   $db->do_query($qry, true);
}

switch ($_REQUEST['stage']) {
   case 'set_lost':
      set_lost();
      break;
   default:
      echo show();
}
?>

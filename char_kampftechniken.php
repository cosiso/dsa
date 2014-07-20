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
   global $db, $debug, $smarty;

   $qry = 'SELECT id, name FROM characters ORDER BY name';
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $qry = 'SELECT ckt.id, ckt.at, ckt.pa, kt.name, kt.unarmed FROM kampftechniken kt, char_kampftechniken ckt WHERE ckt.character_id = %d AND kt.id = ckt.kampftechnik_id ORDER BY kt.unarmed, kt.name';
      $qry = sprintf($qry, $row['id']);
      $rid2 = $db->do_query($qry, true);
      while ($row2 = $db->get_array($rid2)) {
         $row2['unarmed'] = ($row2['unarmed'] == 't') ? true : false;
         $row['techniken'][] = $row2;
      }
      $chars[] = $row;
   }
   $smarty->assign('chars', $chars);
}
switch ($_REQUEST['stage']) {
   default:
      show();
      $smarty->display('divs/characters/combat/kampftechniken.tpl');
}
?>
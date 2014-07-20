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

function update() {
   global $db, $debug;

   if (! check_int($_REQUEST['id'], false)) return;
   if (! check_int($_REQUEST['value'], false)) return;
   if ($_REQUEST['kind'] != 'at' and
       $_REQUEST['kind'] != 'pa') return;

   $qry = 'UPDATE char_kampftechniken SET %s = %d WHERE id = %d';
   $qry = sprintf($qry, $_REQUEST['kind'], $_REQUEST['value'], $_REQUEST['id']);
   $db->do_query($qry, true);
}

function list_techniken() {
   global $db, $debug, $smarty;

   if (! check_int($_REQUEST['id'], false)) {
      $smarty->assign('error', 'Invalid id specified');
      return;
   }
   $smarty->assign('char_id', $_REQUEST['id']);

   $technik[0] = '-- Select a kampftechnik';
   $qry = 'SELECT id, name FROM kampftechniken WHERE id NOT IN (SELECT kampftechnik_id FROM char_kampftechniken WHERE character_id = %d)';
   $qry = sprintf($qry, $_REQUEST['id']);
   $rid = $db->do_query($qry, false);
   while ($row = $db->get_array($rid)) {
      $technik[$row['id']] = $row['name'];
   }
   $smarty->assign('techniken', $technik);
}

function add() {
   global $db, $debug;

   if (! check_int($_REQUEST['char_id'], false)) {
      return array('message' => 'Invalid id specified');
   }
   if (! check_int($_REQUEST['technik'], false)) {
      return array('message', 'Invalid kampftechnik specified');
   }

   $qry = 'SELECT id FROM char_kampftechniken WHERE character_id = %d AND kampftechnik_id = %d';
   $qry = sprintf($qry, $_REQUEST['char_id'], $_REQUEST['technik']);
   if ($db->fetch_field($qry, true)) {
      return array('message' => 'Character already has that kampftechnik');
   }

   $qry = 'INSERT INTO char_kampftechniken (character_id, kampftechnik_id, at, pa) VALUES (%d, %d, 0, 0)';
   $qry = sprintf($qry, $_REQUEST['char_id'], $_REQUEST['technik']);
   if (! @$db->do_query($qry, false)) {
      return array('message' => 'Database-error' . ( ($debug) ? ': ' . pg_last_error() : ''));
   }
   $id = $db->insert_id('char_kampftechniken');

   $qry = 'SELECT name, unarmed FROM kampftechniken WHERE id = %d';
   list($name, $unarmed) = $db->get_list(sprintf($qry, $_REQUEST['technik']), true);

   return array('success' => true,
                'id'      => $id,
                'char_id' => $_REQUEST['char_id'],
                'unarmed' => ($unarmed == 't') ? true : false,
                'name'    => $name);

}

function remove() {
   global $db, $debug;

   if (! check_int($_REQUEST['id'], false)) {
      return array('message' => 'invalid id specified');
   }

   $qry = 'DELETE FROM char_kampftechniken WHERE id = %d';
   $db->do_query(sprintf($qry, $_REQUEST['id']), true);

   return array('success' => true,
                'id'      => $_REQUEST[id]);
}

switch ($_REQUEST['stage']) {
   case 'update':
      update();
      break;
   case 'list_techniken':
      list_techniken();
      $smarty->display('divs/characters/combat/list_techniken.tpl');
      break;
   case 'add':
      echo json_encode(add());
      break;
   case 'remove':
      echo json_encode(remove());
      break;
   default:
      show();
      $smarty->display('divs/characters/combat/kampftechniken.tpl');
}
?>
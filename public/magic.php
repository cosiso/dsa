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

   $qry = 'SELECT id, name FROM characters ORDER BY name';
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $characters[] = $row;
   }
   $smarty->assign('characters', $characters);
}

function show_character() {
   global $db, $smarty, $debug;

   if (! check_int($_REQUEST['id'], false)) {
      $smarty->assign('error', 'Invalid id specified');
      return;
   }

   $qry = 'SELECT cm.*, quellen.name FROM char_magic cm, quellen WHERE cm.character_id = %d AND quellen.id = cm.quelle_id';
   $qry = sprintf($qry, $_REQUEST['id']);
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $cm[] = $row;
   }
   $smarty->assign('cm', $cm);

   $qry = 'SELECT ci.id, i.name FROM char_instruktion ci, instruktionen i WHERE ci.character_id = %d AND ci.instruktion_id = i.id';
   $qry = sprintf($qry, $_REQUEST['id']);
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $ci[] = $row;
   }
   $smarty->assign('ci', $ci);
}

function frm_charmagic($char_id, $cm_id) {
   global $db, $smarty, $debug;

   if (! $char_id and ! $cm_id) {
      $smarty->assign('error', 'No id specified');
      return;
   }

   $quellen[0] = '-- Select a quelle';
   $rid = $db->do_query('SELECT id, name FROM quellen ORDER BY name', true);
   while ($row = $db->get_array($rid)) $quellen[$row['id']] = $row['name'];
   $smarty->assign('quellen', $quellen);

   $traditions[0] = '-- Select a tradition';
   $traditions = array_merge($traditions, $db->get_enum_values('magic_tradition'));
   $smarty->assign('traditions', $traditions);

   $beschworungs[0] = '-- Select type';
   $beschworungs = array_merge($beschworungs, $db->get_enum_values('magic_beschworung'));
   $smarty->assign('beschworungs', $beschworungs);

   $wesens[0] = '-- Select type';
   $wesens = array_merge($wesens, $db->get_enum_values('magic_wesen'));
   $smarty->assign('wesens', $wesens);

   if ($cm_id) {
      $smarty->assign('id', $cm_id);
      $qry = 'SELECT cm.character_id, char.name, cm.quelle_id, cm.tradition, cm.bescworung, cm.skt, cm.value ' .
             'FROM   char_magic cm, characters char ' .
             'WHERE  cm.id = %d AND ' .
             '       char.id = cm.character_id';
      $qry = sprintf($qry, $cm_id);
      $row = $db->get_array($db->do_query($qry, true));
      $smarty->assign($row);
   } else {
      $smarty->assign('character_id', $char_id);
      $qry = sprintf('SELECT name FROM characters where id = %d', $char_id);
      $smarty->assign('name', $db->fetch_field($qry, true));
   }
}

switch ($_REQUEST['stage']) {
   case 'frm-charmagic':
      if (! check_int($_REQUEST['id'], false)) {
         $smarty->assign('error', 'Invalid id specified');
      } else {
         if ($_SERVER['REQUEST_METHOD'] == 'GET') {
            frm_charmagic($_REQUEST['id'], null);
            $smarty->display('divs/magic/frm-charmagic.tpl');
         }
         else
            # Do something
            exit;
      }
      break;
   case 'show_character':
      show_character();
      $smarty->display('divs/magic/show_character.tpl');
      break;
   default:
      show();
      $smarty->display('magic.tpl');
}
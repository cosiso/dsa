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

   $smarty->assign('selected', 'characters');

   $qry = 'SELECT id, name FROM characters ORDER BY name';
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $chars[$row['id']] = $row['name'];
   }
   $smarty->assign('chars', $chars);
}

function show_char() {
   global $db, $debug, $smarty;

   if (! check_int($_REQUEST['id'], false)) {
      $smarty->assign('error', 'Invalid id specified');
   }
   $smarty->assign('id', $_REQUEST['id']);
}

function frm_cm() {
   global $db, $debug, $smarty;

   if (! check_int($_REQUEST['id'], false)) {
      $smarty->assign('error', 'Invalid id specified');
      return;
   }
   $smarty->assign('id', $_REQUEST['id']);
   if (! check_int($_REQUEST['cm_id'], true)) {
      $smarty->assign('error', 'Invalid id specified');
      return;
   }
   $smarty->assign('cm_id', $_REQUEST['cm_id']);

   $quellen[0] = '-- Select a quelle';
   $qry = 'SELECT id, name FROM quellen ORDER BY name';
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $quellen[$row['id']] = $row['name'];
   }
   $smarty->assign('quellen', $quellen);

   $smarty->assign('traditions', array('Inituitiv', 'Wissenschaftlich'));
   $smarty->assign('beschworungen', array('Essenz', 'Wesen'));
   $smarty->assign('wesens', array('Inspiration', 'Invokation', 'N.A.'));

   if ($_REQUEST['cm_id']) {
      # ToDo
   }
}

function edit_quelle() {
   global $db, $debug;

   if (! check_int($_REQUEST['id'], false) or
       ! check_int($_REQUEST['cm_id'], true)) {
      return array('message' => 'Invalid id specified');
   }
   # 0 => intuitiv, 1 => wissenschaftlich
   if (! in_array($_REQUEST['tradition'], array('0', '1'))) {
      return array('message' => 'Invalid tradition specified');
   }
   # 0 => essenz, 1 => wesen
   if (! in_array($_REQUEST['beschworung'], array('0', '1'))) {
      return array('message', 'Invalid beschwörung specified');
   }
   # 0 => inspiration, 1 => invokation, 2 => N.A.
   switch ($_REQUEST['type']) {
      case '0': $type = 'Inspiration'; break;
      case '1': $type = 'Invokation';  break;
      case '2': $type = '';            break;
      default:
         return array('message' => 'Invalid type specified');
   }
   $skt = strtoupper(trim($_REQUEST['skt']));
   if (! in_array($skt, array('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'))) {
      return array('message' => 'Invalid SKT specified');
   }

   if ($_REQUEST['cm_id']) {
      # Edit cm
   } else {
      # Add new magic source to character with value of 1
      $qry = "INSERT INTO char_magic (character_id, quelle_id, tradition, beschworung, wesen, skt, value) VALUES (%d, %d, '%s', '%s', %s, '%s', 1)";
      $qry = sprintf($qry, $_REQUEST['id'],
                           $_REQUEST['quelle'],
                           ($_REQUEST['tradition'] == '0') ? 'Intuitiv' : 'Wissenschaftlich',
                           ($_REQUEST['beschworung'] == '0') ? 'Essenz' : 'Wesen',
                           ($type) ? "'$type'" : 'NULL',
                           $skt);
      if (! @$db->do_query($qry, false)) {
         return array('message' => 'database-error' . ($debug) ? ': ' . $qry . "\n" . pg_last_error() : '');
      }
   }
   return array('message' => 'Editing');
}

switch ($_REQUEST['stage']) {
   case 'frm-cm':
      frm_cm();
      $smarty->display('magic/divs/form-add-cm.tpl');
      break;
   case 'show-char':
      show_char();
      $smarty->display('magic/divs/show-char.tpl');
      break;
   case 'edit-cm':
      echo json_encode(edit_quelle());
      break;
   default:
      show();
      $smarty->display('magic/index.tpl');
}
?>
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
function show_div() {
   global $debug, $smarty;

   if ($_REQUEST['div'] == 'quellen') {
      show_quellen();
      return 'magic/divs/quellen.tpl';
   } elseif ($_REQUEST['div'] == 'instruktionen') {
      show_instuktionen();
      return 'magic/divs/instruktionen.tpl';
   } else {
      $smarty->assign('error', 'Invalid value specified');
      return 'magic/divs/quellen.tpl';
   }
}

function show_quellen() {
   global $db, $debug, $smarty;

   $qry = 'SELECT id, name FROM quellen ORDER BY name';
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $quellen[] = $row;
   }
   $smarty->assign('quellen', $quellen);
}

function show_instruktionen() {
   global $db, $debug, $smarty;
}

function edit_quelle() {
   global $db, $debug;

   if (! check_int($_REQUEST['id'], true)) {
      return array('message' => 'invalid id specified');
   }
   $name = trim($_REQUEST['name']);
   if (! $name) {
      return array('message' => 'no name specified');
   }
   $desc = trim($_REQUEST['desc']);

   if (! $_REQUEST['id']) {
      # Add quelle
      $qry = "INSERT INTO quellen (name, description) VALUES ('%s', %s)";
      $qry = sprintf($qry, pg_escape_string($name),
                           ($desc) ? "'" . pg_escape_string($desc) . "'" : 'NULL');
   } else {
      # Update quelle
      $qry = "UPDATE quellen SET name = '%s', description = %s WHERE id = %d";
      $qry = sprintf($qry, pg_escape_string($name),
                           ($desc) ? "'" . pg_escape_string($desc) . "'" : 'NULL',
                           $_REQUEST['id']);
   }
   if (! @$db->do_query($qry, false)) {
      return array('message' => 'database-error' . ($debug) ? ': ' . pg_last_error() : '');
   }
   if (! $_REQUEST['id']) {
      $id = $db->insert_id('quellen');
   }

   return array('success' => true,
                'is_new'  => ($id) ? true : false,
                'id'      => ($id) ? $id : $_REQUEST['id'],
                'name'    => $name);
}

function form_quelle() {
   global $db, $debug, $smarty;

   if (! check_int($_REQUEST['id'], true)) {
      $smarty->assign('error', 'Invalid id specified');
      return;
   }
   if ($_REQUEST['id']) {
      $smarty->assign('id', $_REQUEST['id']);
      $qry = 'SELECT name, description FROM quellen WHERE id = %d';
      list($name, $desc) = $db->get_list(sprintf($qry, $_REQUEST['id']), true);
      $smarty->assign('name', $name);
      $smarty->assign('description', $desc);
   }
}

function remove_quelle() {
   global $db, $debug;

   if (! check_int($_REQUEST['id'], false)) {
      return array('message' => 'invalid id specified');
   }

   $qry = 'DELETE FROM quellen WHERE id = ' . $_REQUEST['id'];
   if (! @$db->do_query($qry, false)) {
      return array('message' => 'database-error' . ($debug) ? ': ' . pg_last_error() : '');
   }

   return array('success' => true,
                'id'      => $_REQUEST['id']);
}

function note_quelle() {
   global $db, $debug, $smarty;

   if (! check_int($_REQUEST['id'], false)) {
      $smarty->assign('error', 'Invalid id specified');
      return;
   }

   $qry = 'SELECT name, description FROM quellen WHERE id = ' . $_REQUEST['id'];
   list($name, $desc) = $db->get_list($qry, true);
   $smarty->assign('name', $name);
   $smarty->assign('desc', $desc);
}

switch ($_REQUEST['stage']) {
   case 'form-quelle':
      form_quelle();
      $smarty->display('magic/divs/form-quelle.tpl');
      break;
   case 'edit-quelle':
      echo json_encode(edit_quelle());
      break;
   case 'note-quelle':
      note_quelle();
      $smarty->display('magic/divs/note-quelle.tpl');
      break;
   case 'show_div':
      $template = show_div();
      $smarty->display($template);
      break;
   case 'remove':
      echo json_encode(remove_quelle());
      break;
   default:
      $smarty->display('magic/setup.tpl');
}
?>
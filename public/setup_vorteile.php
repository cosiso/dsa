<?php
#  Version 1

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

function update_vorteil() {
   global $db, $debug;

   $id = $_REQUEST[id];
   if (! check_int($id, true)) {
      return array('message' => 'invalid id given');
   }
   $name = trim($_REQUEST[name]);
   if (! $name) {
      return array('message' => 'no name given');
   }
   $vorteil = ($_REQUEST[is_vorteil]) ? 't' : 'f';
   $gp = trim($_REQUEST[gp]);
   if (! check_int($gp, true)) {
      return array('message' => 'GP should be a number');
   }
   $ap = trim($_REQUEST[ap]);
   if ($ap and $ap != intval($ap)) {
      return array('message' => 'AP should be a number');
   }
   $effect = trim($_REQUEST[effect]);
   if (! $effect) {
      return array('message' => 'no effect given');
   }
   $effect = preg_replace('~\R~u', "\n", $effect);
   $description = trim($_REQUEST[description]);
   $description = preg_replace('~\R~u', "\n", $description);

   if (! $id) {
      // Add a new vorteil
      $qry = 'INSERT INTO vorteile ';
      $qry .= '(name, vorteil, gp, ap, effect, description) VALUES (';
      $qry .= "'" . pg_escape_string($name) . "', ";
      $qry .= "'$vorteil', ";
      $qry .= ( ($gp) ? $gp : 'NULL') . ', ';
      $qry .= ( ($ap) ? $ap : 'NULL') . ', ';
      $qry .= "'" . pg_escape_string($effect) . "', ";
      $qry .= ( ($description) ? "'" . pg_escape_string($description) . "'" : 'NULL') . ')';
      if (! @$db->do_query($qry, false)) {
         return array('success' => false,
                      'message' => 'database-error while adding vorteil' . ( ($debug) ? ' ' . pg_last_error() : '') );
      }
      $id = $db->insert_id('vorteile');
      $update = false;
   } else {
      // Update a vorteil
      $qry = 'UPDATE vorteile SET ';
      $qry .= "      name = '" . pg_escape_string($name) . "', ";
      $qry .= "      vorteil = '$vorteil', ";
      $qry .= '      gp = ' . ( ($gp) ? $gp : 'NULL') . ', ';
      $qry .= '      ap = ' . ( ($ap) ? $ap : 'NULL') . ', ';
      $qry .= "      effect = '" . pg_escape_string($effect) . "', ";
      $qry .= '      description = ' . ( ($description) ? "'" . pg_escape_string($description) . "'" : 'NULL') . ' ';
      $qry .= "WHERE id = $id";
      if (! @$db->do_query($qry, false)) {
         return array('success' => false,
                      'message' => 'database-error while updating vorteil' . ( ($debug) ? ' ' . pg_last_error() : '') );
      }
      $update = true;
   }
   return array('success'     => true,
                'update'      => $update,
                'name'        => $name,
                'vorteil'     => ($vorteil == 't') ? true : false,
                'gp'          => $gp,
                'ap'          => $ap,
                'effect'      => $effect,
                'id'          => $id);
}

function show() {
   global $db, $debug, $smarty;

   $qry = 'SELECT * ';
   $qry .= 'FROM  vorteile ';
   $qry .= 'ORDER BY name';
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      if ($row[vorteil] == 't') {
         $vorteile[] = $row;
      } else {
         $nachteile[] = $row;
      }
   }
   $smarty->assign('vorteile', $vorteile);
   $smarty->assign('nachteile', $nachteile);
}

function show_edit() {
   global $db, $debug, $smarty;

   if (! check_int($_REQUEST[id], true)) {
      $smarty->assign('error', 'Invalid id specified');
      return;
   }

   if ($_REQUEST[id]) {
      $qry = 'SELECT * FROM vorteile WHERE id = %d';
      $rid = $db->do_query(sprintf($qry, $_REQUEST[id]), true);
      $row = $db->get_array($rid);
      $row[is_vorteil] = ($row[vorteil] == 't') ? 1 : 0;
      $smarty->assign($row);
   } else {
      $smarty->assign('id', 0);
      $smarty->assign('is_vorteil', ($_REQUEST[is_vorteil]) ? 1 : 0);
   }
}

function remove_vorteil() {
   global $db, $debug;

   if (! check_int($_REQUEST[id], false)) {
      return array('message' => 'invalid id specified');
   }

   $qry = 'DELETE FROM vorteile ';
   $qry .= 'WHERE id = ' . $_REQUEST[id];
   $rid = @$db->do_query($qry, false);
   if (! $rid) {
      return array('success' => false,
                   'message' => 'database-error while deleting');
   }
   return array('success' => true,
                'id'      => $_REQUEST[id]);
}

function info() {
   global $db, $debug, $smarty;

   if (! check_int($_REQUEST[id], false)) {
      $smarty->assign('error', 'Invalid id specified');
      return;
   }
   $qry = 'SELECT description FROM vorteile WHERE id = %d';
   $info = $db->fetch_field(sprintf($qry, $_REQUEST[id]), true);
   if (! $info) $info = 'No description available';

   $smarty->assign('info', $info);
}

switch ($_REQUEST[stage]) {
   case 'info':
      info();
      $smarty->display('divs/setup/vorteile/info.tpl');
      break;
   case 'show_edit':
      show_edit();
      $smarty->display('divs/setup/vorteile/edit.tpl');
      break;
   case 'edit':
      echo json_encode(update_vorteil());
      break;
   case 'remove':
      echo json_encode(remove_vorteil());
      break;
   default:
      show();
      $smarty->display('setup_vorteile.tpl');
}
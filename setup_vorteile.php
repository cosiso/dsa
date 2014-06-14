<?php
#  Version 1

require_once('config.inc.php');
require_once('db.inc.php');
require_once('smarty.inc.php');

function update_vorteil() {
   global $db, $debug;

   $id = $_REQUEST[id];
   if ($id and intval($id) != $id) {
      return array('success' => false,
                   'message' => 'invalid id given');
   }
   $name = trim($_REQUEST[name]);
   if (! $name) {
      return array('success' => false,
                   'message' => 'no name given');
   }
   $vorteil = ($_REQUEST[is_vorteil]) ? 't' : 'f';
   $gp = trim($_REQUEST[gp]);
   if ($gp and $gp != intval($gp)) {
      return array('success' => false,
                   'message' => 'GP should be a number');
   }
   $ap = trim($_REQUEST[ap]);
   if ($ap and $ap != intval($ap)) {
      return array('success' => false,
                   'message' => 'AP should be a number');
   }
   $effect = trim($_REQUEST[effect]);
   if (! $effect) {
      return array('success' => false,
                   'message' => 'no effect given');
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

function get_description() {
   global $db, $debug;

   if (! $_REQUEST[id] or intval($_REQUEST[id]) != $_REQUEST[id]) {
      return array('success' => false,
                   'message' => 'invalid id given');
   }

   $qry = 'SELECT description ';
   $qry .= 'FROM  vorteile ';
   $qry .= 'WHERE id = ' . $_REQUEST[id];
   $desc= $db->fetch_field($qry, true);
   return array('success'     => true,
                'id'          => $_REQUEST[id],
                'description' => $desc);
}

function tip_description() {
   global $db, $debug;

   if (! $_REQUEST[id] or
       intval($_REQUEST[id] != $_REQUEST[id])) {
      return 'Invalid id specified';
   }
   $qry = 'SELECT description ';
   $qry .= 'FROM  vorteile ';
   $qry .= 'WHERE id = ' . $_REQUEST[id];
   $description = $db->fetch_field($qry, true);
   if (! $description) $description = '&lt;no description available&gt;';
   return nl2br($description);
}

function show_edit() {
   global $db, $debug, $smarty;

   $smarty->assign('id', 0);
   if (intval($_REQUEST[id]) != $_REQUEST[id]) {
      $smarty->assign('name', 'Invalid id passed!');
      return;
   }
   if ($_REQUEST[id]) {
      $qry = 'SELECT * ';
      $qry .= 'FROM  vorteile ';
      $qry .= 'WHERE id = ' . $_REQUEST[id];
      $rid = $db->do_query($qry, true);
      $row = $db->get_array($rid);
      $row[is_vorteil] = ($row[vorteil] == 't') ? 1 : 0;
      $smarty->assign($row);
   } else {
      $smarty->assign('is_vorteil', ($_REQUEST[vorteil]) ? 1 : 0);
   }
}

function remove_vorteil() {
   global $db, $debug;

   if (! $_REQUEST[id] or
       $_REQUEST[id] != intval($_REQUEST[id])) {
      return array('success' => false,
                   'message' => 'invalid id specified');
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

switch ($_REQUEST[stage]) {
   case 'remove':
      echo json_encode(remove_vorteil());
      break;
   case "new":
      echo json_encode(update_vorteil());
      break;
   case 'get_description':
      echo json_encode(get_description());
      break;
   case 'tip_description':
      echo tip_description();
      break;
   case 'popup_edit':
      show_edit();
      $smarty->display('setup_vorteile_frm_edit.tpl');
      break;
   default:
      show();
      $smarty->display('setup_vorteile.tpl');
}
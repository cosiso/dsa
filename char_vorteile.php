<?php
# Version 1.0

require_once('config.inc.php');
require_once('db.inc.php');
require_once('smarty.inc.php');

function fetch_vorteile() {
   global $db, $debug, $smarty;

   $qry = 'SELECT id, name, effect, vorteil ';
   $qry .= 'FROM  vorteile ';
   $qry .= 'ORDER BY name';
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $row[vorteil] = ($row[vorteil] == 't') ? 1 : 0;
      $vorteile[] = $row;
   }
   $smarty->assign('vorteile', $vorteile);

   if ($_REQUEST[id] and
       $_REQUEST[id] == intval($_REQUEST[id])) {
      # Editing a character_vorteil
      $qry = 'SELECT id, value, note, vorteil_id AS vorteil ';
      $qry .= 'FROM  char_vorteile ';
      $qry .= 'WHERE id = ' . $_REQUEST[id];
      $rid = $db->do_query($qry, true);
      $row = $db->get_array($rid);
      $smarty->assign($row);
   }

   $out = $smarty->fetch('character_vorteile_frm.tpl');
   return $out;
}

function edit_vorteil() {
   global $db, $debug;

   if (! $_REQUEST[id]) $_REQUEST[id] = 0;
   if ($_REQUEST[id] != intval($_REQUEST[id])) {
      return array('success' => false,
                   'message' => 'invalid id specified');
   }
   if (! $_REQUEST[vorteil] or
       $_REQUEST[vorteil] != intval($_REQUEST[vorteil])) {
      return array('success' => false,
                   'message' => 'invalid vorteil' + phpinfo(INFO_VARIABLES));
   }
   if (! $_REQUEST[character_id] or
       $_REQUEST[character_id] != intval($_REQUEST[character_id])) {
      return array('success' => false,
                   'message' => 'invalid character id ' . (($debug) ? '(' . $_REQUEST[character_id] . ') ' : '') . 'specified');
   }
   $value = trim($_REQUEST[vorteil_value]);
   if ($value and $value != intval($value)) {
      return array('success' => false,
                   'message' => 'invalid value specififed');
   }
   $note = trim($_REQUEST[vorteil_note]);



   if ($_REQUEST[id]) {
      // Update
      $update = true;
      $qry = 'UPDATE char_vorteile SET ';
      $qry .= '      value = ' . ( ($value) ? $value : 'NULL') . ', ';
      $qry .= '      note = ' . ( ($note) ? "'" . pg_escape_string($note) . "'" : 'NULL') . ' ';
      $qry .= 'WHERE id = ' . $_REQUEST[id];
   } else {
      $update = false;
      $qry = 'SELECT id ';
      $qry .= 'FROM  char_vorteile ';
      $qry .= 'WHERE character_id = ' . $_REQUEST[character_id] . ' AND ';
      $qry .= '     vorteil_id = ' . $_REQUEST[vorteil];
      if ($db->fetch_field($qry)) {
         return array('success' => false,
                      'message' => 'Vorteil already exists');
      }
      // New
      $qry = 'INSERT INTO char_vorteile ';
      $qry .= '(character_id, vorteil_id, value, note) VALUES (';
      $qry .= $_REQUEST[character_id] . ', ';
      $qry .= $_REQUEST[vorteil] . ', ';
      $qry .= ( ($value) ? $value : 'NULL') . ', ';
      $qry .= ( ($note) ? "'" . pg_escape_string($note) . "'" : 'NULL') . ')';
   }
   if (! @$db->do_query($qry, false)) {
      return array('success' => false,
                   'message' => 'database-error updating/adding vorteil' . ($debug) ? ':' . pg_last_error() : '');
   }
   if (! $_REQUEST[id]) {
      $_REQUEST[id] = $db->insert_id('char_vorteile');
   }

   // Retrieve some value from the vorteil to return
   $qry = 'SELECT vorteil, effect, name ';
   $qry .= 'FROM  vorteile ';
   $qry .= 'WHERE id = ' . $_REQUEST[vorteil];
   $rid = $db->do_query($qry, true);
   list($is_vorteil, $effect, $name) = $db->get_array($rid);

   return array('success' => true,
                'id'      => $_REQUEST[id],
                'update'  => $update,
                'vorteil' => ($is_vorteil == 't') ? true : false,
                'effect'  => $effect,
                'name'    => $name,
                'note'    => $note,
                'value'   => $value);
}

function retrieve_vorteile() {
   global $db, $debug, $smarty;

   if (! $_REQUEST[id] or
       $_REQUEST[id] != intval($_REQUEST[id])) {
      return array('success' => false,
                   'message' => 'invalid id specified');
   }
   $qry = 'SELECT vorteile.name, vorteile.effect, char_vorteile.value, ';
   $qry .= '      char_vorteile.note, char_vorteile.id, char_vorteile.vorteil_id,';
   $qry .= '      vorteile.vorteil ';
   $qry .= 'FROM  char_vorteile, vorteile ';
   $qry .= 'WHERE char_vorteile.character_id = ' . $_REQUEST[id] . ' AND ';
   $qry .= '      vorteile.id = char_vorteile.vorteil_id ';
   $qry .= 'ORDER BY name';
   $rid = @$db->do_query($qry, false);
   if (! $rid) {
      return array('success' => false,
                   'message' => 'database-error while retrieving vorteile' . ($debug) ? ': ' . pg_last_error() : '');
   }
   while ($row = $db->get_array($rid)) {
      $row[vorteil] = ($row[vorteil] == 't') ? true : false;
      $vorteile[] = $row;
   }
   $smarty->assign('vorteile', $vorteile);
   $out = $smarty->fetch('character_vorteile.tpl');
   return array('success' => true,
                'html'    => $out);
}

function remove_vorteil() {
   global $db, $debug;

   if (! $_REQUEST[id] or
       $_REQUEST[id] != intval($_REQUEST[id])) {
      return array('success' => false,
                   'message' => 'invalid id specified');
   }
   $qry = 'DELETE FROM char_vorteile ';
   $qry .= 'WHERE id = ' . $_REQUEST[id];
   if (! @$db->do_query($qry, false)) {
      return array('success' => false,
                   'message' => 'database-error while deleting' . ( ($debug) ? ': ' . pg_last_error() : '') );
   }
   return array('success' => true,
                'id'      => $_REQUEST[id]);
}

function tip_description() {
   global $db, $debug;

   if (! $_REQUEST[id] or
       intval($_REQUEST[id] != $_REQUEST[id])) {
      return 'Invalid id specified';
   }
   $qry = 'SELECT vorteile.description ';
   $qry .= 'FROM  char_vorteile, vorteile ';
   $qry .= 'WHERE char_vorteile.id = ' . $_REQUEST[id] . ' AND ';
   $qry .= '      vorteile.id = char_vorteile.vorteil_id';
   $description = $db->fetch_field($qry, true);
   if (! $description) $description = '&lt;no description available&gt;';
   return nl2br($description);
}

switch ($_REQUEST[stage]) {
   case 'remove_vorteil':
      echo json_encode(remove_vorteil());
      break;
   case 'retrieve_vorteile':
      echo json_encode(retrieve_vorteile());
      break;
   case 'fetch_vorteile':
      echo fetch_vorteile();
      break;
   case 'edit_vorteil':
      echo json_encode(edit_vorteil());
      break;
   case 'tip_description':
      echo tip_description();
      break;
   default:
      echo json_encode(array('success' => false,
                             'message' => 'unknow action'));
}
?>
<?php
# Version 1.0

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

function show_vorteile() {
   global $db, $debug, $smarty;

   $qry = 'SELECT id, name FROM characters ORDER BY name';
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $qry = 'SELECT vorteile.id, vorteile.name, vorteile.vorteil, char_vorteile.value FROM vorteile, char_vorteile WHERE char_vorteile.vorteil_id = vorteile.id AND char_vorteile.character_id = ' . $row[id] . ' ORDER BY name';
      $rid2 = $db->do_query($qry, true);
      while ($row2 = $db->get_array($rid2)) {
         if ($row2[value]) {
            $row2[name] .= ' (' . $row2[value] . ')';
         }
         if ($row2[vorteil] == 't') {
            $row[vorteile][$row2[id]] = $row2[name];
         } else {
            $row[nachteile][$row2[id]] = $row2[name];
         }
      }
      $chars[] = $row;
   }
   $smarty->assign('chars', $chars);
}

function show_info() {
   global $db, $debug, $smarty;

   if (! check_int($_REQUEST[id], false)) {
      $smarty->assign('error', 'Invalid id specified');
      return;
   }
   $smarty->assign('vorteil_id', $_REQUEST[id]);
   if (! check_int($_REQUEST[char_id], false)) {
      $smarty->assign('error', 'Invalid id for character specified');
   }
   $smarty->assign('char_id', $_REQUEST[char_id]);

   $qry = 'SELECT name, effect, description FROM vorteile WHERE id = ' . $_REQUEST[id];
   $rid = $db->do_query($qry, true);
   $row = $db->get_array($rid);
   $smarty->assign($row);
   $qry = 'SELECT id, value, note FROM char_vorteile WHERE character_id = %d AND vorteil_id = %d';
   $rid = $db->do_query(sprintf($qry, $_REQUEST[char_id], $_REQUEST[id]));
   $row = $db->get_array($rid);
   $smarty->assign($row);
}

function edit_vorteil() {
   global $db, $debug;

   if (! check_int($_REQUEST[vorteil_id], false) or
       ! check_int($_REQUEST[char_id], false) or
       ! check_int($_REQUEST[cv_id], false)) {
      return array('message' => 'invalid id specified');
   }
   if (! check_int($_REQUEST[value], true)) {
      return array('message' => 'invalid value specified');
   }
   $note = trim($_REQUEST[note]);

   $qry = 'UPDATE char_vorteile SET value = %s, note = %s WHERE id = %d';
   $qry = sprintf($qry, ($_REQUEST[value]) ? $_REQUEST[value] : 'NULL',
                        ($note)            ? "'" . pg_escape_string($note) . "'" : 'NULL',
                        $_REQUEST[cv_id]);
   $db->do_query($qry, true);

   $qry = 'SELECT name, vorteil FROM vorteile WHERE id = %d';
   list($name, $vorteil) = $db->get_list(sprintf($qry, $_REQUEST[vorteil_id]), true);
   return array('success'    => true,
                'name'       => $name,
                'value'      => $_REQUEST[value],
                'vorteil'    => ($vorteil == 't') ? true : false,
                'char_id'    => $_REQUEST[char_id],
                'vorteil_id' => $_REQUEST[vorteil_id]);
}

function remove() {
   global $db, $debug;

   if (! check_int($_REQUEST[id], false)) {
      return array('message' => 'invalid id (' . $_REQUEST[id] . ') specified');
   }

   # Get some values to send back to client
   $qry = 'SELECT cv.character_id, cv.vorteil_id, v.vorteil FROM char_vorteile cv, vorteile v WHERE v.id = cv.vorteil_id and cv.id = ' . $_REQUEST[id];
   list($char_id, $vorteil_id, $vorteil) = $db->get_list($qry, true);

   $qry = 'DELETE FROM char_vorteile WHERE id = ' . $_REQUEST[id];
   $db->do_query($qry, true);

   return array('success'    => true,
                'char_id'    => $char_id,
                'vorteil_id' => $vorteil_id,
                'vorteil'    => ($vorteil == 't') ? true : false);
}

function load_vorteil() {
   global $db, $debug, $smarty;

   # Fetch characters
   $chars[""] = '-- Select a character';
   $qry = 'SELECT id, name FROM characters ORDER BY name';
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $chars[$row[id]] = $row[name];
   }
   $smarty->assign('chars', $chars);

   # Fetch vor- or nachteile
   $vorteile[""] = '-- Select a ' . ( ($_REQUEST[vorteil]) ? 'vorteil' : 'nachteil');
   $qry = 'SELECT id, name FROM vorteile WHERE vorteil = %s ORDER BY name';
   $qry = sprintf($qry, ($_REQUEST[vorteil]) ? 'true' : 'false');
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $vorteile[$row[id]] = $row[name];
   }
   $smarty->assign('vorteile', $vorteile);

   $smarty->assign('vorteil', ($_REQUEST[vorteil]) ? 'vorteil' : 'nachteil');
}

function add_vorteil() {
   global $db, $debug;

   if (! check_int($_REQUEST[char], false)) {
      return array('message' => 'invalid character selected');
   }
   if (! check_int($_REQUEST[vorteil], false)) {
      return array('message' => 'invalid vor- / nachteil selected');
   }

   $qry = 'SELECT id FROM char_vorteile WHERE character_id = %d AND vorteil_id = %d';
   $exist = $db->fetch_field(sprintf($qry, $_REQUEST[char], $_REQUEST[vorteil]));
   if ($exist) {
      return array('success'  => true,
                   'existing' => true);
   }

   $qry = 'INSERT INTO char_vorteile (character_id, vorteil_id) VALUES (%d, %d)';
   if (! @$db->do_query(sprintf($qry, $_REQUEST[char], $_REQUEST[vorteil]))) {
      return array('message' => 'database-error' . ( ($debug) ? ': ' . pg_last_error() : ''));
   }
   $id = $db->insert_id('char_vorteile');

   $qry = 'SELECT name, vorteil FROM vorteile WHERE id = ' . $_REQUEST[vorteil];
   list($name, $is_vorteil) = $db->get_list($qry, true);

   return array('success'    => true,
                'char_id'    => $_REQUEST[char],
                'vorteil_id' => $_REQUEST[vorteil],
                'name'       => $name,
                'is_vorteil' => ($is_vorteil == 't') ? true : false);
}

switch ($_REQUEST[stage]) {
   case 'edit':
      echo json_encode(edit_vorteil());
      break;
   case 'info':
      show_info();
      $smarty->display('divs/characters/info_vorteil.tpl');
      break;
   case 'load_vorteil':
      load_vorteil();
      $smarty->display('divs/characters/load_vorteil.tpl');
      break;
   case 'add_vorteil':
      echo json_encode(add_vorteil());
      break;
   case 'remove':
      echo json_encode(remove());
      break;
   default:
      show_vorteile();
      $smarty->display('divs/characters/vorteile.tpl');
}
/*
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
*/

?>
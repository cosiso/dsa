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
?>

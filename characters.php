<?php
#  Version 1.0

require_once('config.inc.php');
require_once('db.inc.php');
require_once('smarty.inc.php');

function show() {
   global $db, $smarty, $debug;

   # Get list of characters to display in left menu
   $qry .= 'SELECT id, name ';
   $qry .= 'FROM   characters ';
   $qry .= 'ORDER BY name';
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $characters[] = $row;
   }
   $smarty->assign('characters', $characters);
   # Get list of traits
   $qry = 'SELECT name ';
   $qry .= 'FROM  traits ';
   $qry .= 'ORDER BY name';
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $eigenschaften[] = $row;
   }
   $smarty->assign('eigenschaften', $eigenschaften);
}

function add_character($name) {
   global $db, $debug;

   $name = trim($name);
   if (! $name) {
      return array('success' => false,
                   'message' => 'No name given');
   }
   $_name = pg_escape_string($name);
   $qry = 'SELECT id ';
   $qry .= 'FROM  characters ';
   $qry .= "WHERE name = '$_name'";
   if ($db->fetch_field($qry, true)) {
      return array('success' => false,
                   'message' => 'This name is already in use');
   }

   $qry = 'INSERT INTO characters ';
   $qry .= '(name) VALUES (';
   $qry .= "'$_name')";
   if (! @$db->do_query($qry, false)) {
      $message = 'Database-error while adding character' . ( ($debug) ? ': ' . pg_last_error() : '');
      return array('success' => false,
                   'message' => $message);
   }

   $char_id = $db->insert_id('characters');

   return array('success'      => true,
                'character_id' => $char_id,
                'name'         => $name);
}
function show_main($char_id) {
   global $db, $debug;

   if (! $char_id or intval($char_id) != $char_id)  {
      return array('success' => false,
                   'message' => 'invalid id for character');
   }

   // Get general data
   $qry = 'SELECT * ';
   $qry .= 'FROM  characters ';
   $qry .= "WHERE id = $char_id";
   $rid = $db->do_query($qry, true);
   $data = $db->get_array($rid);
   // Get eigenschaften
   $qry = 'SELECT character_eigenschaften.*, traits.name ';
   $qry .= 'FROM  character_eigenschaften, traits ';
   $qry .= 'WHERE traits.id = character_eigenschaften.eigenschaft AND ';
   $qry .= "      character_eigenschaften.character = $char_id ";
#   return array('success' => false,
                #'message' => $qry);
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $eigenschaften[] = $row;
   }
   return array('success'       => true,
                'data'          => $data,
                'eigenschaften' => $eigenschaften);
}
function update_eigenschaft() {
   global $db, $debug;

   if (! $_REQUEST[char_id] or intval($_REQUEST[char_id] != $_REQUEST[char_id])) {
      return array('success' => false,
                   'message' => 'invalid character id');
   }
   if (! $_REQUEST[value] or intval($_REQUEST[value] != $_REQUEST[value])) {
      return array('success' => false,
                   'message' => 'invalid value given');
   }
   $fieldname = trim($_REQUEST[fieldname]);
   if (! $fieldname) {
      return array('success' => false,
                   'message' => 'invalid field');
   }
   list($eigenschaft, $column) = split('_', $fieldname);
   if (! $eigenschaft or ($column != 'base' and
                          $column != 'zugekauft' and
                          $column != 'modifier')) {
      return array('success' => false,
                   'message' => 'invalid field given');
   }
   # Verify that this eigenschaft exists
   $qry = "SELECT id FROM traits WHERE name = '" . pg_escape_string(ucfirst($eigenschaft)) . "'";
   $eigenschaft_id = $db->fetch_field($qry, true);
   if (! $eigenschaft_id) {
      return array('success' => false,
                   'message' => 'invalid eigenschaft (' . ucfirst($eigenschaft) . ')');
   }
   # Check if this will be an update or an insert
   $qry = 'SELECT id ';
   $qry .= 'FROM  character_eigenschaften ';
   $qry .= 'WHERE character = ' . $_REQUEST[char_id] . ' AND ';
   $qry .= "      eigenschaft = $eigenschaft_id";
   $row_id = $db->fetch_field($qry, true);
   if ($row_id) {
      # Update value
      $qry = 'UPDATE character_eigenschaften SET ';
      $qry .= "      $column = {$_REQUEST[value]} ";
      $qry .= "WHERE id = $row_id";
   } else {
      # Insert value
      $base = 0; $zugekauft = 0; $modifier = 0;
      $$column = $_REQUEST[value];
      $qry = 'INSERT INTO character_eigenschaften ';
      $qry .= '(character, eigenschaft, base, zugekauft, modifier) VALUES (';
      $qry .= $_REQUEST[char_id] . ', ';
      $qry .= "$eigenschaft_id, ";
      $qry .= "$base, ";
      $qry .= "$zugekauft, ";
      $qry .= "$modifier)";
   }
   if (! @$db->do_query($qry, false)) {
      return array('success'   => false,
                   'message'   => 'database error' . ( ($debug) ? ': ' . pg_last_error() : ''),
                   'fieldname' => $fieldname);
   }
   return array('success'   => true,
                'fieldname' => $fieldname);
}
function edit_name($char_id, $name) {
   global $db, $debug;

   if (intval($char_id) != $char_id) {
      return array('success' => false,
                   'message' => 'invalid id for character');
   }
   $name = trim($name);
   if (! $name) {
      return array('success' => false,
                   'message' => 'empty name given');
   }

   $_name = pg_escape_string($name);
   # Check if name already exits
   $qry = 'SELECT id ';
   $qry .= 'FROM  characters ';
   $qry .= "WHERE name = '$_name'";
   $old_id = $db->fetch_field($qry, true);
   if ($old_id and $old_id != $char_id) {
      return array('success' => false,
                   'message' => 'name already in use');
   }
   # Name is unchanged, return success
   if ($old_id) {
      return array('success' => true,
                   'update'  => true,
                   'name'    => $name);
   }
   # Update name
   $qry = 'UPDATE characters SET ';
   $qry .= "      name = '$_name' ";
   $qry .= "WHERE id = $char_id";
   if (! @$db->do_query($qry, false)) {
      $msg = 'database error while updating' . ( ($debug) ? ': ' . pg_last_error() : '');
      return array('success' => false,
                   'message' => $msg);
   }
   return array('success'      => true,
                'update'       => true,
                'character_id' => $char_id,
                'name'         => $name);
}

function remove_char() {
   global $db, $debug;

   if (! $_REQUEST[id] or
       $_REQUEST[id] != intval($_REQUEST[id])) {
      return array('success' => false,
                   'message' => 'invalid id specified');
   }
   $qry = 'DELETE FROM characters ';
   $qry .= 'WHERE id = ' . $_REQUEST[id];
   $rid = @$db->do_query($qry, false);
   if (! $rid) {
      return array('success' => false,
                   'message' => 'database-error while removing');
   }
   return array('success' => true,
                'id'      => $_REQUEST[id]);
}
function retrieve_vorteile() {
   global $db, $debug, $smarty;

   if (! $_REQUEST[id] or
       $_REQUEST[id] != intval($_REQUEST[id])) {
      return array('success' => false,
                   'message' => 'invalid id specified');
   }
   $qry = 'SELECT vorteile.name, vorteile.effect, char_vorteile.value, ';
   $qry .= '      char_vorteile.note, char_vorteile.id ';
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
      $vorteile[] = $row;
   }
   $smarty->assign('vorteile', $vorteile);
   $out = $smarty->fetch('character_vorteile.tpl');
   return array('success' => true,
                'html'    => $out);
}
function fetch_vorteile() {
   global $db, $debug, $smarty;

   $qry = 'SELECT id, name, vorteil ';
   $qry .= 'FROM  vorteile ';
   $qry .= 'ORDER BY name';
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $vorteile[] = $row;
   }
   $smarty->assign('vorteile', $vorteile);
   $out = $smarty->fetch('character_vorteile_frm.tpl');
   return $out;
}

function update_field() {
   global $db, $debug;

   $field = trim($_REQUEST[fieldname]);
   $_field = pg_escape_string($field);
   if (! $_field) {
      return array('success' => false,
                   'message' => 'invalid field specified');
   }
   if (! $_REQUEST[char_id] or
       $_REQUEST[char_id] != intval($_REQUEST[char_id])) {
      return array('success' => false,
                   'message' => 'invalid character id given');
   }
   $qry = 'UPDATE characters SET ';
   $qry .= $_field . " = '" . pg_escape_string($_REQUEST[value]) . "' ";
   $qry .= 'WHERE id = ' . $_REQUEST[char_id];
   #return array('success' => false,
                #'message' => $qry);

   if (! $db->do_query($qry, false)) {
      if ($debug) {
         return array('success'   => false,
                      'message'   => 'database-error ' + pg_last_error(),
                      'fieldname' => $field);
      }
      return array('success'   => false,
                   'fieldname' => $field);
   }
   return array('success'   => true,
                'fieldname' => $field);
}
switch ($_REQUEST[stage]) {
   case 'fetch_vorteile':
      echo fetch_vorteile();
      break;
   case 'retrieve_vorteile':
      echo json_encode(retrieve_vorteile());
      break;
   case 'main':
      echo json_encode(show_main($_REQUEST[char_id]));
      break;
   case 'new':
      if ($_REQUEST[char_id])
         echo json_encode(edit_name($_REQUEST[char_id], $_REQUEST[name]));
      else
         echo json_encode(add_character($_REQUEST[name]));
      break;
   case 'update_field':
      echo json_encode(update_field());
      break;
   case 'update_eigenschaft':
      echo json_encode(update_eigenschaft());
      break;
   case 'remove':
      echo json_encode(remove_char());
      break;
   default:
      show();
      $smarty->display('characters.tpl');
}
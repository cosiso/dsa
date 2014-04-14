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

   $qry = 'SELECT * ';
   $qry .= 'FROM  characters ';
   $qry .= "WHERE id = $char_id";
   $rid = $db->do_query($qry, true);
   $row = $db->get_array($rid);
   return array('success' => true,
                'data'    => $row);
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
   return array('success' => true,
                'update'  => true,
                'name'    => $name);
}

switch ($_REQUEST[stage]) {
   case 'main':
      echo json_encode(show_main($_REQUEST[char_id]));
      break;
   case 'new':
      if ($_REQUEST[char_id])
         echo json_encode(edit_name($_REQUEST[char_id], $_REQUEST[name]));
      else
         echo json_encode(add_character($_REQUEST[name]));
      break;
   default:
      show();
      $smarty->display('characters.tpl');
}
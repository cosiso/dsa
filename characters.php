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

   // Get general data
   $qry = 'SELECT * ';
   $qry .= 'FROM  characters ';
   $qry .= "WHERE id = $char_id";
   $rid = $db->do_query($qry, true);
   $data = $db->get_array($rid);
   return array('success'       => true,
                'data'          => $data);
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

function change_ap() {
   global $db, $debug;

   if (! $_REQUEST[char_id] or
       $_REQUEST[char_id] != intval($_REQUEST[char_id])) {
      return array('message' => 'invalid character id');
   }
   if (! $_REQUEST[value] or
       $_REQUEST[value] != intval($_REQUEST[value])) {
      $_REQUEST[value] = 0;
   }

   $field = trim($_REQUEST[field]);
   $qry = 'UPDATE characters SET ap = ';
   switch ($field) {
      case 'ap':
         # Simply set the field to the specified value
         $qry .= $_REQUEST[value];
         break;
      case 'add_ap':
         # Add value to ap
         $qry .= 'COALESCE(ap, 0) + ' . $_REQUEST[value];
         break;
      case 'sub_ap':
         # Subtract value from ap
         $qry .= 'COALESCE(ap, 0) - ' . $_REQUEST[value];
         break;
      default:
         # Invalid field
         return array('message' => 'invalid field');
   }
   $qry .= ' WHERE id = ' . $_REQUEST[char_id];
   if (! @$db->do_query($qry, false)) {
      return array('message' => 'database-error while updating AP' . ( ($debug) ? ': ' . pg_last_error() : ''));
   }
   $qry = 'SELECT ap FROM characters WHERE id = ' . $_REQUEST[char_id];
   $ap = $db->fetch_field($qry, true);
   return array('success' => true,
                'field'   => $field,
                'value'   => $_REQUEST[value],
                'ap'      => $ap);
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
   case 'update_field':
      echo json_encode(update_field());
      break;
   case 'remove':
      echo json_encode(remove_char());
      break;
   case 'change_ap':
      echo json_encode(change_ap());
      break;
   default:
      show();
      $smarty->display('characters.tpl');
}
<?php
# Version 1.0

require_once('config.inc.php');
require_once('db.inc.php');
require_once('smarty.inc.php');

function update_eigenschaft() {
   global $db, $debug;

   $fieldname = trim($_REQUEST[fieldname]);
   if (! $fieldname) {
      return array('success' => false,
                   'message' => 'invalid field');
   }
   if (! $_REQUEST[char_id] or intval($_REQUEST[char_id] != $_REQUEST[char_id])) {
      return array('success'   => false,
                   'fieldname' => $fieldname,
                   'message'   => 'invalid character id');
   }
   if (! $_REQUEST[value]) {
      $is_zero = true;
      $_REQUEST[value] = 0;
   }
   if (intval($_REQUEST[value] != $_REQUEST[value])) {
      return array('success'   => false,
                   'fieldname' => $fieldname,
                   'message'   => 'invalid value given');
   }
   list($eigenschaft, $column) = split('_', $fieldname);
   if (! $eigenschaft or ($column != 'base' and
                          $column != 'zugekauft' and
                          $column != 'modifier')) {
      return array('success'   => false,
                   'fieldname' => $fieldname,
                   'message'   => 'invalid field given');
   }
   # Verify that this eigenschaft exists
   $qry = "SELECT id FROM traits WHERE name = '" . pg_escape_string(ucfirst($eigenschaft)) . "'";
   $eigenschaft_id = $db->fetch_field($qry, true);
   if (! $eigenschaft_id) {
      return array('success'   => false,
                   'fieldname' => $fieldname,
                   'message'   => 'invalid eigenschaft (' . ucfirst($eigenschaft) . ')');
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
                   'is_zero'   => ($is_zero) ? true : false,
                   'fieldname' => $fieldname);
   }
   return array('success'   => true,
                'fieldname' => $fieldname);
}

function retrieve_eigenschaften() {
   global $db, $debug, $smarty;

   if (! $_REQUEST[id] or
       $_REQUEST[id] != intval($_REQUEST[id])) {
      return array('success' => false,
                   'message' => 'invalid id specified');
   }

   # Get list of traits
   $qry = 'SELECT name ';
   $qry .= 'FROM  traits ';
   $qry .= 'ORDER BY name';
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $eigenschaften[] = $row;
   }
   $smarty->assign('eigenschaften', $eigenschaften);

   // Get eigenschaften
   $qry = 'SELECT character_eigenschaften.*, traits.name ';
   $qry .= 'FROM  character_eigenschaften, traits ';
   $qry .= 'WHERE traits.id = character_eigenschaften.eigenschaft AND ';
   $qry .= '      character_eigenschaften.character = ' . $_REQUEST[id];
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $values[$row[name]] = $row;
   }
   $smarty->assign('values', $values);

   $qry = 'SELECT * ';
   $qry .= 'FROM  basevalues ';
   $qry .= 'WHERE character_id = ' . $_REQUEST[id];
   $rid = $db->do_query($qry, true);
   $row = $db->get_array($rid);
   $smarty->assign($row);

   $out = $smarty->fetch('character_eigenschaften.tpl');

   return array('success' => true,
                'html'    => $out);
}

switch ($_REQUEST[stage]) {
   case 'retrieve_eigenschaften':
      echo json_encode(retrieve_eigenschaften());
      break;
   case 'update_eigenschaft':
      echo json_encode(update_eigenschaft());
      break;
   default:
      echo json_encode(array('success' => false,
                             'message' => 'unknow action'));
}
?>
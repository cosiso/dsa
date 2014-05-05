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

   /* Vorteile / nachteil influencing basevalues */
   # Gefäß der Sterne -> AE
   $qry = 'SELECT vorteile.id FROM ';
   $qry .= '      char_vorteile, vorteile ';
   $qry .= 'WHERE char_vorteile.character_id = ' . $_REQUEST[id] . ' AND ';
   $qry .= '      char_vorteile.vorteil_id = vorteile.id AND ';
   $qry .= "      vorteile.name = 'Gefäß der Sterne'";
   $smarty->assign('gefass', $db->fetch_field($qry, true));
   # Kampfreflexe -> INI
   $qry = 'SELECT vorteile.id ';
   $qry .= 'FROM  char_vorteile, vorteile ';
   $qry .= 'WHERE char_vorteile.vorteil_id = vorteile.id AND ';
   $qry .= "      vorteile.name = 'Kampfreflexe' AND ";
   $qry .= '      char_vorteile.character_id = ' . $_REQUEST[id];
   $smarty->assign('kampfreflexe', $db->fetch_field($qry, true));
   # Kampfgespür -> INI
   $qry = 'SELECT vorteile.id ';
   $qry .= 'FROM  char_vorteile, vorteile ';
   $qry .= 'WHERE char_vorteile.vorteil_id = vorteile.id AND ';
   $qry .= "      vorteile.name = 'Kampfgespür' AND ";
   $qry .= '      char_vorteile.character_id = ' . $_REQUEST[id];
   $smarty->assign('kampfgespur', $db->fetch_field($qry, true));

   $out = $smarty->fetch('character_eigenschaften.tpl');

   return array('success' => true,
                'html'    => $out);
}
function update_basevalue() {
   global $db, $debug;

   // Verify field is valid
   $field = trim($_REQUEST[field]);
   if (! $field) {
      return array('success' => false,
                   'message' => 'No field specified');
   }
   preg_match('/^(le|au|ae|mr|ini|at)_(used|mod|bought)$/', $field, $match);
   if (! $match) {
      return array('success' => false,
                   'field'   => $field,
                   'message' => "invalid field ($field) specified");
   }
   # Initiativ, attack has only mod
   if (preg_match('/^(ini|at)_(used|bought)$/', $field)) {
      return array('success' => false,
                   'field'   => $field,
                   'message' => "invalid field ($field) specified");
   }
   switch ($match[1]) {
      case 'le' : $total = 'lebenspunkte';   break;
      case 'au' : $total = 'ausdauer';       break;
      case 'ae' : $total = 'astralenergie';  break;
      case 'mr' : $total = 'magieresistenz'; break;
      case 'ini': $total = 'initiativ';      break;
      case 'at' : $total = 'attack';         break;
   }

   if (! $_REQUEST[id] or
       $_REQUEST[id] != intval($_REQUEST[id])) {
      return array('success' => false,
                   'field'   => $field,
                   'total'   => $total,
                   'message' => 'invalid id specified');
   }

   $value = trim($_REQUEST[value]);
   if (! $value) $value = 0;
   if ($value != intval($value)) {
      return array('success' => false,
                   'field'   => $field,
                   'total'   => $total,
                   'message' => 'invalid value specified');
   }

   $qry = 'SELECT id FROM basevalues WHERE character_id = ' . $_REQUEST[id];
   if (! $db->fetch_field($qry, true)) {
      // basevalues does not yet exit, create it
      $qry = 'INSERT INTO basevalues (character_id) VALUES (' . $_REQUEST[id] . ')';
      $db->do_query($qry, true);
   }

   $qry = 'UPDATE basevalues SET ';
   $qry .= $field . ' = ' . $_REQUEST[value] . ' ';
   $qry .= 'WHERE character_id = ' . $_REQUEST[id];
   if (! $db->do_query($qry, false)) {
      return array('success' => false,
                   'field'   => $field,
                   'total'   => $total,
                   'message' => 'database-error while updating' . ( ($debug) ? ':' . pg_last_error() : ''));
   }

   return array('success' => true,
                'field'   => $field,
                'value'   => $_REQUEST[value],
                'total'   => $total,
                'message' => 'dummy');
}

switch ($_REQUEST[stage]) {
   case 'update_basevalue' :
      echo json_encode(update_basevalue());
      break;
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
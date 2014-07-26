<?php
# Version 1.0

require_once('config.inc.php');
require_once('db.inc.php');
require_once('smarty.inc.php');

function show() {
   global $db, $smarty, $debug;

   $qry = 'SELECT id, name ';
   $qry .= 'FROM  characters ';
   $qry .= 'ORDER BY name';
   $rid = $db->do_query($qry, false);
   while ($row = $db->get_array($rid)) {
      $chars[] = $row;
   }
   $smarty->assign('chars', $chars);
}

function get_char() {
   global $db, $smarty, $debug;

   if (! $_REQUEST[id] or
       $_REQUEST[id] != intval($_REQUEST[id])) {
      return array('message' => 'No valid id specified');
   }
   $id = $_REQUEST[id];
   $smarty->assign('char_id', $id);

   $qry = 'SELECT char_weapons.id, weapons.name, ';
   $qry .= '      COALESCE(char_weapons.tp, weapons.tp) AS tp, ';
   $qry .= '      COALESCE(char_weapons.tpkk, weapons.tpkk) AS tpkk, ';
   $qry .= '      char_weapons.ini, ';
   $qry .= '      char_weapons.at, char_weapons.pa, char_weapons.bf ';
   $qry .= 'FROM  char_weapons, weapons ';
   $qry .= "WHERE char_weapons.character_id = $id AND ";
   $qry .= '      char_weapons.weapon_id = weapons.id ';
   $qry .= 'ORDER BY name ';
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $weapons[] = $row;
   }
   $smarty->assign('weapons', $weapons);

   $out = $smarty->fetch('div_inventory.tpl');
   return array('success' => true,
                'id'      => $id,
                'out'     => $out);
}

function show_weapon_form() {
   global $db, $smarty, $debug;

   if (! $_REQUEST[id] or
       $_REQUEST[id] != intval($_REQUEST[id])) {
      $_REQUEST[id] = 0;
   }
   if (! $_REQUEST[char_id] or
       $_REQUEST[char_id] != intval($_REQUEST[char_id])) {
      $_REQUEST[char_id] = 0;
   }

   if (! $_REQUEST[id] and ! $_REQUEST[char_id]) {
      $smarty->assign('error', 'Neither a weapon, nor a character selected');
      return;
   }

   if ($_REQUEST[id]) {
      // An edit, so retrieve values
      $qry = 'SELECT char_weapons.*, weapons.name ';
      $qry .= 'FROM  char_weapons, weapons ';
      $qry .= 'WHERE char_weapons.weapon_id = weapons.id AND ';
      $qry .= '      char_weapons.id = ' . $_REQUEST[id];
      $rid = $db->do_query($qry, true);
      $row = $db->get_array($rid);
      $smarty->assign($row);
      $smarty->assign('char_id', $row[character_id]);
   } else {
      # New weapon
      $smarty->assign('char_id', $_REQUEST[char_id]);
      $smarty->assign('id', 0);
      $weapons[0] = '-- select a weapon';
      $qry = 'SELECT id, name ';
      $qry .= 'FROM  weapons ';
      $qry .= 'ORDER BY name';
      $rid = $db->do_query($qry, true);
      while ($row = $db->get_array($rid)) {
         $weapons[$row[id]] = $row[name];
      }
      $smarty->assign('weapons', $weapons);
   }
}

function update_weapon() {
   global $db, $debug;

   if ($_REQUEST[id] and
       $_REQUEST[id] != intval($_REQUEST[id])) {
      return array('message' => 'invalid id specified');
   }
   if ($_REQUEST[char_id] and
       $_REQUEST[char_id] != intval($_REQUEST[char_id])) {
      return array('message' => 'invalid character id specified');
   }

   if ($_REQUEST[tp]) {
      if (! preg_match('#^(\d+)([dDwW])(\d+)(\+\d+)?$#', $_REQUEST[tp], $matches)) {
         return array('message' => 'invalid tp specified');
      }
      $tp = $matches[1] . 'D' . $matches[3] . $matches[4];
   }
   $tpkk = trim($_REQUEST[tpkk]);
   if ($tpkk) {
      if (! preg_match('#^\d+/\d+$#', $tpkk, $matches)) {
         return array('message' => 'invalid tpkk specified');
      }
   }
   if (! $_REQUEST[id] and (! $_REQUEST[name] or
                            intval($_REQUEST[name] != $_REQUEST[name]))) {
      return array('message' => 'No weapon selected');
   }
   $ini = trim($_REQUEST[ini]);
   if ($ini and intval($ini) != $ini) {
      return array('message' => 'invalid ini specified');
   }
   $at = trim($_REQUEST[at]);
   if ($at and intval($at) != $at) {
      return array('message' => 'invalid at specified');
   }
   $pa = trim($_REQUEST[pa]);
   if ($pa and intval($pa) != $pa) {
      return array('message' => 'invalid pa specified');
   }
   $bf = trim($_REQUEST[bf]);
   if ($bf and intval($bf) != $bf) {
      return array('message' => 'invalid bf specified');
   }
   $note = trim($_REQUEST[note]);

   if ($_REQUEST[id]) {
      # Update weapon
      $qry = 'UPDATE char_weapons SET ';
      $qry .= '      note = ' . ( ($note) ? "'" . pg_escape_string($note) . "'" : 'NULL') . ', ';
      $qry .= '      tp = ' . ( ($tp) ? "'$tp'" : 'NULL') . ', ';
      $qry .= '      tpkk = ' . ( ($tpkk) ? "'$tpkk'" : 'NULL') . ', ';
      $qry .= '      ini = ' . ( ($ini !== '') ? $ini : 'NULL') . ', ';
      $qry .= '      at = ' . ( ($at !== '') ? $at : 'NULL') . ', ';
      $qry .= '      pa = ' . ( ($pa !== '') ? $pa : 'NULL') . ', ';
      $qry .= '      bf = ' . ( ($bf !== '') ? $bf : 'NULL') . ' ';
      $qry .= 'WHERE id = ' . $_REQUEST[id];
   } else {
      # Add new weapon
      $is_new = true;
      $qry = 'INSERT INTO char_weapons (';
      $qry .= 'weapon_id, character_id, note, tp, tpkk, ini, at, pa, bf) VALUES (';
      $qry .= $_REQUEST[name] . ', ';
      $qry .= $_REQUEST[char_id] . ', ';
      $qry .= ( ($note) ? "'" . pg_escape_string($note) . "'" : 'NULL') . ', ';
      $qry .= ( ($tp) ? "'$tp'" : 'NULL') . ', ';
      $qry .= ( ($tpkk) ? "'$tpkk'" : 'NULL') . ', ';
      $qry .= ( ($ini !== '') ? $ini : 'NULL') . ', ';
      $qry .= ( ($at !== '') ? $at : 'NULL') . ', ';
      $qry .= ( ($pa !== '') ? $pa : 'NULL') . ', ';
      $qry .= ( ($bf !== '') ? $bf : 'NULL') . ')';
   }

   if (! @$db->do_query($qry)) {
      return array('message' => 'database-error' . ($debug) ? ': ' . pg_last_error() : '');
   }

   # If new, get id
   if ($is_new) {
      $_REQUEST[id] = $db->insert_id('char_weapons');
   }

   # Get correct values for tpkk, tp to return
   $qry = 'SELECT COALESCE(char_weapons.tpkk, weapons.tpkk) AS tpkk, ';
   $qry .= '      COALESCE(char_weapons.tp, weapons.tp) AS tp, ';
   $qry .= '      character_id, weapons.name ';
   $qry .= 'FROM  char_weapons, weapons ';
   $qry .= 'WHERE char_weapons.weapon_id = weapons.id AND ';
   $qry .= '      char_weapons.id = ' . $_REQUEST[id];
   list($tpkk, $tp, $char_id, $name) = $db->get_list($qry, true);

   return array('success' => true,
                'id'      => $_REQUEST[id],
                'char_id' => $char_id,
                'is_new'  => $is_new,
                'name'    => $name,
                'tp'      => $tp,
                'tpkk'    => $tpkk,
                'ini'     => $ini,
                'at'      => $at,
                'pa'      => $pa,
                'bf'      => $bf);
}

function remove_weapon() {
   global $db, $debug;

   if (! $_REQUEST[id] or
       $_REQUEST[id] != intval($_REQUEST[id])) {
      return array('message' => 'invalid id specified');
   }

   $qry = 'DELETE FROM char_weapons WHERE id = ' . $_REQUEST[id];
   if (! @$db->do_query($qry, false)) {
      return array('message' => 'database-error while deleting' . (($debug) ? ': ' . pg_last_error() : ''));
   }

   return array('success' => true,
                'id'      => $_REQUEST[id]);
}

function show_weapon_note() {
   global $db, $debug;

   if (! $_REQUEST[id] or $_REQUEST[id] != intval($_REQUEST[id])) {
      return '<b>Invalid id specified</b>';
   }

   $qry = 'SELECT char_weapons.note AS personal, weapons.note ';
   $qry .= 'FROM  char_weapons, weapons ';
   $qry .= 'WHERE char_weapons.weapon_id = weapons.id AND ';
   $qry .= '      char_weapons.id = ' . $_REQUEST[id];
   list($personal, $note) = $db->get_list($qry, true);

   if ($personal) $note = $personal . '<br /><hr /><br />' . $note;
   if (! $note) $note = 'No note defined';
   return nl2br($note);
}

switch ($_REQUEST[stage]) {
   case 'update_weapon':
      echo json_encode(update_weapon());
      break;
   case 'show_weapon_form':
      show_weapon_form();
      $smarty->display('frm_char_weapons.tpl');
      break;
   case 'remove_weapon':
      echo json_encode(remove_weapon());
      break;
   case 'get_char':
      echo json_encode(get_char());
      break;
   case 'show_weapon_note':
      echo show_weapon_note();
      break;
   default:
      show();
      $smarty->display('inventory.tpl');
}
?>
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
   $qry .= '      COALESCE(char_weapons.wm, weapons.wm) AS wm, ';
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
      $qry .= 'WHERE char_weapons.weapon_id = weapons.id';
      $rid = $db->do_query($qry, true);
      $row = $db->get_array($rid);
      $smarty->assign($row);
      $smarty->assign('char_id', $row[character_id]);
   } else {
      # New weapon
      $smarty->assign('char_id', $_REQUEST[char_id]);
      $qry = 'SELECT id, name ';
      $qry .= 'FROM  weapons ';
      $qry .= 'ORDER BY name';
      $rid = $db->do_query($qry, true);
      while ($row = $db->get_array($rid)) {
         $weapons[] = $row;
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
   $wm = trim($_REQUEST[wm]);
   if ($wm) {
      if (! preg_match('#^\d+/\d+$#', $wm)) {
         return array('message' => 'invalid wm specified');
      }
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
      $qry .= '      tp = ' . ( ($tp) ? "'$tp'" : 'NULL') . ', ';
      $qry .= '      tpkk = ' . ( ($tpkk) ? "'$tpkk'" : 'NULL') . ', ';
      $qry .= '      ini = ' . ( ($ini) ? $ini : 0) . ', ';
      $qry .= '      wm = ' . ( ($wm) ? "'$wm'" : 'NULL') . ', ';
      $qry .= '      at = ' . ( ($at) ? $at : 0) . ', ';
      $qry .= '      pa = ' . ( ($pa) ? $pa : 0) . ', ';
      $qry .= '      bf = ' . ( ($bf) ? $bf : 0) . ' ';
      $qry .= 'WHERE id = ' . $_REQUEST[id];
   } else {
      # Add new weapon
   }

   #return array('message' => $qry);
   if (! @$db->do_query($qry)) {
      return array('message' => 'database-error' . ($debug) ? ': ' . pg_last_error() : '');
   }

   # Get correct values for tpkk, wm and tp to return
   $qry = 'SELECT COALESCE(char_weapons.tpkk, weapons.tpkk) AS tpkk, ';
   $qry .= '      COALESCE(char_weapons.wm, weapons.wm) AS wm, ';
   $qry .= '      COALESCE(char_weapons.tp, weapons.tp) AS tp ';
   $qry .= 'FROM  char_weapons, weapons ';
   $qry .= 'WHERE char_weapons.weapon_id = weapons.id AND ';
   $qry .= '      char_weapons.id = ' . $_REQUEST[id];
   list($tpkk, $wm, $tp) = $db->get_list($qry, true);

   return array('success' => true,
                'id'      => $_REQUEST[id],
                'tp'      => $tp,
                'tpkk'    => $tpkk,
                'ini'     => $ini,
                'wm'      => $wm,
                'at'      => $at,
                'pa'      => $pa,
                'bf'      => $bf);
}

switch ($_REQUEST[stage]) {
   case 'update_weapon':
      echo json_encode(update_weapon());
      break;
   case 'show_weapon_form':
      show_weapon_form();
      $smarty->display('frm_char_weapons.tpl');
      break;
   case 'get_char':
      echo json_encode(get_char());
      break;
   default:
      show();
      $smarty->display('inventory.tpl');
}
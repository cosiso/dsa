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
function show() {
   global $db, $debug, $smarty;

   $qry = 'SELECT id, name ';
   $qry .= 'FROM  characters ';
   $qry .= 'ORDER BY name';
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $chars[] = $row;
   }
   $smarty->assign('chars', $chars);
}

function get_char() {
   global $db, $debug, $smarty;

   if (! check_int($_REQUEST[id], false)) {
      return array('message' => 'invalid id specified');
   }
   $char_id = $_REQUEST[id];
   $smarty->assign('char_id', $char_id);

   $qry = 'SELECT weapons.name, kampftechniken.name as technik, ';
	$qry .= '      combat_at(char_weapons.id) AS combat_at, combat_pa(char_weapons.id) AS combat_pa, ';
   $qry .= '      char_kampftechniken.at, char_kampftechniken.pa, ';
   $qry .= '      COALESCE(char_weapons.tp, weapons.tp) AS tp, ';
   $qry .= '      weapons.dk, weapons.ini, char_weapons.ini AS w_ini, ';
   $qry .= "      tot_ini($char_id) AS c_ini, ";
   $qry .= '      COALESCE(char_weapons.tpkk, weapons.tpkk) AS tpkk, ';
   $qry .= "      kk_bonus($char_id, COALESCE(char_weapons.tpkk, weapons.tpkk)) AS tp_bonus, ";
   $qry .= '      COALESCE(char_weapons.bf, weapons.bf) AS bf ';
   $qry .= 'FROM  char_weapons, weapons, kampftechniken, char_kampftechniken ';
   $qry .= "WHERE char_weapons.character_id = $char_id AND ";
   $qry .= '      char_weapons.weapon_id = weapons.id AND ';
   $qry .= '      weapons.kampftechnik_id = kampftechniken.id AND ';
   $qry .= '      char_kampftechniken.kampftechnik_id = weapons.kampftechnik_id AND  ';
   $qry .= "      char_kampftechniken.character_id = $char_id ";
   $qry .= 'ORDER BY weapons.name';
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $row[at] = $row[at] + $row[combat_at];
      $row[pa] = $row[pa] + $row[combat_pa];
      $row[ini] = $row[ini] + $row[w_ini] + $row[c_ini];
      list($die, $add) = split('\+', $row[tp]);
      $row[tp] = $die . '+' . ((int)$add + $row[tp_bonus]);
      $armed[] = $row;
   }
   $smarty->assign('armed', $armed);

   $qry = "SELECT kampftechniken.name AS kampftechnik, '10/3' AS tpkk, ";
   $qry .= "      tot_at($char_id) + char_kampftechniken.at AS at, ";
   $qry .= "      tot_pa($char_id) + char_kampftechniken.pa AS pa, ";
   $qry .= "      '1D6+0' AS roll, kk_bonus($char_id, '10/3')  AS tp_bonus, ";
   $qry .= "      tot_ini($char_id) AS ini ";
   $qry .= 'FROM  characters, char_kampftechniken, kampftechniken ';
   $qry .= "WHERE characters.id = $char_id AND ";
   $qry .= '      char_kampftechniken.character_id = characters.id AND ';
   $qry .= '      kampftechniken.id = char_kampftechniken.kampftechnik_id  AND ';
   $qry .= '      kampftechniken.unarmed = true ';
   $qry .= 'ORDER BY kampftechnik';
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      list($die, $add) = split('\+', $row[roll]);
      $row[tp] = $die . '+' . ((int)$add + $row[tp_bonus]);
      $unarmed[] = $row;
   }
   $smarty->assign('unarmed', $unarmed);

   $qry = 'SELECT char_kampf_sf.id, kampf_sf.name, kampf_sf.effect, ';
   $qry .= '      char_kampf_sf.kampf_sf_id ';
   $qry .= 'FROM  char_kampf_sf, kampf_sf ';
   $qry .= "WHERE char_kampf_sf.character_id = $char_id AND ";
   $qry .= '      char_kampf_sf.kampf_sf_id = kampf_sf.id ';
   $qry .= 'ORDER BY name';
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $sf[] = $row;
   }
   $smarty->assign('sf', $sf);
   $out = $smarty->fetch('divs/characters/combat/character.tpl');

   return array('success' => true,
                'out'     => $out,
                'id'      => $_REQUEST[id]);
}

function sf_note() {
   global $db, $debug, $smarty;

   if (! check_int($_REQUEST[sf_id], false)) {
      $smarty->assign("text", 'Error: invalid id specified');
   } else {
      $qry = 'SELECT description FROM kampf_sf WHERE id = %d';
      $qry = sprintf($qry, $_REQUEST[sf_id]);
      $smarty->assign('text', $db->fetch_field($qry, true));
   }
}

function load_sf() {
   global $db, $debug, $smarty;

   if (! check_int($_REQUEST[char_id], false)) {
      $smarty->assign('error', 'Invalid character id specified');
   } else {
      $smarty->assign('char_id', $_REQUEST[char_id]);

      $qry = 'SELECT name ';
      $qry .= 'FROM  characters ';
      $qry .= 'WHERE id = ' . $_REQUEST[char_id];
      $smarty->assign('name', $db->fetch_field($qry));

      $qry = 'SELECT id, name ';
      $qry .= 'FROM  kampf_sf ';
      $qry .= 'WHERE id NOT IN (SELECT kampf_sf_id ';
      $qry .= '                 FROM   char_kampf_sf ';
      $qry .= '                 WHERE  character_id = ' . $_REQUEST[char_id] . ') ';
      $qry .= 'ORDER BY name';
      $rid = $db->do_query($qry, true);
      $sf[0] = '-- select a kampfsonderfertigkeit';
      while ($row = $db->get_array($rid)) {
         $sf[$row[id]] = $row[name];
      }
      $smarty->assign('sf', $sf);
   }
}

function add_sf() {
   global $db, $debug;

   if (! check_int($_REQUEST[char_id], false)) {
      return array('message' => 'invalid character id specified');
   }
   if (! check_int($_REQUEST[p_sf], false)) {
      return array('message' => 'invalid kampfsonderfertigkeit');
   }

   $qry = 'INSERT INTO char_kampf_sf (character_id, kampf_sf_id) VALUES (%d, %d)';
   $qry = sprintf($qry, $_REQUEST[char_id], $_REQUEST[p_sf]);
   if (! @$db->do_query($qry, false)) {
      return array('message' => 'database-error while inserting' . ($debug) ? ': ' . pg_last_error() : '');
   }
   $id = $db->insert_id('char_kampf_sf');
   $qry = 'SELECT name, effect FROM kampf_sf WHERE id = %d';
   $qry = sprintf($qry, $_REQUEST[p_sf]);
   list($name, $effect) = $db->get_list($qry, true);

   return array('success' => true,
                'id'      => $id,
                'name'    => $name,
                'effect'  => $effect,
                'sf_id'   => $_REQUEST[p_sf],
                'char_id' => $_REQUEST[char_id]);
}

function remove_sf() {
   global $db, $debug;

   if (! check_int($_REQUEST[id], false)) {
      return array('message' => 'invalid id specified');
   }

   $qry = 'DELETE FROM char_kampf_sf WHERE id = %d';
   $qry = sprintf($qry, $_REQUEST[id]);
   if (! @$db->do_query($qry, false)) {
      return array('message' => 'database-error while deleting' . ($debug) ? ': ' . pg_last_error() : '');
   }

   return array('success' => true,
                'id'      => $_REQUEST[id]);
}

switch ($_REQUEST[stage]) {
   case 'get_char':
      echo json_encode(get_char());
      break;
   case 'load_sf':
      load_sf();
      $smarty->display('divs/characters/combat/load_sf.tpl');
      break;
   case 'add_sf':
      echo json_encode(add_sf());
      break;
   case 'sf_note':
      sf_note();
      $smarty->display('divs/large_note.tpl');
      break;
   case 'remove_sf':
      echo json_encode(remove_sf());
      break;
   default:
      show();
      $smarty->display('combat.tpl');
}
?>

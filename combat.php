<?php
# Version 1.0

require_once('config.inc.php');
require_once('db.inc.php');
require_once('smarty.inc.php');

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

   $qry = 'SELECT weapons.name, kampftechniken.name as technik, ';
	$qry .= '      combat_at(char_weapons.id) AS combat_at, combat_pa(char_weapons.pa) AS combat_pa, ';
   $qry .= '      char_kampftechniken.at, char_kampftechniken.pa, ';
   $qry .= "      calc_at($char_id) AS c_at, calc_pa($char_id)  AS c_ap, ";
   $qry .= '      COALESCE(char_weapons.tp, weapons.tp) AS tp, ';
   $qry .= '      weapons.dk, weapons.ini, char_weapons.ini AS w_ini, ';
   $qry .= "      calc_ini($char_id) AS c_ini, ";
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
   $qry .= "      calc_at($char_id) + char_kampftechniken.at AS at, ";
   $qry .= "      calc_pa($char_id) + char_kampftechniken.pa AS pa, ";
   $qry .= "      '1D6+0' AS roll, kk_bonus($char_id, '10/3')  AS tp_bonus, ";
   $qry .= "      calc_ini($char_id) AS ini ";
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

   $qry = 'SELECT id, name ';
   $qry .= 'FROM  kampf_sf ';
   $qry .= 'ORDER BY name';
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $kampf_sf[] = $row;
   }
   $smarty->assign('kampf_sf', $kampf_sf);
   $qry = 'SELECT char_kampf_sf.id, kampf_sf.name ';
   $qry .= 'FROM  char_kampf_sf, kampf_sf ';
   $qry .= "WHERE char_kampf_sf.character_id = $char_id AND ";
   $qry .= '      char_kampf_sf.kampf_sf_id = kampf_sf.id ';
   $qry .= 'ORDER BY name';
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $sf[] = $row;
   }
   $smarty->assign('sf', $sf);
   $out = $smarty->fetch('div_combat.tpl');

   return array('success' => true,
                'out'     => $out,
                'id'      => $_REQUEST[id]);
}
switch ($_REQUEST[stage]) {
   case 'get_char':
      echo json_encode(get_char());
      break;
   default:
      show();
      $smarty->display('combat.tpl');
}
?>
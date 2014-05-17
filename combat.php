<?php
# Version 1.0

require_once('config.inc.php');
require_once('db.inc.php');
require_once('smarty.inc.php');

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

   if (! $_REQUEST[id] or
       $_REQUEST[id] != intval($_REQUEST[id])) {
      return array('message' => 'invalid id specified');
   }
   $char_id = $_REQUEST[id];

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
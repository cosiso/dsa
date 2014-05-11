<?php
# Version 1.0

require_once('config.inc.php');
require_once('db.inc.php');
require_once('smarty.inc.php');

function show() {
   global $db, $debug, $smarty;

   $qry = 'SELECT weapons.*, kampftechniken.name AS kampftechnik ';
   $qry .= 'FROM  weapons, kampftechniken ';
   $qry .= 'WHERE weapons.kampftechnik_id = kampftechniken.id ';
   $qry .= 'ORDER BY name';
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $weapons[] = $row;
   }
   $smarty->assign('weapons', $weapons);

   $qry = 'SELECT id, name ';
   $qry .= 'FROM  kampftechniken ';
   $qry .= 'ORDER BY name';
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $kt[] = $row;
   }
   $smarty->assign('kt', $kt);
}

function show_form() {
   global $db, $debug, $smarty;

   if ($_REQUEST[id] and
       $_REQUEST[id] == intval($_REQUEST[id])) {
      # Retrieve values
   }
}

function update_weapon() {
   global $db, $debug;

   if ($_REQUEST[id] and
       $_REQUEST[id] != intval($_REQUEST[id])) {
      return array('message' => 'invalid id specified');
   }
   $name = trim($_REQUEST[name]);
   if (! $name) {
      return array('message' => 'invalid name specified');
   }
   $kt = trim($_REQUEST[kampftechnik]);
   if (! $kt or
       $kt != intval($kt)) {
      return array('message' => 'invalid kampftechnik specified');
   }
   $tp = trim($_REQUEST[tp]);
   if (! preg_match('#^(\d+)([dDwW])(\d+)(\+\d+)?$#', $tp, $matches)) {
      return array('message' => 'invalid TP specified');
   }
   $tp = $matches[1] . 'D' . $matches[3] . $matches[4];
   $tpkk = trim($_REQUEST[tpkk]);
   if (! preg_match('/^\d+\/\d+$/', $tpkk)) {
      return array(message => 'invalid TP/KK specified');
   }
   $gewicht = trim($_REQUEST[gewicht]) || 0;
   if ($gewicht != intval($gewicht)) {
      return array('invalid gewicht specified');
   }
   $lange = trim($_REQUEST[lange]) || 0;
   if ($lange != intval($lange)) {
      return array('message' => 'invalid länge specified');
   }
   $bf = trim($_REQUEST[bf]) || 0;
   if ($bf != intval($bf)) {
      return array('invalid BF specified');
   }
   $ini = trim($_REQUEST[ini]) || 0;
   if ($ini != intval($ini)) {
      return array('message' => 'invalid ini-wert specified');
   }
   $preis = trim($_REQUEST[preis]) || 0;
   if ($preis != intval($preis)) {
      return array('message' => 'invalid preis specified');
   }
   $wm = trim($_REQUEST[wm]);
   if (! preg_match('#^\d+/\d+$', $wm)) {
      return array('invalid WM specified');
   }
   $dk = trim($_REQUEST[dk]);
   $note = trim($_REQUEST[note]);

   if ($_REQUEST[id]) {
      # Update
      $is_new = false;
   } else {
      $is_new = true;
      $qry = 'INSERT INTO weapons ';
      $qry .= '(name, kampftechnik_id, tp, tpkk, gewicht, lange, ';
      $qry .= 'bf, ini, preis, wm, dk, note) VALUES (';
      $qry .= "'" . pg_escape_string($name) . "', ";
      $qry .= "$kt, ";
      $qry .= "'" . $tp . "', ";
      $qry .= "'" . $tpkk . "', ";
      $qry .= "$gewicht, ";
      $qry .= "$lange, ";
      $qry .= "$bf, ";
      $qry .= "$ini, ";
      $qry .= "$preis, ";
      $qry .= "'" . $wm . "', ";
      $qry .= "'" . pg_escape_string($dk) . "', ";
      $qry .= "'" . pg_escape_string($note) . "')";
   }

   return array('message' => 'dummy');
}

switch ($_REQUEST[stage]) {
   case 'update':
      echo json_encode(update_weapon());
      break;
   case 'show_form':
      show_form();
      $smarty->display('frm_weapons.tpl');
      break;
   default:
      show();
      $smarty->display('setup_weapons.tpl');
}
<?php
# Version 1.0

require('config.inc.php');
require_once('db.inc.php');
require_once('smarty.inc.php');

function show() {
   global $db, $debug, $smarty;

   $qry = 'SELECT weapons.*, kampftechniken.name AS kampftechnik ';
   $qry .= 'FROM  weapons, kampftechniken ';
   $qry .= 'WHERE weapons.kampftechnik_id = kampftechniken.id ';
   $qry .= 'ORDER BY weapons.name';
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
      $qry = 'SELECT * ';
      $qry .= 'FROM  weapons ';
      $qry .= 'WHERE id = ' . $_REQUEST[id];
      $rid = $db->do_query($qry, true);
      $row = $db->get_array($rid);
      $smarty->assign($row);
   }
}

function update_weapon() {
   global $db, $debug;

   if ($_REQUEST[id] and
       $_REQUEST[id] != intval($_REQUEST[id])) {
      return array('message' => 'invalid id specified');
   }
   $name = ucfirst(trim($_REQUEST[name]));
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
   if (! preg_match('#^\d+/\d+$#', $tpkk)) {
      return array('message' => 'invalid TP/KK specified');
   }
   $gewicht = trim($_REQUEST[gewicht]) ?: 0;
   if ($gewicht != intval($gewicht)) {
      return array('message' => 'invalid gewicht specified');
   }
   $lange = trim($_REQUEST[lange]) ?: 0;
   if ($lange != intval($lange)) {
      return array('message' => 'invalid länge specified');
   }
   $bf = trim($_REQUEST[bf]) ?: 0;
   if ($bf != intval($bf)) {
      return array('message' => 'invalid BF specified');
   }
   $ini = trim($_REQUEST[ini]) ?: 0;
   if ($ini != intval($ini)) {
      return array('message' => 'invalid ini-wert specified');
   }
   $preis = trim($_REQUEST[preis]) ?: 0;
   if ($preis != intval($preis)) {
      return array('message' => 'invalid preis specified');
   }
   $wm = trim($_REQUEST[wm]);
   if (! preg_match('#^(-)?\d+/(-)?\d+$#', $wm)) {
      return array('message' => 'invalid WM specified');
   }
   $dk = trim($_REQUEST[dk]);
   $note = trim($_REQUEST[note]);

   if ($_REQUEST[id]) {
      # Update
      $is_new = false;
      $qry = 'UPDATE weapons SET ';
      $qry .= "name = '" . pg_escape_string($name) . "', ";
      $qry .= "kampftechnik_id = $kt, ";
      $qry .= "tp = '$tp', ";
      $qry .= "tpkk = '$tpkk', ";
      $qry .= "gewicht = $gewicht, ";
      $qry .= "lange = $lange, ";
      $qry .= "bf = $bf, ";
      $qry .= "ini = $ini, ";
      $qry .= "preis = $preis, ";
      $qry .= "wm = '$wm', ";
      $qry .= "dk = '" . pg_escape_string($dk) . "', ";
      $qry .= "note = '" . pg_escape_string($note) . "' ";
      $qry .= 'WHERE id = ' . $_REQUEST[id];
   } else {
      $qry = 'SELECT id ';
      $qry .= 'FROM  weapons ';
      $qry .= "WHERE name = '" . pg_escape_string($name) . "'";
      if ($db->fetch_field($qry, false)) {
         return array('message' => 'A weapon with this name already exists');
      }
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

   if (! @$db->do_query($qry, false)) {
      return array('message' => 'database-error while updating/inserting' . ( ($debug) ? ': ' . pg_last_error() : ''));
   }
   if ($is_new) { $_REQUEST[id] = $db->insert_id('weapons'); };
   $kt = $db->fetch_field('SELECT name FROM kampftechniken WHERE id = ' . $kt);

   return array('success' => true,
                'is_new'  => $is_new,
                'id'      => $_REQUEST[id],
                'name'    => $name,
                'kt'      => $kt,
                'tp'      => $tp,
                'tpkk'    => $tpkk,
                'gewicht' => $gewicht,
                'lange'   => $lange,
                'bf'      => $bf,
                'ini'     => $ini,
                'preis'   => $preis,
                'wm'      => $wm,
                'dk'      => $dk);
}

function remove_weapon() {
   global $db, $debug;

   if (! $_REQUEST[id] or
       $_REQUEST[id] != intval($_REQUEST[id])) {
      return array('message' => 'invalid id specified');
   }
   $qry = 'DELETE FROM weapons WHERE id = ' . $_REQUEST[id];
   if (! @$db->do_query($qry, false)) {
      return array('message' => 'database-error while removing' . ( ($debug) ? ': ' . pg_last_error() : ''));
   }
   return array('success' => true,
                'id'      => $_REQUEST[id]);
}

function show_note() {
   global $db, $debug;

   if (! $_REQUEST[id] or
       $_REQUEST[id] != intval($_REQUEST[id])) {
      return array('message' => 'invalid id specified');
   }
   $qry = 'SELECT note FROM weapons WHERE id = ' . $_REQUEST[id];
   return nl2br($db->fetch_field($qry, true));
}

switch ($_REQUEST[stage]) {
   case 'note':
      echo show_note();
      break;
   case 'remove':
      echo json_encode(remove_weapon());
      break;
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
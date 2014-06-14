<?php
# Version 1.0

require_once('config.inc.php');
require_once('db.inc.php');
require_once('smarty.inc.php');

function show() {
   global $db, $debug, $smarty;

}

function show_talente() {
   global $db, $debug, $smarty;

   $qry = 'SELECT * ';
   $qry .= 'FROM  kampftechniken ';
   $qry .= 'ORDER BY name';
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $kampftechniken[] = $row;
   }
   $smarty->assign('kampftechniken', $kampftechniken);

   $out = $smarty->fetch('div_kampftechniken.tpl');

   return array('success' => true,
                'div'     => $out);
}

function frm_kampftechnik() {
   global $db, $debug, $smarty;

   if ($_REQUEST[id] and
       $_REQUEST[id] == intval($_REQUEST[id])) {
      $qry = 'SELECT * ';
      $qry .= 'FROM  kampftechniken ';
      $qry .= 'WHERE id = ' . $_REQUEST[id];
      $rid = $db->do_query($qry, true);
      $row = $db->get_array($rid);
      $row[unarmed] = ($row[unarmed] == 't') ? true : false;
      $smarty->assign($row);
   } else {
      $smarty->assign('id', 0);
   }
}

function update_kampftechnik() {
   global $db, $debug;

   $name = ucfirst(trim($_REQUEST[name]));
   if (! $name) {
      return array('message' => 'no name specified');
   }
   $skt = strtoupper(trim($_REQUEST[skt]));
   if ($skt and strlen($skt) != 1) {
      return array('message' => 'value for Kostentabelle should be 1 character');
   }
   $be = trim($_REQUEST[be]);
   if (! $be) $be = 0;
   if ($be != intval($be)) {
      return array('message' => 'invalid value for Behinderung specified');
   }
   $unarmed = isset($_REQUEST[unarmed]) ? true : false;
   if (! $_REQUEST[id]) {
      $qry = 'INSERT INTO kampftechniken ';
      $qry .= '(name, skt, be, unarmed) VALUES (';
      $qry .= "'" . pg_escape_string($name) . "', ";
      $qry .= ( ($skt) ? "'" . pg_escape_string($skt) . "'" : 'NULL') . ', ';
      $qry .= $be . ', ';
      $qry .= ( ($unarmed) ? "'t'" : "'f'") . ')';
   } else {
      $qry = 'UPDATE kampftechniken SET ';
      $qry .= "      name = '" . pg_escape_string($name) . "', ";
      $qry .= '      skt = ' . ( ($skt) ? "'" . pg_escape_string($skt) . "'" : 'NULL') . ', ';
      $qry .= "      be = $be, ";
      $qry .= "      unarmed = '" . ( ($unarmed) ? 't' : 'f') . "' ";
      $qry .= 'WHERE id = ' . $_REQUEST[id];
   }
   if (! @$db->do_query($qry, false)) {
      return array('message' => 'database-error while updating' . ($debug) ? ': ' . pg_last_error() : '');
   }
   return array('success' => true,
                'is_new'  => ($_REQUEST[id]) ? false : true,
                'id'      => ($_REQUEST[id]) ? $_REQUEST[id] : $db->insert_id('kampftechniken'),
                'name'    => $name,
                'skt'     => $skt,
                'unarmed' => $unarmed,
                'be'      => $be);
}

function remove_kampftechnik() {
   global $db, $debug;

   if (! $_REQUEST[id] or
       $_REQUEST[id] != intval($_REQUEST[id])) {
      return array('message' => 'invalid id specified');
   }

   $qry = 'DELETE FROM kampftechniken WHERE id = ' . $_REQUEST[id];
   if (! @$db->do_query($qry, false)) {
      return array('message' => 'database-error while removing' . ( ($debug) ? ': ' . pg_last_error() : ''));
   }

   return array('success' => true,
                'id'      => $_REQUEST[id]);
}
function fetch_sonderfertigkeiten() {
   global $db, $debug, $smarty;

   $qry = 'SELECT id, name, gp, ap, effect ';
   $qry .= 'FROM  kampf_sf ';
   $qry .= 'ORDER BY name';
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $sf[] = $row;
   }
   $smarty->assign('sf', $sf);

   $out = $smarty->fetch('div_kampf_sf.tpl');
   return array('success' => true,
                'out'     => $out);
}

switch ($_REQUEST[stage]) {
   case 'remove':
      echo json_encode(remove_kampftechnik());
      break;
   case 'update':
      echo json_encode(update_kampftechnik());
      break;
   case 'frm_kampftechnik':
      frm_kampftechnik();
      $smarty->display('frm_kampftechniken.tpl');
      break;
   case 'show_talente':
      echo json_encode(show_talente());
      break;
   case 'fetch_sf':
      echo json_encode(fetch_sonderfertigkeiten());
      break;
   case 'frm_sonderfertigkeit':
      echo '<b>BOO!</b>';
      break;
   default:
      show();
      $smarty->display('setup_kampftechniken.tpl');
}
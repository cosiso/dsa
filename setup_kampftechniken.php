<?php
# Version 1.0

require_once('config.inc.php');
require_once('db.inc.php');
require_once('smarty.inc.php');

function show() {
   global $db, $debug, $smarty;

}

function check_int($value, $zero=true) {
   if ($value and $value != intval($value)) {
	   return false;
	}
	if (! $value and ! $zero) {
	   return false;
	}
	return true;
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

   if (check_int($_REQUEST[id], false)) {
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
   if (! check_int($be, true)) {
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

   if (! check_int($_REQUEST[id], false)) {
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
function frm_kampf_sf() {
   global $db, $debug, $smarty;

   if (check_int($_REQUEST[id], false)) {
      # edit
      $qry = 'SELECT id, name, ap, gp, effect, description ';
      $qry .= 'FROM  kampf_sf ';
      $qry .= 'WHERE id = ' . $_REQUEST[id];
      $rid = $db->do_query($qry, true);
      $row = $db->get_array($rid);
      $smarty->assign($row);
   } else {
      # new sonderfertigkeit
      $smarty->assign('id', 0);
   }
}
function update_sf() {
   global $db, $debug;

   if (! check_int($_REQUEST[id])) {
      return array('message' => 'invalid id specified');
   }
   $name = ucfirst(trim($_REQUEST[name]));
   if (! $name) {
      return array('message' => 'no name specified');
   }
   if (! check_int($_REQUEST[ap])) {
      return array('message' => 'invalid ap specified');
   }
   if (! check_int($_REQUEST[gp])) {
      return array('message' => 'invalid gp specified');
   }
   $effect = trim($_REQUEST[effect]);
   if (! $effect) {
      return array('no effect specified');
   }
   $description = trim($_REQUEST[description]);
   if ($_REQUEST[id]) {
      # Edit sf
      $qry = 'UPDATE kampf_sf SET ';
      $qry .= "      name = '" . pg_escape_string($name) . "', ";
      $qry .= '      gp = ' . ( ($_REQUEST[gp]) ? $_REQUEST[gp] : 'NULL') . ', ';
      $qry .= '      ap = ' . ( ($_REQUEST[ap]) ? $_REQUEST[ap] : 'NULL') . ', ';
      $qry .= "      effect = '" . pg_escape_string($effect) . "', ";
      $qry .= '      description = ' . ( ($description) ? "'" . pg_escape_string($description) . "'" : 'NULL') . ' ';
      $qry .= 'WHERE id = ' . $_REQUEST[id];
      if (! @$db->do_query($qry, false)) {
         $ret = array('message' => 'database-error while updating' . ($debug) ? ': ' . pg_last_error() : '');
      } else {
         $ret = array('success' => true,
                      'id'      => $_REQUEST[id],
                      'name'    => $name,
                      'gp'      => $_REQUEST[gp],
                      'ap'      => $_REQUEST[ap],
                      'effect'  => $effect,
                      'is_new'  => false);
      }
   } else {
      # Add sf
      $qry = 'INSERT INTO kampf_sf ';
      $qry .= '(name, gp, ap, effect, description) VALUES (';
      $qry .= "'" . pg_escape_string($name) . "', ";
      $qry .= ( ($_REQUEST[gp]) ? $_REQUEST[gp] : 'NULL') . ', ';
      $qry .= ( ($_REQUEST[ap]) ? $_REQUEST[ap] : 'NULL') . ', ';
      $qry .= "'" . pg_escape_string($effect) . "', ";
      $qry .= ( ($description) ? "'" . pg_escape_string($description) . "'" : 'NULL') . ')';
      if (! @$db->do_query($qry, false)) {
         $ret = array('message' => 'database-error while inserting' . ($debug) ? ': ' . pg_last_error() : '');
      } else {
         $id = $db->insert_id('kampf_sf');
         $ret = array('success' => true,
                      'id'      => $id,
                      'name'    => $name,
                      'gp'      => $_REQUEST[gp],
                      'ap'      => $_REQUEST[ap],
                      'effect'  => $effect,
                      'is_new'  => true);
      }
   }
   return $ret;
}
function remove_sf() {
   global $db, $debug;

   if (! check_int($_REQUEST[id], false)) {
      return array('message' => 'invalid id specified');
   }
   $qry = 'DELETE FROM kampf_sf WHERE id = ' . $_REQUEST[id];
   if (! @$db->do_query($qry, false)) {
      return array('message' => 'database-error while deleting' . ($debug) ? ': ' . pg_last_error() : '');
   }
   return array('success' => true,
                'id'      => $_REQUEST[id]);
}
function note_sf() {
   global $db, $debug;

   if (! check_int($_REQUEST[id], false)) {
      return 'No data: invalid id specified';
   }

   $qry = 'SELECT description ';
   $qry .= 'FROM  kampf_sf ';
   $qry .= 'WHERE id = ' . $_REQUEST[id];
   return nl2br($db->fetch_field($qry, true));
}
switch ($_REQUEST[stage]) {
   case 'note_sf':
      echo note_sf();
      break;
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
      frm_kampf_sf();
      $smarty->display('frm_kampf_sf.tpl');
      break;
   case 'update_sf':
      echo json_encode(update_sf());
      break;
   case 'remove_sf':
      echo json_encode(remove_sf());
      break;
   default:
      show();
      $smarty->display('setup_kampftechniken.tpl');
}
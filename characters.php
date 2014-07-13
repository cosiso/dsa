<?php
#  Version 1.0

require_once('config.inc.php');
require_once('db.inc.php');
require_once('smarty3.inc.php');

function show() {
   global $db, $smarty, $debug;

   # Get list of characters to display in left menu
   $qry .= 'SELECT id, name ';
   $qry .= 'FROM   characters ';
   $qry .= 'ORDER BY name';
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $chars[] = $row;
   }
   $smarty->assign('chars', $chars);
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

function retrieve_base() {
   global $db, $smarty, $debug;

   # Basiswerte
   $qry = 'SELECT characters.id AS char_id, characters.name, basevalues.*, ';
   $qry .= '      tot_le(characters.id) AS tot_le, tot_au(characters.id) AS tot_au, ';
   $qry .= '      tot_ae(characters.id) AS tot_ae, tot_mr(characters.id) AS tot_mr, ';
   $qry .= '      tot_ini(characters.id) AS tot_ini, tot_at(characters.id) AS tot_at, ';
   $qry .= '      tot_pa(characters.id) AS tot_pa, tot_fk(characters.id) AS tot_fk ';
   $qry .= 'FROM characters LEFT JOIN basevalues ON basevalues.character_id = characters.id ';
   $qry .= 'ORDER BY characters.name';
   $rid = @$db->do_query($qry, false);
   if (! $rid) {
      return array('message' => 'database-error' . ($debug) ? ': ' . pg_last_error() : '');
   }
   while ($row = $db->get_array($rid)) {
      $chars[] = $row;
   }
   $smarty->assign('chars', $chars);

   # Eigenschafte
   $qry = 'SELECT id, name, ';
   $qry .= '      calc_mu(id) AS mu, calc_kl(id) AS kl, ';
   $qry .= '      calc_in(id) AS in, calc_ch(id) AS ch, ';
   $qry .= '      calc_ff(id) AS ff, calc_ge(id) AS ge, ';
   $qry .= '      calc_ko(id) AS ko, calc_kk(id) AS kk ';
   $qry .= 'FROM  characters ';
   $qry .= 'ORDER BY name';
   $rid = @$db->do_query($qry, false);
   if (! $rid) {
      return array('message' => 'database-error' . ($debug) ? ': ' . pg_last_error() : '');
   }
   while ($row = $db->get_array($rid)) {
      $traits[] = $row;
   }
   $smarty->assign('traits', $traits);

   $out = $smarty->fetch('templates/divs/char_eigenschaften.tpl');
   return array('success' => true,
                'out'     => $out);
}

function get_name() {
   global $db, $debug, $smarty;

   if (! check_int($_REQUEST[id], false)) {
      return array('message' => 'invalid id specified');
   }

   $qry = 'SELECT name FROM characters WHERE id = %d';
   $name = $db->fetch_field(sprintf($qry, $_REQUEST[id]), true);

   $smarty->assign('id', $_REQUEST[id]);
   $smarty->assign('name', $name);
   return array('success' => true,
                'out'     => $smarty->fetch('templates/divs/char_get_name.tpl'));
}

function set_name() {
   global $db, $debug;

   if (! check_int($_REQUEST[id], false)) {
      return array('message' => 'invalid id specified');
   }

   $name = trim($_REQUEST[name]);
   if (! $name) {
      return array('message' => 'no name specified');
   }

   $qry = "UPDATE characters SET name = '%s' WHERE id = %d";
   $qry = sprintf($qry, pg_escape_string($name), $_REQUEST[id]);
   if (! @$db->do_query($qry, false)) {
      return array('message' => 'database-error' . ($debug) ? " -- $qry -- " . ': ' . pg_last_error() : '');
   }

   return array('success' => true,
                'id'      => $_REQUEST[id],
                'name'    => $name);
}

switch ($_REQUEST[stage]) {
   case 'set_name':
      echo json_encode(set_name());
      break;
   case 'get_name':
      echo json_encode(get_name());
      break;
   case 'retrieve_base':
      echo json_encode(retrieve_base());
      break;
   default:
      show();
      $smarty->display('characters.tpl');
}
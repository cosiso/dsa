<?php
#  Version 1.0

require_once('db.inc.php');
require_once('smarty.inc.php');
require_once('xajax.inc.php');

$xajax->registerFunction('new_character');
$xajax->registerFunction('remove_character');
$xajax->registerFunction('show_general');
$xajax->registerFunction('save_general');
$xajax->processRequests();
$smarty->assign('xajax_script', $xajax->getJavascript('xajax'));

function show_general($char_id) {
   global $db, $smarty;

   $or = new xajaxResponse;

   if (! $char_id or ! ctype_digit($char_id)) {
      $or->addAlert('Invalid id of character');
      return $or;
   }

   # Get values
   $qry = 'SELECT * FROM characters WHERE id = ' . $char_id;
   $rid = @$db->do_query($qry, false);
   if (! $rid) {
      $or->addAlert('Database-error while retrieving general values');
      return $or;
   }
   $row = $db->get_array($rid);
   # templates uses field char_name
   $row[char_name] = $row[name];
   $smarty->assign($row);
   # Fill div
   $out = $smarty->fetch('div_char_general.tpl');
   $or->addAssign('div_char', 'innerHTML', $out);
   return $or;
}
function save_general($dta) {
   global $db;

   $or = new xajaxResponse;

   if (! $dta[id] or ! ctype_digit($dta[id])) {
      $or->addAlert('Invalid id of character');
      return $or;
   }
   $name = trim($dta[char_name]);
   if (! $name) {
      $or->addAlert('Empty name supplied');
      return $or;
   }
   if ($dta[gp_base] and ! ctype_digit($dta[gp_base])) {
      $or->addAlert('Invalid GP-Base (should be integer)');
      return $or;
   }
   if ($dta[age] and ! ctype_digit($dta[age])) {
      $or->addAlert('Invalid age (should be integer)');
      return $or;
   }
   $qry = 'UPDATE characters SET ';
   $qry .= "   name = '" . pg_escape_string($name) . "', ";
   $qry .= '   gp_base = ' . (($dta[gp_base]) ? $dta[gp_base] : '0') . ', ';
   $qry .= "   race = '" . pg_escape_string($dta[race]) . "', ";
   $qry .= "   culture = '" . pg_escape_string($dta[culture]) . "', ";
   $qry .= "   profession = '" . pg_escape_string($dta[profession]) . "', ";
   $qry .= "   sex = '" . pg_escape_string($dta[sex]) . "', ";
   $qry .= '   age = ' . (($dta[age]) ? $dta[age] : '0') . ', ';
   $qry .= "   height = '" . pg_escape_string($dta[height]) . "', ";
   $qry .= "   weight = '" . pg_escape_string($dta[weight]) . "' ";
   $qry .= 'WHERE id = ' . $dta[id];
   if (! @$db->do_query($qry, false)) {
      $or->addAlert('Database-error while updating character: ' . $qry);
      return $or;
   }
   $or->addAlert('Character ' . $name . ' saved');
   return $or;
}
function remove_character($char_id) {
   global $db;

   $or = new xajaxResponse;

   if (! $char_id or ! ctype_digit($char_id)) {
      $or->addAlert('Invalid id of character');
      return $or;
   }

   $qry = 'DELETE FROM characters WHERE id = ' . $char_id;
   if (! @$db->do_query($qry, false)) {
      $or->addAlert('Database-error while removing character');
      return $or;
   }
   $or->addScriptCall('do_remove_char', $char_id);
   return $or;
}
function new_character($name) {
   global $db;

   $or = new xajaxResponse;

   $name = trim($name);
   if (! $name) {
      $or->addAlert('No name entered');
      return $or;
   }

   $qry = 'INSERT INTO characters ';
   $qry .= '(name) VALUES (';
   $qry .= "'" . pg_escape_string($name) . "')";
   if (! @$db->do_query($qry, false)) {
      $or->addAlert('Database error while saving character');
      return $or;
   }
   $or->addScriptCall('do_new_character', $db->insert_id('characters'), $name);
   return $or;
}
function show() {
   global $db, $smarty;

   $qry = 'SELECT id, name ';
   $qry .= 'FROM  characters ';
   $qry .= 'ORDER BY name';
   $rid = $db->do_query($qry, false);
   while ($row = $db->get_array($rid)) {
      $characters[] = $row;
   }
   $smarty->assign('characters', $characters);
}
switch ($_REQUEST[stage]) {
   default:
      show();
      $smarty->display('characters.tpl');
}
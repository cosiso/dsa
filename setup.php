<?php
#  Version 1.0

require_once('db.inc.php');
require_once('smarty.inc.php');
require_once('xajax.inc.php');

$xajax->registerFunction('add_trait');
$xajax->registerFunction('remove_trait');
$xajax->processRequests();
$smarty->assign('xajax_script', $xajax->getJavascript('xajax'));

function show() {
   global $db, $smarty;

   $qry = 'SELECT * FROM traits ORDER BY name';
   $rid = $db->do_query($qry);
   while ($row = $db->get_array($rid))
      $traits[] = $row;
   $smarty->assign('traits', $traits);
}
function remove_trait($trait_id) {
   global $db;

   $or = new xajaxResponse;

   if (! $trait_id or ! ctype_digit($trait_id)) {
      $or->addAlert('Invalid id for trait specified');
      return $or;
   }
   if (! @$db->do_query("DELETE FROM traits WHERE id = $trait_id", false)) {
      $or->addAlert('Database error while removing trait');
      return $or;
   }
   $or->addScriptCall('do_remove_trait', $trait_id);
   return $or;
}
# Function add_trait will also be called for edits
function add_trait($trait_id, $name, $abbr) {
   global $db;

   $or = new xajaxResponse;

   if (! $trait_id or ! ctype_digit($trait_id))
      $trait_id = 0;

   $new_trait = trim($name);
   if ($new_trait == '') {
      $or->addAlert('Empty trait specified, ignoring');
      return $or;
   }
   $abbr = strtoupper(trim($abbr));
   if ($abbr == '') {
      $or->addAlert('Empty abbreviation specified, ignoring');
      return $or;
   }
   if (strlen($abbr) > 3) {
      $or->addAlert('Abbreviation has a maximum of three characters, ignoring');
      return $or;
   }

   if (! $trait_id) {
      $qry = 'INSERT INTO traits ';
      $qry .= '(name, abbr) VALUES (';
      $qry .= "'" . pg_escape_string($new_trait) . "', ";
      $qry .= "'" . pg_escape_string($abbr) . "')";
      if (! @$db->do_query($qry, false)) {
         $or->addAlert('Database-error: could not insert new trait');
         return $or;
      }
      $or->addScriptCall('do_add_trait', $db->insert_id('traits'), $new_trait, $abbr);
   } else {
      $qry = 'UPDATE traits SET ';
      $qry .= "name = '" . pg_escape_string($new_trait) . "', ";
      $qry .= "abbr = '" . pg_escape_string($abbr) . "' ";
      $qry .= "WHERE id = $trait_id";
      if (! @$db->do_query($qry, false)) {
         $or->addAlert('Database-error: could not update trait');
         return $or;
      }
      $or->addScriptCall('do_edit_trait', $trait_id, $new_trait, $abbr);
   }
   return $or;
}
switch ($_REQUEST[stage]) {
   default:
      show();
      $smarty->display('setup.tpl');
}
?>

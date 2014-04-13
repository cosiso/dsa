<?php
#  Version 1.0

require_once('config.inc.php');
require_once('db.inc.php');
require_once('smarty.inc.php');

function show($char_id = 0) {
   global $db, $smarty, $debug;

   # Get list of characters to display in left menu
   $qry .= 'SELECT id, name ';
   $qry .= 'FROM   characters ';
   $qry .= 'ORDER BY name';
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $characters[] = $row;
      if (! $char_id) $char_id = $row[id];
   }
   $smarty->assign('characters', $characters);

}
switch ($_REQUEST[stage]) {
   case 'new':
      $id = add_character($_REQUEST[name]);
      show($id);
      $smarty->display('characters.tpl');
      break;
   default:
      show();
      $smarty->display('characters.tpl');
}
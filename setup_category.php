<?php
#  Version 1.0

# Bork immediately if there is no cat_id
if ( ! $_REQUEST[cat_id] or intval($_REQUEST[cat_id]) != $_REQUEST[cat_id]) {?>
   <script type="text/javascript">
      alert('ERROR: No valid id!');
      history.go(-1);
   </script><?php
   exit;
}

require_once('config.inc.php');
require_once('db.inc.php');
require_once('smarty.inc.php');

function show() {
   global $db, $smarty, $debug;

   $smarty->assign('cat_id', $_REQUEST[cat_id]);
   # Get categories (for menu)
   $qry = 'SELECT id, name ';
   $qry .= 'FROM  talenten_cat ';
   $qry .= 'ORDER BY name';
   $rid = $db->do_query($qry);
   while ($row = $db->get_array($rid)) {
      $categories[] = $row;
      if ($row[id] == $_REQUEST[cat_id]) {
         $category_name = $row[name];
      }
   }
   $smarty->assign('categories', $categories);
   $smarty->assign('category_name', $category_name);
   # Get talente
   $qry = 'SELECT talente.id, talente.name, talente.be, ';
   $qry .= '      talente.komp, trait1.abbr eigenschaft1, talente.skt, ';
   $qry .= '      trait2.abbr eigenschaft2, trait3.abbr eigenschaft3 ';
   $qry .= 'FROM  talente ';
   $qry .= '      INNER JOIN traits trait1 ON (eigenschaft1 = trait1.id) ';
   $qry .= '      INNER JOIN traits trait2 ON (eigenschaft2 = trait2.id) ';
   $qry .= '      INNER JOIN traits trait3 ON (eigenschaft3 = trait3.id) ';
   $qry .= "WHERE category = {$_REQUEST[cat_id]} ";
   $qry .= 'ORDER BY name';
   $rid = $db->do_query($qry);
   while ($row = $db->get_array($rid)) {
      $talente[] = $row;
   }
   $smarty->assign('talente', $talente);
   # Get traits
   $qry = 'SELECT id, abbr, name ';
   $qry .= 'FROM  traits ';
   $qry .= 'ORDER BY name';
   $rid = $db->do_query($qry);
   while ($row = $db->get_array($rid)) {
      $traits[] = $row;
   }
   $smarty->assign('traits', $traits);
}
switch ($_REQUEST[stage]) {
   default:
      show();
      $smarty->display('setup_category.tpl');
}
?>
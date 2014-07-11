<?php
require_once('config.inc.php');
require_once('db.inc.php');
require_once('smarty.inc.php');

function check_int($value, $zero=true) {
   if ($value and $value != intval($value)) {
	   return false;
	}
	if (! $value and ! $zero) {
	   return false;
	}
	return true;
}

function show() {
   global $db, $smarty, $debug;

   if (! check_int($_REQUEST[talent_id], true)) {
      $smarty->assign('error', 'Invalid id specified');
   }
   if (! check_int($_REQUEST[category_id], false)) {
      $smarty->assign('error', 'Invalid category specified');
   }

   $smarty->assign('talent_id', ($_REQUEST[talent_id]) ? $_REQUEST[talent_id] : 0);
   $smarty->assign('category_id', $_REQUEST[category_id]);

   $traits[''] = '-- Select an eigenschaft';
   $qry = 'SELECT id, name FROM traits ORDER BY name';
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $traits[$row[id]] = $row[name];
   }
   $smarty->assign('traits', $traits);

   if ($_REQUEST[talent_id]) {
      $qry = 'SELECT * FROM talente WHERE id = %d';
		$rid = $db->do_query(sprintf($qry, $_REQUEST[talent_id]));
		$row = $db->get_array($rid);
		$smarty->assign($row);
   }
}

function edit() {
   global $db, $debug;

   if (! check_int($_REQUEST[talent_id], true)) {
      return array('message' => 'invalid id specified');
   }
   if (! check_int($_REQUEST[eigenschaft1], false)) {
      return array('message' => 'invalid eigenschaft1 specified');
   }
   if (! check_int($_REQUEST[eigenschaft2], false)) {
      return array('message' => 'invalid eigenschaft2 specified');
   }
   if (! check_int($_REQUEST[eigenschaft3], false)) {
      return array('message' => 'invalid eigenschaft3 specified');
   }
   $name = ucfirst(trim($_REQUEST[name]));
   if (! $name) {
      return aray('no name specified');
   }
   $be = trim($_REQUEST[be]);
   $komp = trim($_REQUEST[komp]);
   $skt = strtoupper(trim($_REQUEST[skt]));

   if ($_REQUEST[talent_id]) {
      # update
      $qry = "UPDATE talente SET name = '%s', be = '%s', komp = '%s', eigenschaft1 = %d, ";
		$qry .= "eigenschaft2 = %d, eigenschaft3 = %d, category = %d, skt = '%s' WHERE id = %d";
		$qry = sprintf($qry, pg_escape_string($name),
							      pg_escape_string($be),
									pg_escape_string($komp),
									$_REQUEST[eigenschaft1],
									$_REQUEST[eigenschaft2],
									$_REQUEST[eigenschaft3],
									$_REQUEST[category_id],
									pg_escape_string($skt),
									$_REQUEST[talent_id]);
		if (! @$db->do_query($qry, false)) {
			return array('message' => 'database-error while updating' . ($debug) ? ': ' . pg_last_error() : '');
		}
   } else {
      # insert
      $qry = "INSERT INTO talente (name, be, komp, eigenschaft1, eigenschaft2, eigenschaft3, category, skt) VALUES ('%s', '%s', '%s', %d, %d, %d, %d, '%s')";
      $qry = sprintf($qry, pg_escape_string($name),
                           pg_escape_string($be),
                           pg_escape_string($komp),
                           $_REQUEST[eigenschaft1],
                           $_REQUEST[eigenschaft2],
                           $_REQUEST[eigenschaft3],
                           $_REQUEST[category_id],
                           pg_escape_string($skt));
      if (! @$db->do_query($qry, false)) {
         return array('message' => 'database-error while inserting' . ($debug) ? ': ' . pg_last_error() : '');
      }
      $_REQUEST[talent_id] = $db->insert_id('talente');
		$is_new = true;
   }
   $qry = "SELECT t1.abbr, t2.abbr, t3.abbr FROM traits t1, traits t2, traits t3 WHERE t1.id = %d AND t2.id = %d AND t3.id = %d";
	$qry = sprintf($qry, $_REQUEST[eigenschaft1], $_REQUEST[eigenschaft2], $_REQUEST[eigenschaft3]);
	list($eigenschaft1, $eigenschaft2, $eigenschaft3) = $db->get_list($qry, true);

	return array('success' => true,
                'id'      => $_REQUEST[talent_id],
                'is_new'  => $is_new ? true : false,
                'name'    => $name,
                'be'      => $be,
                'komp'    => $komp,
                'eig1'    => $eigenschaft1,
                'eig2'    => $eigenschaft2,
                'eig3'    => $eigenschaft3,
                'skt'     => $skt);
}

switch ($_REQUEST[stage]) {
   case 'edit':
      echo json_encode(edit());
      break;
   default:
      show();
      $smarty->display('divs/talente.tpl');
}
?>
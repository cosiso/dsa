<?php
require_once('config.inc.php');
require_once('db.inc.php');
require_once('smarty3.inc.php');

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
   global $db, $debug, $smarty;

   $qry = 'SELECT id, name FROM talenten_cat ORDER BY name';
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $categories[] = $row;
   }
   $smarty->assign('categories', $categories);
}

function show_talente() {
   global $db, $debug, $smarty;

	if (! check_int($_REQUEST['id'], false)) {
		$smarty->assign('error', 'Invalid id specified');
		return;
	}

	$qry = 'SELECT t.id, t.name, t.be, tr1.id AS id1, tr2.id AS id2, ' .
	   'tr3.id AS id3, tr1.abbr AS eig1, tr2.abbr AS eig2, tr3.abbr AS eig3 ' .
		'FROM talente t, traits tr1, traits tr2, traits tr3 WHERE t.category = %d AND ' .
		' tr1.id = t.eigenschaft1 AND tr2.id = t.eigenschaft2 AND tr3.id = t.eigenschaft3 ' .
		'ORDER BY t.name';
	$rid = $db->do_query(sprintf($qry, $_REQUEST['id']), true);
	while ($row = $db->get_array($rid)) {
		$chars = array();
		$qry = 'SELECT characters.name, char_talente.value, char_talente.note, char_talente.id, ' .
		   '%s(characters.id) AS e1, %s(characters.id) AS e2, %s(characters.id) AS e3 ' .
		   'FROM characters, char_talente WHERE char_talente.talent_id = %d AND ' .
			'characters.id = char_talente.character_id ORDER BY characters.name';
		$qry = sprintf($qry, 'calc_' . strtolower($row['eig1']),
							      'calc_' . strtolower($row['eig2']),
									'calc_' . strtolower($row['eig3']),
									$row['id']);
		$rid2 = $db->do_query($qry, true);
		while ($row2 = $db->get_array($rid2)) {
			$chars[] = $row2;
		}
		$row['chars'] = $chars;
		$talente[] = $row;
	}
	$smarty->assign('talente', $talente);
}

function show_add_form() {
	global $db, $debug, $smarty;

	if (! check_int($_REQUEST['id'], false)) {
		$smarty->assign('error', 'Invalid id specified');
		return;
	}
	$smarty->assign('id', $_REQUEST['id']);

	$qry = 'SELECT id, name FROM characters WHERE id NOT IN (SELECT character_id FROM char_talente WHERE talent_id = %d) ORDER BY name';
	$rid = $db->do_query(sprintf($qry, $_REQUEST['id']), true);
	if (! $db->num_rows($rid)) {
		$smarty->assign('error', 'All characters already have this talent');
		return;
	}
	$chars[''] = '-- Select a character';
	while ($row = $db->get_array($rid)) {
		$chars[$row['id']] = $row['name'];
	}
	$smarty->assign('characters', $chars);
}

function add() {
	global $db, $debug;

	if (! check_int($_REQUEST['character_id'], false) or
		 ! check_int($_REQUEST['talent_id'], false)) {
		return array('message' => 'invalid id ' . $_REQUEST['character_id'] . '/' . $_REQUEST['talent_id'] . ' specified');
	}
	if (! check_int($_REQUEST['value'], true)) {
		return array('message' => 'invalid value specified');
	}
	$value = (intval($_REQUEST['value'])) ? $_REQUEST['value'] : 0;
	$note = trim($_REQUEST['note']);

	$qry = 'SELECT id FROM char_talente WHERE character_id = %d AND talent_id = %d';
	if ($db->fetch_field(sprintf($qry, $_REQUEST['character_id'], $_REQUEST['talent_id']), true)) {
		return array('message' => 'this character already has that talent');
	}

	$qry = 'INSERT INTO char_talente (character_id, talent_id, value, note) VALUES (%d, %d, %d, %s)';
	$qry = sprintf($qry, $_REQUEST['character_id'], $_REQUEST['talent_id'], $value, (( $note) ? "'" . pg_escape_string($note) . "'" : 'NULL'));
	if (! @$db->do_query($qry, false)) {
		return array('message' => 'database-error' . ($debug) ? ': ' . pg_last_error() : '');
	}
	$id = $db->insert_id('char_talente');

	# Find used eigenschaften
	$qry = 'SELECT t1.abbr, t2.abbr, t3.abbr FROM talente, traits t1, traits t2, traits t3 WHERE ' .
	   't1.id = talente.eigenschaft1 AND t2.id = talente.eigenschaft2 AND t3.id = talente.eigenschaft3 AND ' .
		'talente.id = %d';
	$qry = sprintf($qry, $_REQUEST['talent_id']);
	list($abbr1, $abbr2, $abbr3) = $db->get_list($qry, true);
	# Find values for character in those eigenschaften
	$qry = 'SELECT characters.name, %s(characters.id) AS e1, %s(characters.id) AS e2, %s(characters.id) AS e3 ' .
		   'FROM characters WHERE characters.id = %d';
	$qry = sprintf($qry, 'calc_' . strtolower($abbr1),
								'calc_' . strtolower($abbr2),
								'calc_' . strtolower($abbr3),
								$_REQUEST['character_id']);
	list($name, $eig1, $eig2, $eig3) = $db->get_list($qry, true);
	return array('success'      => true,
					 'character_id' => $_REQUEST['character_id'],
					 'talent_id'    => $_REQUEST['talent_id'],
					 'value'        => $value,
					 'name'         => $name,
					 'eig1'         => $eig1,
					 'eig2'         => $eig2,
					 'eig3'         => $eig3,
					 'note'         => $note,
					 'ct_id'        => $id);
}

function update_ct() {
	global $db, $debug;

	if (! check_int($_REQUEST['id'], false)) {
		return array('message' => 'invalid id specified');
	}

	if (! check_int($_REQUEST['value'], true)) {
		return array('message' => 'invalid value specified');
	}
	$value = ($_REQUEST['value']) ? $_REQUEST['value'] : 0;

	$qry = 'UPDATE char_talente SET value = %d WHERE id = %d';
	if (! @$db->do_query(sprintf($qry, $value, $_REQUEST['id']), false)) {
		return array('message' => 'database-error' . ($debug) ? ': ' . pg_last_error() : '');
	}
	return array('success' => true);
}

function show_note() {
	global $db, $debug, $smarty;

	if (! check_int($_REQUEST['id'], false)) {
		$smarty->assign('error', 'Invalid id specified');
	}

	$qry = 'SELECT note FROM char_talente WHERE id = %d';
	$note = $db->fetch_field(sprintf($qry, $_REQUEST['id']), true);
	$smarty->assign('ct_id', $_REQUEST['id']);
	$smarty->assign('note', $note);
}

function edit_note() {
	global $db, $debug;

	if (! check_int($_REQUEST['id'], false)) {
		return array('message' => 'invalid id specified');
	}
	$note = trim($_REQUEST['note']);

	$qry = 'UPDATE char_talente SET note = %s WHERE id = %d';
	$qry = sprintf($qry, ($note) ? "'" . pg_escape_string($note) . "'" : 'NULL', $_REQUEST['id']);
	if (! @$db->do_query($qry, false)) {
		return array('message' => 'database-error' . ($debug) ? ': ' . pg_last_error() : '');
	}

	return array('success' => true,
					 'id'      => $_REQUEST['id'],
					 'note'    => $note);
}

function remove() {
	global $db, $debug;

	if (! check_int($_REQUEST['id'], false)) {
		return;
	}

	$qry = 'DELETE FROM char_talente WHERE id = %d';
	$db->do_query(sprintf($qry, $_REQUEST['id']), true);
}

switch ($_REQUEST['stage']) {
   case 'show_talente':
      show_talente();
      $smarty->display('divs/characters/talente/show.tpl');
      break;
	case 'update_ct':
		echo json_encode(update_ct());
		break;
	case 'show-note':
		show_note();
		$smarty->display('divs/characters/talente/form-note.tpl');
		break;
	case 'edit-note':
		echo json_encode(edit_note());
		break;
	case 'form-add':
		show_add_form();
		$smarty->display('divs/characters/talente/form-add.tpl');
		break;
	case 'add':
		echo json_encode(add());
		break;
	case 'remove':
		remove();
		break;
   default:
      show();
      $smarty->display('char_talente.tpl');
}
?>
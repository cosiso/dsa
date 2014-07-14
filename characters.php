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

   $out = $smarty->fetch('templates/divs/characters/eigenschaften.tpl');
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
function get_eigenschaft() {
   global $db, $debug, $smarty;

   if (! check_int($_REQUEST[id], false)) {
      $smarty->assign('error', 'Invalid id specified');
   } else {
      $_REQUEST[eigenschaft] = trim($_REQUEST[eigenschaft]);
      $qry = 'SELECT %s(character_id), %s, %s FROM basevalues WHERE character_id = ' . $_REQUEST[id];
      switch ($_REQUEST[eigenschaft]) {
         case 'Lebenspunkte':
            $qry = sprintf($qry, 'base_le', 'le_mod', 'le_bought');
            break;
         case 'Ausdauer':
            $qry = sprintf($qry, 'base_au', 'au_mod', 'au_bought');
            break;
         case 'Astralenergie':
            $qry = sprintf($qry, 'base_ae', 'ae_mod', 'ae_bought');
            break;
         case 'Magieresistenz':
            $qry = sprintf($qry, 'base_mr', 'mr_mod', 'mr_bought');
            break;
         case 'Initiativ':
            $qry = sprintf($qry, 'base_ini', 'ini_mod', "'--'");
            break;
         case 'Attack':
            $qry = sprintf($qry, 'base_at', 'at_mod', "'--'");
            break;
         case 'Parry':
            $qry = sprintf($qry, 'base_pa', 'pa_mod', "'--'");
            break;
         case 'Fernkampf':
            $qry = sprintf($qry, 'base_fk', 'fk_mod', "'--'");
            break;
         default:
            $smarty->assign('error', 'Invalid eigenschaft ' . htmlspecialchars($_REQUEST[eigenschaft]) . ' specified');
            $error = true;
      }
      if (! $error) {
         $smarty->assign('id', $_REQUEST[id]);
         $smarty->assign('eigenschaft', $_REQUEST[eigenschaft]);
         $qry = sprintf($qry, $_REQUEST[id]);
         list($base, $mod, $bought) = $db->get_list($qry, true);
         $smarty->assign('base', $base);
         $smarty->assign('mod', $mod);
         $smarty->assign('bought', $bought);
      }
   }
}
function edit_eigenschaft() {
   global $db, $debug;

   if (! check_int($_REQUEST[id], false)) {
      return array('message' => 'invalid id specified');
   }
   if (! check_int($_REQUEST[modifier], true)) {
      return array('message' => 'invalid value for modifier');
   }
   if (! check_int($_REQUEST[bought], true)) {
      return array('message' => 'invalid value for bought specified');
   }
   $eigenschaft = trim($_REQUEST[eigenschaft]);
   switch ($eigenschaft) {
         case 'Lebenspunkte':
            $col1 = 'le_mod'; $col2 = 'le_bought'; $ret = 'tot_le'; $eig = 'le';
            break;
         case 'Ausdauer':
            $col1 = 'au_mod'; $col2 = 'au_bought'; $ret = 'tot_au'; $eig = 'au';
            break;
         case 'Astralenergie':
            $col1 = 'ae_mod'; $col2 = 'ae_bought'; $ret = 'tot_ae'; $eig = 'ae';
            break;
         case 'Magieresistenz':
            $col1 = 'mr_mod'; $col2 = 'mr_bought'; $ret = 'tot_mr'; $eig = 'mr';
            break;
         case 'Initiativ':
            $col1 = 'ini_mod'; $ret = 'tot_ini'; $eig = 'ini';
            break;
         case 'Attack':
            $col1 = 'at_mod'; $ret = 'tot_at'; $eig = 'at';
            break;
         case 'Parry':
            $col1 = 'pa_mod'; $ret = 'tot_pa'; $eig = 'pa';
            break;
         case 'Fernkampf':
            $col1 = 'fk_mod'; $ret = 'tot_fk'; $eig = 'fk';
            break;
      default:
         return array('message' => 'invalid eigenschaft specified');
   }
   $mod = ($_REQUEST[modifier]) ? $_REQUEST[modifier] : 'NULL';
   $bought = ($_REQUEST[bought]) ? $_REQUEST[bought] : 'NULL';
   $qry = "UPDATE basevalues SET $col1 = $mod";
   if ($col2) {
      $qry .= ", $col2 = $bought";
   }
   $qry .= ' WHERE character_id = ' . $_REQUEST[id];
   if (! @$db->do_query($qry, false)) {
      return array('message' => 'database-error' . ($debug) ? ': ' . pg_last_error() : '');
   }
   // Retrieve new total
   $qry = "SELECT $ret(" . $_REQUEST[id] . ")";
   $value = $db->fetch_field($qry, true);

   return array('success'     => true,
                'id'          => $_REQUEST[id],
                'eigenschaft' => $eig,
                'value'       => $value);
}

function new_char() {
   global $db, $debug;

   $name = trim($_REQUEST[name]);
   if (! $name) return;

   $qry = "INSERT INTO characters (name) VALUES ('%s')";
   $db->do_query(sprintf($qry, $name), true);
}

function remove_char() {
   global $db, $debug;

   if (! check_int($_REQUEST[id], false)) {
      return;
   }

   $qry = 'DELETE FROM characters WHERE id = ' . $_REQUEST[id];
   $db->do_query($qry, true);
}

function show_char() {
   global $db, $smarty;

   if (! check_int($_REQUEST[id], false)) {
      $smarty->assign('error', 'Invalid id specified');
      return;
   }

   $qry = 'SELECT * FROM characters WHERE id = ' . $_REQUEST[id];
   $rid = $db->do_query($qry, true);
   $row = $db->get_array($rid);
   $smarty->assign($row);
}

function edit_char() {
   global $db, $debug;

   if (! check_int($_REQUEST[id], false)) {
      return array('message' => 'invalid id specified');
   }
   $grosse = trim($_REQUEST[grosse]);
   if (! check_int($grosse, true)) {
      return array('errormsg' => 'Invalid height specified');
   }
   $gewicht = trim($_REQUEST[gewicht]);
   if (! check_int($gewicht, true)) {
      return array('errormsg' => 'Invalid weight specified');
   }
   $alter = trim($_REQUEST[alter]);
   if (! check_int($alter, true)) {
      return array('errormsg' => 'Invalid age specified');
   }
   $rasse = trim($_REQUEST[rasse]);
   $kultur = trim($_REQUEST[kultur]);
   $profession = trim($_REQUEST[profession]);
   $augenfarbe = trim($_REQUEST[augenfarbe]);
   $geschlecht = trim($_REQUEST[geschlecht]);
   $aussehen = trim($_REQUEST[aussehen]);
   $haarfarbe = trim($_REQUEST[haarfarbe]);

   $qry = 'UPDATE characters SET rasse = %s, kultur = %s, profession = %s, ' .
      'geschlecht = %s, grosse = %s, gewicht = %s, haarfarbe = %s, augenfarbe = %s, ' .
      'aussehen = %s, alter = %s WHERE id = %d';
   $qry = sprintf($qry, ($rasse)      ? "'" . pg_escape_string($rasse) . "'" : 'NULL',
                        ($kultur)     ? "'" . pg_escape_string($kultur) . "'" : 'NULL',
                        ($profession) ? "'" . pg_escape_string($profession) . "'" : 'NULL',
                        ($geschlecht) ? "'" . pg_escape_string($geschlecht) . "'" : 'NULL',
                        ($grosse)     ? $grosse : 'NULL',
                        ($gewicht)    ? $gewicht : 'NULL',
                        ($haarfarbe)  ? "'" . pg_escape_string($haarfarbe) . "'" : 'NULL',
                        ($augenfarbe) ? "'" . pg_escape_string($augenfarbe) . "'" : 'NULL',
                        ($aussehen)   ? "'" . pg_escape_string($aussehen) . "'" : 'NULL',
                        ($alter)      ? $alter : 'NULL',
                        $_REQUEST[id]);
   if (! @$db->do_query($qry, false)) {
      return array('message' => 'database-error' . ($debug) ? ': ' . pg_last_error() : '');
   }
   return array('success' => true);
}

switch ($_REQUEST[stage]) {
   case 'retrieve_base':
      echo json_encode(retrieve_base());
      break;
   case 'edit_eigenschaft':
      echo json_encode(edit_eigenschaft());
      break;
   case 'get_eigenschaft':
      get_eigenschaft();
      $smarty->display('templates/divs/characters/edit_eigenschaft.tpl');
      break;
   case 'show_char':
      show_char();
      $smarty->display('divs/characters/edit_char.tpl');
      break;
   case 'edit_char':
      echo json_encode(edit_char());
      break;
   case 'set_name':
      echo json_encode(set_name());
      break;
   case 'get_name':
      echo json_encode(get_name());
      break;
   case 'show_new_char':
      $smarty->display('templates/divs/characters/new_char.tpl');
      break;
   case 'remove':
      remove_char();
      show();
      $smarty->display('characters.tpl');
      break;
   case 'new_char':
      new_char();
      # fall down to default after adding character
   default:
      show();  # Can be removed should we not do something with individual characters
      $smarty->display('characters.tpl');
}
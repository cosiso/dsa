<?php
# Version 1.0

require_once('config.inc.php');
require_once('db.inc.php');
require_once('smarty.inc.php');

function get_kampftechniken() {
   global $db, $debug, $smarty;

   if (! $_REQUEST[id] or
       $_REQUEST[id] != intval($_REQUEST[id])) {
      return array('message' => 'invalid id specified');
   }

   $qry = 'SELECT kt.id, kt.name, kt.be, kt.skt, ';
   $qry .= '      ck.at, ck.pa, ck.at + ck.pa AS taw, ck.character_id ';
   $qry .= 'FROM  kampftechniken kt ';
   $qry .= '      LEFT JOIN char_kampftechniken ck ON ck.kampftechnik_id = kt.id AND ';
   $qry .= '                                          ck.character_id = ' . $_REQUEST[id] . ' ';
   $qry .= 'ORDER BY name';
   $rid = $db->do_query($qry, true);
   while ($row = $db->get_array($rid)) {
      $kampftechniken[] = $row;
   }
   $smarty->assign('kt', $kampftechniken);

   $out = $smarty->fetch('characters_kampftechniken.tpl');
   return array('success' => true,
                'out'     => $out);

}

function learn() {
   global $db, $debug, $smarty;

   if (! $_REQUEST[char_id] or
       $_REQUEST[char_id] != intval($_REQUEST[char_id])) {
      return array('message' => 'invalid character_id specified');
   }
   if (! $_REQUEST[technik_id] or
       $_REQUEST[technik_id] != intval($_REQUEST[technik_id])) {
      return array('message' => 'invalid kampftechnik_id specified');
   }

   $qry = 'INSERT INTO char_kampftechniken ';
   $qry .= '(character_id, kampftechnik_id) VALUES (';
   $qry .= $_REQUEST[char_id] . ', ';
   $qry .= $_REQUEST[technik_id] . ')';
   if (! @$db->do_query($qry, false)) {
      return array('message' => 'database-error while inserting' . ( ($debug) ? ':' . pg_last_error() : ''));
   }

   return array('success'    => true,
                'char_id'    => $_REQUEST[char_id],
                'technik_id' => $_REQUEST[technik_id]);
}

function unlearn() {
   global $db, $debug;

   if (! $_REQUEST[char_id] or
       $_REQUEST[char_id] != intval($_REQUEST[char_id])) {
      return array('message' => 'invalid character_id specified');
   }
   if (! $_REQUEST[technik_id] or
       $_REQUEST[technik_id] != intval($_REQUEST[technik_id])) {
      return array('message' => 'invalid kampftechnik_id specified');
   }

   $qry = 'DELETE FROM char_kampftechniken ';
   $qry .= 'WHERE character_id = ' . $_REQUEST[char_id] . ' AND ';
   $qry .= '      kampftechnik_id = ' . $_REQUEST[technik_id];
   if (! @$db->do_query($qry, false)) {
      return array('message' => 'database-error while removing' . ( ($debug) ? ': ' . pg_last_error() : ''));
   }
   return array('success'    => true,
                'char_id'    => $_REQUEST[char_id],
                'technik_id' => $_REQUEST[technik_id]);
}

function update_value() {
   global $db, $debug;

   if (! $_REQUEST[char_id] or
       $_REQUEST[char_id] != intval($_REQUEST[char_id])) {
      return array('message' => 'invalid character_id specified');
   }
   if (! $_REQUEST[technik_id] or
       $_REQUEST[technik_id] != intval($_REQUEST[technik_id])) {
      return array('message' => 'invalid kampftechnik_id specified');
   }
   if (! preg_match('/^(-)?\d+$/', $_REQUEST[value])) {
      return array('message' => 'invalid value specified');
   }
   $where = 'WHERE character_id = ' . $_REQUEST[char_id] . ' AND kampftechnik_id = ' . $_REQUEST[technik_id];
   $field = ($_REQUEST[kind] == 'at') ? 'at' : 'pa';
   list($cur, $taw) = $db->get_list("SELECT $field, at + pa AS taw FROM char_kampftechniken $where");
   $new = $cur + $_REQUEST[value];
   $taw = $taw + $_REQUEST[value];
   $qry = 'UPDATE char_kampftechniken SET ';
   $qry .= "      $field = $new ";
   $qry .= $where;
   if (! @$db->do_query($qry, false)) {
      return array('message' => 'database-error while updating' . ( ($debug) ? ': ' . pg_last_error() : ''));
   }
   return array('success'    => true,
                'technik_id' => $_REQUEST[technik_id],
                'kind'       => $field,
                'taw'        => $taw,
                'value'      => $new);
}

switch ($_REQUEST[stage]) {
   case 'update_kt_value':
      echo json_encode(update_value());
      break;
   case 'unlearn':
      echo json_encode(unlearn());
      break;
   case 'learn':
      echo json_encode(learn());
      break;
   case 'get':
      echo json_encode(get_kampftechniken());
      break;
   default:
      echo json_encode(array('message' => 'unexpected error'));
}
?>
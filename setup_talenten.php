<?php
# Version 1.0

require_once('config.inc.php');
require_once('db.inc.php');
require_once('smarty.inc.php');

function show() {
   global $db, $smarty;

   $qry = 'SELECT * FROM talenten_cat ORDER BY name';
   $rid = $db->do_query($qry);
   while ($row = $db->get_array($rid))
      $categories[] = $row;
   $smarty->assign('categories', $categories);
}

# Ajax-calls
function add_category() {
   global $db, $debug;

   $category_id = trim($_REQUEST[category_id]);
   $category_name = trim($_REQUEST[category_name]);
   $default_skt = strtoupper(trim($_REQUEST[default_skt]));

   if ($category_id and ( $category_id != intval($category_id))) {
      return array('success' => false,
                   'message' => 'invalid id of category');
   }
   if (! $category_name) {
      return array('success' => false,
                   'message' => 'no category name specified');
   }
   if (strlen($default_skt) > 1) {
      return array('success' => false,
                   'message' => 'default SKT should be 1 character');
   }

   if ($category_id) {
      # Edit existing talent category
      $qry = 'SELECT id ';
      $qry .= 'FROM  talenten_cat ';
      $qry .= "WHERE id = $category_id";
      if (! @$db->fetch_field($qry)) {
         return array('success' => false,
                      'message' => 'no category with the specified id exists');
      }
      # Update category
      $qry = 'UPDATE talenten_cat SET ';
      $qry .= "      name = '" . pg_escape_string($category_name) . "', ";
      $qry .= "      default_skt = '" . pg_escape_string($default_skt) . "' ";
      $qry .= "WHERE id = $category_id";
      if (!@$db->do_query($qry, false)) {
         return array('success' => false,
                      'message' => 'database error while updating' . ( ($debug) ? ': ' . pg_last_error() : ''));
      }
   } else {
      # Add talent category
      $qry = 'SELECT id ';
      $qry .= 'FROM  talenten_cat ';
      $qry .= "WHERE name = '" . pg_escape_string($category_name) . "'";
      if (@$db->fetch_field($qry)) {
         return array('success' => false,
                      'message' => 'a category with that name already exists');
      }
      # Insert new category
      $qry = 'INSERT INTO talenten_cat ';
      $qry .= '(name, default_skt) VALUES (';
      $qry .= "'" . pg_escape_string($category_name) . "', ";
      $qry .= ( ($default_skt) ? "'" . pg_escape_string($default_skt) . "'" : 'NULL') . ')';
      if (! $db->do_query($qry, false)) {
         return array('success' => false,
                      'message' => 'database error while inserting' . ( ($debug) ? ': ' . pg_last_error() : ''));
      }
      $category_id = $db->insert_id('talenten_cat');
   }
   return array('success' => true,
                'id'      => $category_id,
                'name'    => htmlspecialchars($category_name, ENT_QUOTES),
                'skt'     => htmlspecialchars($default_skt, ENT_QUOTES));
}
function remove_category() {
   global $db, $debug;

   $category_id = trim($_REQUEST[category_id]);
   if (! $category_id or $category_id != intval($category_id)) {
      return array('success' => false,
                   'message' => 'invalid id for catgeory');
   }

   $qry = 'DELETE FROM talenten_cat WHERE id = ' . $category_id;
   if (! @$db->do_query($qry, false)) {
      return array('success' => false,
                   'message' => 'database error while deleting' . ( ($debug) ? ': ' . pg_last_error() : ''));
   }
   return array('success' => true,
                'id' => $category_id);
}

switch ($_REQUEST[stage]) {
   case 'add_category':
      echo json_encode(add_category());
      break;
   case 'remove_category':
      echo json_encode(remove_category());
      break;
   default:
      show();
      $smarty->display('setup_talenten.tpl');
}
?>
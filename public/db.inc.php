<?php
#	Version 1.0

# Declares class and instantiate it as db

class db {
	var $dbh;		// database handle

	function db() {
      global $dbname;
      $this->dbh = pg_connect('dbname=dsa') or die('Could not connect to database');
   }
	function do_query($qry, $die=true) {
      $rid = @pg_query($this->dbh, $qry);
      if (!$rid) {
         if ($die)
            die("<br>Could not execute query: $qry<br>" . pg_last_error() . "<br>");
         else
            return false;
      }
      return $rid;
   }
   function fetch_field($qry, $die=true) {
      $rid = $this->do_query($qry, $die);
      if (! $rid) return false;
      $row = pg_fetch_array($rid);
      return $row[0];
   }
	function get_array($rid) {
      return pg_fetch_array($rid);
   }
   function get_row($rid) {
      return pg_fetch_row($rid);
   }
   function get_list($qry, $die = true) {
      $rid = $this->do_query($qry, $die);
      return pg_fetch_row($rid);
   }
   function insert_id($table_name) {
      $id = $this->fetch_field("SELECT CURRVAL(pg_get_serial_sequence('$table_name', 'id'))");
      return $id;
   }
   function num_rows($rid) {
      return pg_num_rows($rid);
   }
   function rollback() {
      $this->do_query("ROLLBACK", true);
   }
   function commit() {
      $this->do_query("COMMIT", true);
   }
   function start_trans() {
      $this->do_query("BEGIN", true);
   }
   /*
    * Retrieves the values possible for the given name
    */
   public function get_enum_values($enum_name) {
      $qry = 'SELECT e.enumlabel as enum_value ' .
             'FROM pg_type t ' .
             'JOIN pg_enum e ON t.oid = e.enumtypid  ' .
             'JOIN pg_catalog.pg_namespace n ON n.oid = t.typnamespace ' .
             "WHERE t.typname = '%s' " .
             'ORDER BY enum_value';
      $qry = sprintf($qry, $enum_name);
      $rid = $this->do_query($qry);
      while ($row = $this->get_array($rid)) {
         $values[$row['enum_value']] = $row['enum_value'];
      }
      return $values;
   }
}

$db = new db;
?>

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
      $rid = pg_query($this->dbh, $qry);
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
}

$db = new db;
?>

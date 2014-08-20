<?php

class CharMagic extends Eloquent {
   protected $table = 'char_magic';
   public $timestamps = false;

   public function character() {
      return $this->belongsTo('Character');
   }
   public function quelle() {
      return $this->belongsTo('Quelle');
   }
   // Return the possible values for corresponding database types
   public function lst_tradition() {
      return array('Intuitiv', 'Wissenschaftlich');
   }
   public function lst_beschworung() {
      return array('Essenz', 'Wesen');
   }
   public function lst_wesen() {
      return array('Inspiration', 'Invokation');
   }
}
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
}
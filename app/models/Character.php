<?php

class Character extends Eloquent {
   protected $table = 'characters';
   public $timestamps = false;

   public function charmagic() {
      return $this->hasMany('CharMagic', 'character_id');
   }
}

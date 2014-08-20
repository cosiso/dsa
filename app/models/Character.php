<?php

class Character extends Eloquent {
   protected $table = 'characters';
   public $timestamps = false;

   # Retrieve all characters in array id => name
   public static function lst_all($sort = 'name', $order = 'ASC') {
      $chars = Character::orderBy($sort, $order)->get();
      foreach ($chars as $char) {
         $result[$char->id] = $char->name;
      }
      return $result;
   }

   public function charmagic() {
      return $this->hasMany('CharMagic', 'character_id');
   }
}

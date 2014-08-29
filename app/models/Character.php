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

   # Fetch all instruktions this character does not know yet
   public function available_instruktionen() {
      $has_inst = DB::select(DB::raw('SELECT id, name FROM instruktionen WHERE id NOT IN (SELECT instruktion_id FROM char_instruktion WHERE character_id = ?) ORDER BY name'), array($this->id));
      $inst = array();
      foreach ($has_inst as $i) { $inst[$i->id] = $i->name; }
      return $inst;
   }

   /*
    * Add the given instruktion
    */
   public function add_instruktion($input) {
      $rules = array('instruktion' => 'required|integer');
      $validator = Validator::Make($input, $rules);
      if (! $validator->passes()) return array('message' => 'Found errors: ' . $validator->messages());
      $id = DB::table('char_instruktion')->insertGetId(array('character_id' => $this->id,
                                                             'instruktion_id' => $input['instruktion']));
      if (! $id) return array('message' => 'Unknown database error occurred');
      return array('instruktion_id' => $id,
                   'success'        => true,
                   'character_id'   => $this->id);
   }

   # Database relations
   public function charmagic() {
      return $this->hasMany('CharMagic', 'character_id');
   }
   public function instruktionen() {
      return $this->belongsToMany('Instruktion', 'char_instruktion', 'character_id', 'instruktion_id');
   }
}

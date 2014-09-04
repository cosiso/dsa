<?php

class Character extends Eloquent {
   protected $table = 'characters';
   public $timestamps = false;


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
      $name = DB::table('instruktionen')->select('name')->where('id', $input['instruktion'])->get();
      if (empty($name)) return array('message' => 'invalid instruktion specified');
      $id = DB::table('char_instruktion')->insertGetId(array('character_id' => $this->id,
                                                             'instruktion_id' => $input['instruktion']));
      if (! $id) return array('message' => 'Unknown database error occurred');

      return array('instruktion_id' => $id,
                   'name'           => $name[0]->name,
                   'success'        => true,
                   'character_id'   => $this->id);
   }

   # Database functions

   /*
    * Retrieves a list of all characters that have a quelle
    */
   public static function available_casters() {
      return DB::select(DB::raw('SELECT characters.id, characters.name FROM characters, char_magic WHERE char_magic.character_id = characters.id ORDER BY name'));
   }

   /*
    * Retrieve all characters in array id => name
    */
   public static function lst_all($sort = 'name', $order = 'ASC') {
      $chars = Character::orderBy($sort, $order)->get();
      foreach ($chars as $char) {
         $result[$char->id] = $char->name;
      }
      return $result;
   }

   # Database relations
   public function charmagic() {
      return $this->hasMany('CharMagic', 'character_id');
   }
   public function instruktionen() {
      return $this->belongsToMany('Instruktion', 'char_instruktion', 'character_id', 'instruktion_id');
   }
}

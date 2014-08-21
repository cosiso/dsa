<?php

class CharMagic extends Eloquent {
   protected $table = 'char_magic';
   public $timestamps = false;

   # Create/Update
   public function do_update($data) {
      $data = array_map('trim', $data);
      $validate = $this->validate($data);
      if ($validate !== true) {
         return array('message'    => "Found errors: $validate",
                      'show_popup' => true);
      }
      $this->populate($data);
      if (! $this->save()) return array('message' => 'database-error while saving');
      return array('success' => true,
                   'id'           => $this->id,
                   'quelle'       => $this->quelle->name,
                   'value'        => $this->value,
                   'tradition'    => $this->tradition,
                   'beschworung'  => $this->beschworung,
                   'wesen'        => $this->wesen,
                   'skt'          => $this->skt,
                   'character_id' => $this->character_id);
   }
   # Input validation
   protected function validate($data) {
      $tradition = implode(',', array_keys($this->lst_tradition()));
      $beschworung = implode(',', array_keys($this->lst_beschworung()));
      $wesen = implode(',', array_keys($this->lst_wesen()));
      $rules = array('character_id' => 'integer|exists:characters,id',
                     'quelle'       => 'integer|exists:quellen,id',
                     'tradition'    => "required|in:$tradition",
                     'beschworung'  => "required|in:$beschworung",
                     'wesen'        => "required|in:$wesen",
                     'skt'          => 'required|in:a,A,b,B,c,C,d,D,e,E,f,F,g,G,h,H',
                     'value'        => 'integer|min:0');
      $validator = Validator::make($data, $rules);
      return ($validator->passes()) ? true : $validator->messages();
   }
   # Set values from array to object
   protected function populate($data) {
      $this->character_id = $data['character_id'];
      $this->quelle_id    = $data['quelle'];
      $this->tradition    = $data['tradition'];
      $this->beschworung  = $data['beschworung'];
      $this->wesen        = ($data['wesen'] == '0') ? null : $data['wesen'];
      $this->skt          = strtoupper($data['skt']);
      $this->value        = $data['value'];
   }
   # Database relations
   public function character() {
      return $this->belongsTo('Character');
   }
   public function quelle() {
      return $this->belongsTo('Quelle');
   }
   # Return the possible values for corresponding database types
   public function lst_tradition() {
      return array('Intuitiv'         => 'Intuitiv',
                   'Wissenschaftlich' => 'Wissenschaftlich');
   }
   public function lst_beschworung() {
      return array('Essenz' => 'Essenz',
                   'Wesen'  => 'Wesen');
   }
   public function lst_wesen() {
      return array('0'           => '--Not applicable',
                   'Inspiration' => 'Inspiration',
                   'Invokation'  => 'Invokation');
   }
}
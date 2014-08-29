<?php

class Instruktion extends Eloquent {
   public $table = 'instruktionen';
   public $timestamps = false;

   public function do_update($data) {
      $data = array_map('trim', $data);
      $rules = array('name' => 'required|max:64' . ( ($this->exists) ? '' : '|unique:instruktionen'),
                     'desc' => 'max:4096');
      $validator = Validator::make($data, $rules);
      if ($validator->passes()) {
         $is_new = ($this->exists) ? false : true;
         $this->name = $data['name'];
         $this->description = $data['desc'];
         try {
            if ($this->save()) {
               return array('success' => true,
                            'id'      => $this->id,
                            'name'    => $this->name,
                            'is_new'  => $is_new);
            } else {
               throw new Exception('unknown error');
            }
         } catch (Exception $e) {
            return array('message' => 'database-error while saving: ');
         }
      } else {
         return array('message' => 'Found errors: ' . $validator->messages());
      }
   }

   # database relations
   public function characters() {
      return $this->belongsToMany('Character', 'char_instruktion');
   }
}
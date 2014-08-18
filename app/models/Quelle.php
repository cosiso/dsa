<?php

class Quelle extends Eloquent {
   public $table = 'quellen';
   public $timestamps = false;

   public function do_update($data) {
      $data = array_map('trim', $data);
      $rules = array('name' => 'required|max:64' . ( ($this->exists) ? '' : '|unique:quellen'),
                     'desc' => 'max:4096');
      $validator = Validator::make($data, $rules);
      if ($validator->passes()) {
         $is_new = ($this->exists) ? false : true;
         $this->name = $data['name'];
         $this->description = $data['desc'];
         try {
            if ($this->save()) {
               return array('id'      => $this->id,
                            'name'    => $this->name,
                            'is_new'  => $is_new,
                            'success' => true);
            } else {
               throw new Exception('unknown error');
            }
         } catch (Exception $e) {
            return array('message' => 'Error: database-error while saving');
         }
      } else {
         return array('message' => 'Found errors: ' . $validator->messages());
      }
   }
}
<?php

class Creature extends Eloquent {
   protected $table = 'creatures';
   public $timestamps = false;


   ########################################################
   ##### Functions for updating
   ########################################################
   public function do_update($data) {
      $validator = Validator::make($data, array('name'         => 'required|max:64',
                                                'quelle'       => 'required|integer|exists:quellen,id',
                                                'beschworung'  => 'required|integer',
                                                'beherrschung' => 'required|integer'));
      if ($validator->passes()) {
         $is_new = ($this->exists) ? false : true;
         $this->name = ucfirst(strtolower($data['name']));
         $this->quelle_id = $data['quelle'];
         $this->beschworung = $data['beschworung'];
         $this->beherrschung = $data['beherrschung'];
         $this->description = $data['description'];
         try {
            if ($this->save()) {
               return array('success' => true,
                            'id'      => $this->id,
                            'name'    => $this->name,
                            'is_new'  => $is_new);
            } else {
               throw new Exception('Unknown error');
            }
         } catch (Exception $e) {
            return array('message' => 'Error: database-error while saving');
         }
      }
      return array('message' => 'updating');
   }
   ########################################################
   ##### Database functions
   ########################################################
   public function quelle() {
      return $this->belongsTo('Quelle', 'quelle_id');
   }
}
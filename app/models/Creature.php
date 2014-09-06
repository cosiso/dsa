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
                                                'beherrschung' => 'required|integer',
                                                'le'           => 'integer|min:1',
                                                'ae'           => 'integer|min:0',
                                                'rs'           => 'integer|min:0',
                                                'mr'           => 'integer|min:0',
                                                'gw'           => 'integer|min:1',
                                                'gs'           => 'numeric|min:0'));
      if ($validator->passes()) {
         $is_new = ($this->exists) ? false : true;
         $this->name = ucfirst(strtolower($data['name']));
         $this->quelle_id = $data['quelle'];
         $this->beschworung = $data['beschworung'];
         $this->beherrschung = $data['beherrschung'];
         $this->description = @$data['description'] ? : null;
         $this->le = @$data['le'] ? : null;
         $this->ae = @$data['ae'] ? : null;
         $this->rs = @$data['rs'] ? : null;
         $this->ini = @$data['ini'] ? : null;
         $this->gs = @$data['gs'] ? : null;
         $this->mr = @$data['mr'] ? : null;
         $this->gw = @$data['gw'] ? : null;
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
            return array('message' => 'database-error while saving');
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
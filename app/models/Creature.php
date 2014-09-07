<?php

class Creature extends Eloquent {
   protected $table = 'creatures';
   public $timestamps = false;

   public $ranks = array('Geist' => 'Geist', 'Genius' => 'Genius', 'Archon' => 'Archon');

   ########################################################
   ##### Functions for updating
   ########################################################
   public function do_update($data) {
      $validator = Validator::make($data, array('name'         => 'required|max:64',
                                                'quelle'       => 'required|integer|exists:quellen,id',
                                                'rank'         => 'in:Geist,Genius,Archon',
                                                'beschworung'  => 'required|integer',
                                                'beherrschung' => 'required|integer',
                                                'le'           => 'integer|min:1',
                                                'ae'           => 'integer|min:0',
                                                'pa'           => 'integer|min:0',
                                                'rs'           => 'integer|min:0',
                                                'mr'           => 'integer|min:0',
                                                'gw'           => 'integer|min:1',
                                                'gs'           => 'numeric|min:0',));
      if ($validator->passes()) {
         $is_new = ($this->exists) ? false : true;
         $this->name = ucfirst(strtolower($data['name']));
         $this->quelle_id = $data['quelle'];
         $this->rank = @$data['rank'] ? : null;
         $this->beschworung = $data['beschworung'];
         $this->beherrschung = $data['beherrschung'];
         $this->kampfregeln = @$data['kampfregeln'] ? : null;
         $this->eigenschaften = @$data['eigenschaften'] ? : null;
         $this->zauber = @$data['zauber'] ? : null;
         $this->leihgaben = @$data['leihgaben'] ? : null;
         $this->dienste = @$data['dienste'] ? : null;
         $this->nachteil = @$data['nachteil'] ? : null;
         $this->description = @$data['description'] ? : null;
         $this->le = @$data['le'] ? : null;
         $this->ae = @$data['ae'] ? : null;
         $this->rs = @$data['rs'] ? : null;
         $this->ini = @$data['ini'] ? str_replace('W', 'D', strtoupper($data['ini'])): null;
         $this->gs = @$data['gs'] ? : null;
         $this->mr = @$data['mr'] ? : null;
         $this->gw = @$data['gw'] ? : null;
         $this->pa = @$data['pa'] ? : null;
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
            return array('message' => 'database-error while saving: ' . var_dump($this));
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
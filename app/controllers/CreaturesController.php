<?php

class CreaturesController extends BaseController {
   public function index() {
      $data['selected'] = 'creatures';
      return View::make('creatures/index', $data);
   }

   /*
    * Update creature
    */
   public function update() {
      Input::merge(array_map('trim', Input::all()));
      try {
         $id = Input::get('id');
         if (empty($id)) {
            $creature = new Creature;
         } else {
            if (! ctype_digit($id)) throw new InvalidArgumentException('invalid id specified');
            $creature = Creature::find($id);
            if (empty($creature)) throw new InvalidArgumentException('invalid id specified');
         }
         $result = $creature->do_update(Input::all());
      } catch (InvalidArgumentException $e) {
         $result = array('message' => 'invalid id specified');
      }
      return json_encode($result);
   }
   /*
    * Show creature for editing
    */
   public function show($creature = null) {
      try {
         if ($creature === null) {
            $creature = new Creature;
         } else {
            if (! ctype_digit($creature)) throw new InvalidArgumentException('invalid id specified');
            $creature = Creature::find($creature);
            if (empty($creature)) throw new InvalidArgumentException('invalid id specified');
         }
         $q= Quelle::all()->sortBy('name');
         $quellen = [];
         foreach ($q as $quelle) {
            $quellen[$quelle->id] = $quelle->name;
         }

      } catch (InvalidArgumentException $e) {
         $error = $e->getMessage();
      }
      return View::make('magic/creature_show', compact('creature', 'quellen', 'error'));
   }
   /*
    * Lists creatures from a quelle
    */
   public function overview($quelle) {
      if (empty($quelle)) {
         $data['error'] = 'Invalid quelle specified';
      } else {
         $data['name'] = $quelle->name;
         $data['creatures'] = $quelle->list_creatures();
      }
      return View::make('magic/creature_overview', $data);
   }
   /*
    * Lists all quellen
    */
   public function cList() {
      $quellen = Quelle::all()->sortBy('name');
      return View::make('/magic/creatures_index', compact('quellen'));
   }

   /*
    * Returns a list of characters that can summon (i.e. have at least one quelle)
    */
   public function characters() {
      $casters = Character::available_summoners();
      $chars = [];
      foreach ($casters as $caster) {
         $chars[$caster->id] = $caster->name;
      }
      return View::make('creatures/characters', compact('chars'));
   }
   /*
    * Returns a list of quellen for the given character
    */
   public function quellen($character_id) {
      try {
         if (! ctype_digit($character_id)) throw new InvalidArgumentException('invalid id specified');
         $char = Character::find($character_id);
         if (empty($char)) throw new InvalidArgumentException('invalid id specified');
         $data['quellen'] = [];
         foreach ($char->summon_quellen() as $quelle) {
            $data['quellen'][] = array('id'    => $quelle->id,
                                       'name'  => $quelle->name,
                                       'value' => $quelle->value);
         }
      } catch (InvalidArgumentException $e) {
         $data['error'] = $e->getMessage();
      }
      return View::make('creatures/quellen', $data);
   }
}
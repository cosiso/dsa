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
      if (Input::has('id')) {
         $creature = new Creature(Input::get('id'));
      } else {
         $creature = new Creature;
      }
      $result = $creature->do_update(Input::all());
      return json_encode($result);
   }
   /*
    * Show creature for editing
    */
   public function show($creature = null) {
      if (empty($creature)) { $creature = new Creature; }
      $q= Quelle::all()->sortBy('name');
      #$q = Quelle::orderBy('name')->get();
      $quellen = [];
      foreach ($q as $quelle) {
         $quellen[$quelle->id] = $quelle->name;
      }
      return View::make('magic/creature_show', compact('creature', 'quellen'));
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
      $char = Character::find($character_id);
      if (empty($char)) {
         $data['error'] = 'Invalid character specified';
         return View::make('creatures/quellen', $data);
      }
      $data['quellen'] = [];
      foreach ($char->summon_quellen() as $quelle) {
         $data['quellen'][] = array('id'    => $quelle->id,
                                    'name'  => $quelle->name,
                                    'value' => $quelle->value);
      }
      return View::make('creatures/quellen', $data);
   }
}
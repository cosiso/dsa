<?php

class CreaturesController extends BaseController {
   public function index() {
      $data['selected'] = 'creatures';
      return View::make('creatures/index', $data);
   }

   /*
    * Returns a list of characters that can summon (i.e. have at least one quele)
    */
   public function characters() {
      $casters = Character::available_casters();
      $chars = [];
      foreach ($casters as $caster) {
         $chars[$caster->id] = $caster->name;
      }
      return View::make('creatures/characters', compact('chars'));
   }
}
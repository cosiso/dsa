<?php

class MagicController extends BaseController {
   public function setup() {
      $data['selected'] = 'setup';
      return View::make('magic/setup', $data);
   }

   public function characters() {
      $selected = 'characters';
      $characters = Character::orderBy('name')->get();
      return View::make('magic/characters', compact('characters', 'selected'));
   }

   public function show_character($id) {
      $character = Character::find($id);

      return View::make('magic/char_magic', compact('character'));
   }
}
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

   /* Return a drop down list with the still available instruktionen
    * for a character
    */
   public function show_instruktionen($character_id) {
      if (! ctype_digit($character_id)) {
         $error = 'Invalid character specified';
         return View::make('magic/frm_instruktion', compact('error'));
      }
      $character = Character::find($character_id);
      if (! $character->exists) {
         $error = 'Invalid character specified';
         return View::make('magic/frm_instruktion', compact('error'));
      }
      return View::make('magic/frm_instruktion', compact('character', 'error'));
   }
}
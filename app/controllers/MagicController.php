<?php

class MagicController extends BaseController {
   public function setup() {
      $data['selected'] = 'setup';
      return View::make('magic/setup', $data);
   }

   public function characters() {
      ### Should not be used anymore
      /*
      $selected = 'characters';
      $characters = Character::orderBy('name')->get();
      return View::make('magic/characters', compact('characters', 'selected'));
      */
   }

   public function show_character($id) {
      ### Should not be used anymore
      /*
      $character = Character::find($id);

      return View::make('magic/char_magic', compact('character'));
      */
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

   /*
    * Remove the instruktion from a charater
    */
   public function remove_instruktion($char_instruktion_id) {
      if (! ctype_digit($char_instruktion_id)) return json_encode(array('message' => 'invalid id specified'));
      try {
         DB::table('char_instruktion')->delete($char_instruktion_id);
      } catch (Exception $e) {
         return json_encode(array('message' => 'unknown database error'));
      }
      return json_encode(array('success' => true,
                               'id'      => $char_instruktion_id));

   }
}
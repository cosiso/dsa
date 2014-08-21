<?php

class CharMagicController extends BaseController {
   public function create($character_id) {
      $character = Character::find($character_id);
      if (empty($character)) {
         $error = 'Character not found';
         return View::make('charmagic/edit_form', compact('error'));
      }
      $charmagic = new CharMagic;
      $quellen = Quelle::lst_all('name', 'ASC');
      return View::make('charmagic/edit_form', compact('charmagic', 'character', 'quellen'));
   }
   public function do_create ($character_id) {
      $charmagic = new CharMagic;
      return $this->do_update($charmagic);
   }
   public function remove(CharMagic $charmagic) {
      if (! $charmagic->exists) {
         return json_encode(array('message' => 'invalid source specified'));
      }
      $id = $charmagic->id;
      if ($charmagic->delete()) {
         return json_encode(array('id' => $id));
      }
      return json_encode(array('message' => 'database-error while removing'));
   }
   public function edit(CharMagic $charmagic) {
      if (! $charmagic->exists) {
         return json_encode(array('message' => 'invalid source specified'));
      }
      $character = $charmagic->character;
      $quellen = Quelle::lst_all('name', 'ASC');
      return View::make('charmagic/edit_form', compact('charmagic', 'character', 'quellen'));
   }
   public function update(CharMagic $charmagic) {
      if (! $charmagic->exists) {
         return json_encode(array('message' => 'invalid source specified'));
      }
      return $this->do_update($charmagic);
   }
   # Follow-up from create and update
   protected function do_update(CharMagic $cm) {
      $response = $cm->do_update(Input::all());
      return json_encode($response);
   }
}
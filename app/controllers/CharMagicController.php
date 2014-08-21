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
      $charmagic->kind = array('Inspiration' => 'Inspiration',
                               'Invokation' => 'Invokation');
      return View::make('charmagic/edit_form', compact('charmagic', 'character', 'quellen'));
   }
   public function do_create () {
      $charmagic = new CharMagic;
      $response = $charmagic->do_create(Input::all());
      return json_encode($response);
   }
}
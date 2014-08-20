<?php

class CharMagicController extends BaseController {
   public function create() {
      $charmagic = new CharMagic;
      $characters = Character::lst_all('name', 'ASC');
      $quellen = Quelle::lst_all('name', 'ASC');
      $charmagic->kind = array('Inspiration' => 'Inspiration',
                               'Invokation' => 'Invokation');
      return View::make('charmagic/edit_form', compact('charmagic', 'characters', 'quellen'));
   }
}
<?php

class MagicController extends BaseController {
   public function setup() {
      $data['selected'] = 'setup';
      return View::make('magic/setup', $data);
   }

   public function characters() {
      return('ToDo: not yet implemented');
   }
}
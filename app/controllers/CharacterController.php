<?php

class CharacterController extends BaseController {
   /*
    * Add the given instruktion to the character
    */
   public function add_instruktion(Character $char) {
      if (! $char->exists) {
         return json_encode(array('message' => 'invalid character specified'));
      }
      return json_encode($char->add_instruktion(Input::all()));
   }
}
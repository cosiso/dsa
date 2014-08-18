<?php

class QuellenController extends BaseController {
   public function index() {
      $data['quellen'] = Quelle::orderBy('name')->get();
      return View::make('quellen/index', $data);
   }

   public function show_description(Quelle $quelle) {
      $text = (isset($quelle->description)) ?
              nl2br(htmlspecialchars($quelle->description)) :
              'No description available';
      $hidebot = false;
      return View::make('quellen/show_description', compact('text', 'hidebot'));
   }

   public function delete(Quelle $quelle) {
      $id = $quelle->id;
      if ($quelle->delete()) {
         $response = array('success' => true,
                           'id' => $id);
      } else {
         $response = array('message' => 'Error: database-error while removing');
      }
      return json_encode($response);
   }

   public function edit(Quelle $quelle) {
      return View::make('quellen/edit_form', compact('quelle'));
   }

   public function update(Quelle $quelle) {
      $response = $quelle->do_update(Input::all());
      return json_encode($response);
   }

   public function create() {
      $quelle = new Quelle;
      return View::make('quellen/edit_form', compact('quelle'));
   }

   public function handleCreate() {
      $quelle = new Quelle;
      $response = $quelle->do_update(Input::all());
      return json_encode($response);
   }
}
<?php

class InstruktionenController extends \BaseController {

	/**
	 * Display a listing of the resource.
	 *
	 * @return Response
	 */
	public function index()	{
      $instruktionen = Instruktion::orderBy('name')->get();
      return View::make('instruktionen/index', compact('instruktionen'));
	}

   public function show_description($instruktion) {
      $text = (isset($instruktion->description)) ?
              nl2br(htmlspecialchars($instruktion->description)) :
              'No description available';
      $hidebot = false;
      return View::make('instruktionen/show_description', compact('text', 'hidebot'));
   }

	/**
	 * Show the form for creating a new resource.
	 *
	 * @return Response
	 */
	public function create() {
      $instruktion = new Instruktion;
      return View::make('instruktionen/edit_form', compact('instruktion'));
	}


	/**
	 * Store a newly created resource in storage.
	 *
	 * @return Response
	 */
	public function store()	{
      $instruktion = new Instruktion;
      $response = $instruktion->do_update(Input::all());
      return json_encode($response);
	}


	/**
	 * Display the specified resource.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function show($id) 	{
      $view = 'instruktionen/edit_form';
      if (! is_digits($id)) {
         $error = 'Invalid id specified';
         return View::make($view, compact('error'));
      }
      $instruktion = Instruktion::find($id);
      if (! $instruktion) {
         $error = 'Character does not exist';
         return View::make($view, compact('error'));
      }

		return View::make($view, compact('instruktion'));
	}


	/**
	 * Update the specified resource in storage.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function update($instruktion) {
      $response = $instruktion->do_update(Input::all());
      return json_encode($response);
   }


	/**
	 * Remove the specified resource from storage.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function destroy($id) 	{
      if (! is_digits($id)) {
         return json_encode(array('message' => "invalid id specified"));
      }
      $instruktion = Instruktion::find($id);
      if (! $instruktion) {
         return json_encode(array('message' => 'instruktion does not exist'));
      }
      if ($instruktion->delete()) {
         $response = array('success' => true,
                           'id'      => $id);
      } else {
         $response = array('message' => 'database-error while deleting');
      }
		return json_encode($response);
	}

}

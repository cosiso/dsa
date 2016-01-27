<?php

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It's a breeze. Simply tell Laravel the URIs it should respond to
| and give it the Closure to execute when that URI is requested.
|
*/

Route::get('/', function() {
   return Redirect::to('/index.php');
});
# Character
Route::model('character', 'Character');
Route::post('/magic/instruktion/{character}', 'CharacterController@add_instruktion');
# Magic
### Route::get('/magic', 'MagicController@characters');
### Route::get('/magic/characters', 'MagicController@characters');
Route::get('/magic/setup', 'MagicController@setup');
### Route::get('/magic/show_character/{id}', 'MagicController@show_character');
Route::get('/magic/instruktion/{character_id}', 'MagicController@show_instruktionen');
Route::delete('/magic/instruktion/{char_instruktion_id}', 'MagicController@remove_instruktion');

# Quellen
Route::model('quelle', 'Quelle');
Route::get('/quellen', 'QuellenController@index');
Route::get('/quellen/create', 'QuellenController@create');
Route::post('/quellen/create', 'QuellenController@handleCreate');
Route::get('/quellen/edit/{quelle}', 'QuellenController@edit');
Route::post('/quellen/edit/{quelle}', 'QuellenController@update');
Route::delete('/quellen/delete/{quelle}', 'QuellenController@delete');
Route::get('/quellen/description/{quelle}', 'QuellenController@show_description');

# Instruktionen
Route::model('instruktion', 'Instruktion');
Route::resource('instruktionen', 'InstruktionenController');
Route::get('/instruktionen/description/{instruktion}', 'InstruktionenController@show_description');
Route::post('/instruktionen/{instruktion}', 'InstruktionenController@update');

# CharMagic
Route::model('charmagic', 'CharMagic');
Route::get('/charmagic/create/{character_id}', 'CharMagicController@create');
Route::post('/charmagic/create/{character_id}', 'CharMagicController@do_create');
Route::delete('/charmagic/remove/{charmagic}', 'CharMagicController@remove');
Route::get('/charmagic/edit/{charmagic}', 'CharMagicController@edit');
Route::post('/charmagic/edit/{charmagic}', 'CharMagicController@update');

# Creatures (summoning)
Route::get('/creatures', 'CreaturesController@index');
Route::get('/creatures/get_characters', 'CreaturesController@characters');
Route::get('/creatures/get_quellen/{character_id}', 'CreaturesController@quellen');
Route::get('/creatures/list', 'CreaturesController@cList');
Route::get('/creatures/setup/{quelle}', 'CreaturesController@overview');
Route::get('/creatures/new', 'CreaturesController@show');
Route::get('/creatures/edit/{creature}', 'CreaturesController@show');
Route::post('/creatures/edit', 'CreaturesController@update');

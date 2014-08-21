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
   return Redirect::to('/index2.php');
});
Route::get('/index.php', function() {
   return Redirect::to('/index2.php');
});
# Magic
Route::get('/magic', 'MagicController@characters');
Route::get('/magic/characters', 'MagicController@characters');
Route::get('/magic/setup', 'MagicController@setup');
Route::get('/magic/show_character/{id}', 'MagicController@show_character');

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
Route::post('/charmagic/create', 'CharMagicController@do_create');
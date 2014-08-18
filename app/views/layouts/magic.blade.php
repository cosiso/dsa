@extends('layouts/base')
@section('menu_left')
   @if ($selected == 'characters' or $selected == '')
      <div class="selected_menu">Characters</div>
   @else
      <div><a href="{{ action('MagicController@characters') }}">Characters</a></div>
   @endif
   Stuff to do
   <hr>
   @if ($selected == 'setup')
      <div class="selected_menu">Setup</div>
   @else
      <div><a href="{{ action('MagicController@setup') }}">Setup</a></div>
   @endif
@stop
@extends('layouts/base')
@section('menu_left')
   @if ($selected == 'characters' or $selected == '')
      <div class="selected_menu">Characters</div>
   @else
      <div><a href="{{ action('MagicController@characters') }}">Characters</a></div>
   @endif
   @if ($selected == 'spells')
      <div class="selected_menu">Spells</div>
   @else
      <div><a href="#" onclick="alert('ToDo')">Spells</a></div>
   @endif
   @if ($selected == 'creatures')
      <div class="selected_menu">Creatures</div>
   @else
      <div><a href="{{ action('CreaturesController@index') }}">Creatures</a></div>
   @endif
   <hr>
   @if ($selected == 'setup')
      <div class="selected_menu">Setup</div>
   @else
      <div><a href="{{ action('MagicController@setup') }}">Setup</a></div>
   @endif
@stop
@extends('layouts/magic')

@section('title')
   <title>DSA - Magic</title>
@stop

@section('content')
   <h3 onclick="summon()">Summon creature</h3>
   <div id="summon" class="maxed" style="display: none">
      <h4 id="action">1. Select a character</h4>
      <div id="characters"></div>
      <div id="quellen"></div>
      <div id="creatures"></div>
   </div>
   <h3 onclick="alertify.alert('Browsing not implemented')">Browse creatures</h3>
@stop

@section('javascript')
   <script type="text/javascript">
      <!--
      function summon() {
         {{-- Initialize divs --}}
         $('#characters').text('Retrieving characters');
         $('#quellen').text('');
         $('#creatures').text('');
         {{-- Display summoning div --}}
         $('#summon').show();
         $('#characters').load('{{ action('CreaturesController@characters') }}',
                               function(response, status, xhr) {
            if (status != 'success') {
               alertify.alert('Unknown error ocured');
               return;
            }
         });
      }
      function select_char(li) {
         $li = $(li);
         var id = $li.prop('id').split('-')[1];
         $li.addClass('highlight');
         $li.parent().parent().append('<hr>');
         $('h4#action').text('2. Select a quelle');
         $('div#quellen').text('Retrieving quellen')
                         .load('/creatures/get_quellen/' + id,
                               function(response, status, xhr) {
            if (status != 'success') {
               alertify.alert('Unknown error occured');
               return;
            }
         });

      }
      function select_quelle(li) {
         $li = $(li);
         var id = $li.prop('id').split('-')[1];
         $li.addClass('highlight');
      }
      //-->
   </script>
@stop
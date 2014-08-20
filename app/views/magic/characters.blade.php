@extends('layouts/magic')

@section('title')
   <title>DSA - Magic</title>
@stop

@section('content')
   @foreach($characters as $character)
      <h3 onclick="show_character({{ $character->id }})">{{{ $character->name }}}</h3>
      <div id="char-{{ $character->id }}" style="display: none; max-width: 800px"></div>
   @endforeach
@stop

@section('javascript')
   <script type="text/javascript">
      <!--
      jQuery.fn.center = function () {
          this.css("position","absolute");
          this.css("top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) +
                                                      $(window).scrollTop()) + "px");
          this.css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) +
                                                      $(window).scrollLeft()) + "px");
          return this;
      }
      $.validator.addMethod('skt', function(value, element, parameter) {
         var v = value.toUpperCase();
         if (v != 'A' && v != 'B' && v != 'C' && v != 'D' && v != 'E' && v != 'F' && v != 'G' && v != 'H' && v != '') {
            v = false;
         } else {
            v = true;
         }
         return this.optional(element) || v;
      }, 'Invalid SKT');
      $.validator.addMethod('num', function(value, element, parameter) {
         return this.optional(element) || parseInt(value) == value;
      }, 'Value must be an integer');
      function show_character(id) {
         var div = '#char-' + id;
         if ($(div).is(':visible')) {
            $(div).hide();
            return;
         }
         if (true || ! $(div).html()) {
            $(div).text('Retrieving information about character');
            $(div).load('{{ url('magic/show_character') }}/' + id, function(response, status, xhr) {
               if (status != 'success') {
                  $(div).text('');
                  alertify.alert('An unknown error occurred');
               }
               $("[contenteditable='true']").css('background-color', 'red');
            });
         }
         $(div).show();
      }
      function add_source(span) {
         // locate character id span > td > tr > tbody > table > div
         var id = $(span).parent().parent().parent().parent().parent().prop('id');
         id = id.split('-')[1];
         $('#popup').text('Retrieving form').width('auto').height('auto').css('max-width', '500').show().center();
         $('#popup').load('{{ action('CharMagicController@create') }}', function(response, status, xhr) {
            if (status != 'success') {
               alertify.alert('An unknown error occurred');
               return;
            }
            $('#frm-charmagic').validate({
               rules : {
                  skt   : { required : true, skt : true },
                  value : { required : true, num : true },
               },
               submitHandler: function(form) {
                  alertify.log('Submitting form');
                  $('#popup').hide();
               }
            });
            $('#popup').center();
         });
      }
      //-->
   </script>
@stop
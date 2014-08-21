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
      function extract_json(data) {
         try {
            data = $.parseJSON(data);
         } catch(e) {
            alertify.alert(e + "\nData: " + data.toSource());
            return false;
         }
         if (! data.success && data.message) {
            alertify.alert('Error: ' + data.message);
            if ( data.show_popup ) {
               $('#popup').show();
            }
         }
         return data;
      }
      function htmlescape(s) {
         return $('<div />').text(s).html();
      }
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
            });
         }
         $(div).show();
      }
      function add_source(span) {
         // locate character id span > td > tr > tbody > table > div
         var id = $(span).parent().parent().parent().parent().parent().prop('id');
         id = id.split('-')[1];
         $('#popup').text('Retrieving form').width('auto').height('auto').css('max-width', '500').show().center();
         $('#popup').load('{{ url('charmagic/create') }}/' + id, function(response, status, xhr) {
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
                  $(form).ajaxSubmit({
                     datatype : 'json',
                     url      : '{{ url('charmagic/create') }}',
                     type     : 'post',
                     success  : do_add_source
                  });
                  alertify.log('Submitting form');
                  $('#popup').hide();
               }
            });
            $('#popup').center();
            $('#frm-charmagic #quelle').focus();
         });
      }
      function do_add_source(data) {
         data = extract_json(data);
         if (data.success) {
            var row = '<tr id="cm-' + data.id + '">' +
               '<td>' + htmlescape(data.quelle) + '</td>' +
               '<td>' + data.value + '</td>' +
               '<td>' + htmlescape(data.tradition) + '</td>' +
               '<td>' + htmlescape(data.beschworung) + '</td>' +
               '<td>' + htmlescape(data.wesen) + '</td>' +
               '<td>' + data.skt + '</td>' +
               '<td>links</td>' +
               '</tr>';
            var last = $('div#char-' + data.character_id + ' tbody > tr:last');
            $(last).before(row);
            $(last).prev().effect('highlight', {}, 2000);
         }
      }
      //-->
   </script>
@stop
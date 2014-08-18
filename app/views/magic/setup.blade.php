@extends('layouts/magic')

@section('title')
   <title>DSA - Magic</title>
@stop

@section('content')
   <h3 onclick='toggle(this)'>Quellen</h3>
   <div id='quellen' style='display: none; max-width: 800px'></div>
   <h3 onclick='toggle(this)'>Instruktionen</h3>
   <div id='instruktionen' style='display: none; max-width: 800px'></div>
@stop

@section('javascript')
   <script type="text/javascript">
      <!--
      jQuery.fn.center = function () {
         this.css("position","absolute");
         this.css("top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) + $(window).scrollTop()) + "px");
         this.css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) + $(window).scrollLeft()) + "px");
         return this;
      }
      function extract_json(data) {
         try {
            data = $.parseJSON(data);
         } catch(e) {
            alertify.alert(e + "\nData: " + data.toSource());
            return false;
         }
         if (! data.success && data.message) {
            alertify.alert('Error: ' + data.message);
         }
         return data;
      }
      function htmlescape(s) {
         return $('<div />').text(s).html();
      }
      function toggle(h3) {
         // Fetch id from text
         var id = $(h3).text().toLowerCase();
         var div = $('div#' + id);
         if ($(div).is(':visible')) {
            $(div).hide();
            return;
         }
         if ($(div).html()) {
            $(div).show();
         } else {
            if (id == 'quellen') {
               url = '{{ action('QuellenController@index') }}';
            } else {
               url = '{{ action('InstruktionenController@index') }}';
            }
            $(div).load(url, function(response, status, xhr) {
               if (status != 'success') {
                  alertify.alert('Error: ' + status + ' occurred');
                  return;
               }
               $(div).show();
            });
         }
      }
      function add_quelle() {
         show_quelle('');
      }
      function show_quelle(span) {
         var id = 0; var url = '';
         if (span != '') {
            // Fetch id from parent span > td > tr
            id = $(span).parent().parent().prop('id').split('-')[1];
            url = '{{ url('quellen/edit') }}/' + id;
         } else {
            url = '{{ url('quellen/create') }}';
         }
         $('#popup').text('Retrieving form').width('auto').height('auto').css('max-width', '').show().center();
         $('#popup').load(url, function(response, status, xhr) {
            if (status != 'success') {
               alertify.alert('An unknown error occurred');
               return;
            }
            $('#popup').center();
            $('#form-quelle > #name').focus().select();
            $('#form-quelle').validate({
               rules : {
                  name : { required : true, maxlength : 64 },
                  desc : { maxlength : 4096 },
               },
               submitHandler : function(form) {
                  $(form).ajaxSubmit({
                     datatype : 'json',
                     url      : url,
                     type     : 'post',
                     success  : update_quelle,
                  });
                  $('#popup').hide();
               }
            });
         });
      }
      function update_quelle(data) {
         data = extract_json(data);
         if (data.success) {
            if (data.is_new) {
               // Add row
               var row = '<tr id="quelle-' + data.id + '">' +
                  '<td>' + htmlescape(data.name) + '</td>' +
                  '<td><span class="link-info" onclick="note_quelle(this)">description</span> ' +
                  '| <span class="link-edit" onclick="show_quelle(this)">edit</span> ' +
                  '| <span class="link-cancel" onclick="remove_quelle(this)">remove</span>' +
                  '</td></tr>';
               last = $('#tbl_quellen > tbody > tr:last');
               $(last).before(row);
               $(last).prev().effect('highlight', {}, 2000);
            } else {
               var td = $('#quelle-' + data.id + ' > td:first');
               $(td).text(data.name);
               $(td).parent().effect('highlight', {}, 2000);
            }
         }
      }
      function remove_quelle(span) {
         // Fetch id from parent span > td > tr
         var id = $(span).parent().parent().prop('id').split('-')[1];
         // Fetch name
         var name = $('#quelle-' + id + ' > td:first').text();
         alertify.confirm('Remove ' + name + '?', function(e) {
            if (e) {
               $.ajax({
                  datatype : 'json',
                  url      : '{{ url('quellen/delete') }}/' + id,
                  type     : 'post',
                  data     : { _method : 'DELETE' },
                  success  : do_remove_quelle
               });
            }
         });
      }
      function do_remove_quelle(data) {
         data = extract_json(data);
         if (data.success) {
            var tr = $('#quelle-' + data.id);
            $(tr).effect('highlight', {}, 2000);
            setTimeout(function() {
               $(tr).remove()
            }, 500);
         }
      }
      function note_quelle(span) {
         // Fetch id from parent span > td > tr
         var id = $(span).parent().parent().prop('id').split('-')[1];
         $('#popup').text('Retrieving description').width('auto').height('auto').css('max-width', '700px').show().center();
         $('#popup').load('{{ url('quellen/description/') }}/' + id, function(response, status, xhr) {
            if (status != 'success') {
               alertify.alert('An unknown error occurred');
               return;
            }
            $('#popup').center();
         });
      }
      function add_instruktion() {
         show_instruktion('');
      }
      function show_instruktion(span) {
         var id = 0; var url = '';
         if (span != '') {
            // Fetch id from parent span > td > tr
            id = $(span).parent().parent().prop('id').split('-')[1];
            url = '/instruktionen/' + id;
         } else {
            url = '{{ action('InstruktionenController@create') }}';
         }
         $('#popup').text('Retrieving form').width('auto').height('auto').css('max-width', '').show().center();
         // $('#popup').load('magic_setup.php', { stage : 'form-instruktion', id : id }, function(response, status, xhr) {
         $('#popup').load(url, function(response, status, xhr) {
            if (status != 'success') {
               alertify.alert('An unknown error occurred');
               return;
            }
            $('#popup').center();
            $('#form-instruktion > #name').focus().select();
            $('#form-instruktion').validate({
               rules : {
                  name : { required : true, maxlength : 64 },
                  desc : { maxlength : 4096 },
               },
               submitHandler : function(form) {
                  if (! id) { url = '{{ action('InstruktionenController@store') }}'; }
                  $(form).ajaxSubmit({
                     datatype : 'json',
                     url      : url,
                     type     : 'post',
                     success  : update_instruktion,
                  });
                  $('#popup').hide();
               }
            });
         });
      }
      function update_instruktion(data) {
         data = extract_json(data);
         if (data.success) {
            if (data.is_new) {
               // Add row
               var row = '<tr id="instruktion-' + data.id + '">' +
                  '<td>' + htmlescape(data.name) + '</td>' +
                  '<td><span class="link-info" onclick="note_instruktion(this)">description</span> ' +
                  '| <span class="link-edit" onclick="show_instruktion(this)">edit</span> ' +
                  '| <span class="link-cancel" onclick="remove_instruktion(this)">remove</span>' +
                  '</td></tr>';
               last = $('#tbl_instruktionen > tbody > tr:last');
               $(last).before(row);
               $(last).prev().effect('highlight', {}, 2000);
            } else {
               var td = $('#instruktion-' + data.id + ' > td:first');
               $(td).text(data.name);
               $(td).parent().effect('highlight', {}, 2000);
            }
         }
      }
      function remove_instruktion(span) {
         // Fetch id from parent span > td > tr
         var id = $(span).parent().parent().prop('id').split('-')[1];
         // Fetch name
         var name = $('#instruktion-' + id + ' > td:first').text();
         alertify.confirm('Remove ' + name + '?', function(e) {
            if (e) {
               $.ajax({
                  datatype : 'json',
                  url      : '{{ url('instruktionen') }}/' + id,
                  type     : 'post',
                  data     : { _method : 'DELETE' },
                  success  : do_remove_instruktion
               });
            }
         });
      }
      function do_remove_instruktion(data) {
         data = extract_json(data);
         if (data.success) {
            var tr = $('#instruktion-' + data.id);
            $(tr).effect('highlight', {}, 2000);
            setTimeout(function() {
               $(tr).remove()
            }, 500);
         }
      }
      function note_instruktion(span) {
         // Fetch id from parent span > td > tr
         var id = $(span).parent().parent().prop('id').split('-')[1];
         $('#popup').text('Retrieving description').width('auto').height('auto').css('max-width', '500').show().center();
         $('#popup').load('{{ url('instruktionen/description') }}/' + id, function(response, status, xhr) {
            if (status != 'success') {
               alertify.alert('An unknown error occurred');
               return;
            }
            $('#popup').center();
         });
      }
      //-->
   </script>
@stop
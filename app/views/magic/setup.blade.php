@extends('layouts/magic')

@section('title')
   <title>DSA - Magic</title>
@stop

@section('content')
   <h3 onclick="toggle(this)">Quellen</h3>
   <div id="quellen" class="maxed" style="display: none"></div>
   <h3 onclick="toggle(this)">Instruktionen</h3>
   <div id="instruktionen" class="maxed" style="display: none"></div>
   <h3 onclick="toggle(this)">Creatures</h3>
   <div id="creatures" class="maxed" style="display: none"></div>
@stop

@section('javascript')
   <script type="text/javascript">
      <!--
      $('body').css('background-image', 'url(/images/bg-magicsetup.png)');
      jQuery.fn.center = function () {
         this.css("position","absolute");
         this.css("top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) + $(window).scrollTop()) + "px");
         this.css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) + $(window).scrollLeft()) + "px");
         return this;
      }
      $.validator.addMethod('num', function(value, element, parameter) {
         return this.optional(element) || parseInt(value) == value;
      }, 'Value must be an integer');
      $.validator.addMethod('tp', function(value, element) {
         return this.optional(element) || value.match(/^\d+[dwDW]\d+(\+\d+)$/);
      }, 'Format like f.e. 1d6+1');

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
         if (id == 'quellen') {
            url = '{{ action('QuellenController@index') }}';
         } else if (id == 'instruktionen') {
            url = '{{ action('InstruktionenController@index') }}';
         } else {
            url = '/creatures/list';
         }
         $(div).load(url, function(response, status, xhr) {
            if (status != 'success') {
               alertify.alert('Error: ' + status + ' occurred');
               return;
            }
            $(div).show();
         });
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
      function select_quelle(li) {
         var $li = $(li);
         var id = $li.prop('id').split('-')[1];
         $li.parent().children('li').removeClass('highlight');
         $li.addClass('highlight');
         $('div#quelle-creatures').html('<hr>Retrieving creatures')
                                  .load('/creatures/setup/' + id, function(response, status, xhr) {
            if (status != 'success') {
               alertify.alert('Unknown error occurred');
            }
         });
      }
      function edit_creature(li) {
         var url = '/creatures/new/';
         if (li !== null) {
            var id = $(li).prop('id').split('-')[1];
            url = '/creatures/edit/' + id;
         }
         var $popup = $('#popup');
         $popup.text('Retrieving creature data')
               .width('auto')
               .height('auto')
               .css('max-width', '500')
               .show()
               .center()
               .load(url, function(response, status, xhr) {
            if (status != 'success') {
               alertify.alert('Unknown error occurred');
               return;
            }
            $popup.center().find('#name').focus().select();
            if (li === null) {
               {{-- Set the quelle to the highlighted one --}}
               var quelle_id = $('ul#list-quellen > li.highlight').first().prop('id').split('-')[1];
               $popup.find('#quelle').val(quelle_id);
            }
            $popup.find('#frm-creature').validate({
               rules : {
                  name         : { required : true, maxlength : 64 },
                  beschworung  : { required : true, num : true },
                  beherrschung : { required : true, num : true },
                  quelle       : { required : true },
                  le           : { digits : true },
                  ae           : { digits : true },
                  rs           : { digits : true },
                  ini          : { tp : true },
                  gs           : { number : true, min : 0 },
                  mr           : { digits : true },
                  gw           : { digits : true },
               },
               submitHandler : function(form) {
                  $(form).ajaxSubmit({
                     datatype : 'json',
                     url      : '/creatures/edit',
                     type     : 'post',
                     success  : do_edit_creature,
                  });
                  $popup.hide();
               },
            });
         });
      }
      function do_edit_creature(data) {
         data = extract_json(data);
         if (data.success) {
            if (data.is_new) {
               // Add creature to list
               $('ul#creature-list').append('<li id="creature-' + data.id + '" onclick="edit_creature(this)">' + htmlescape(data.name) + '</li>')
                                    .effect('highlight', {}, 2000);
            } else {
               // Edit name of creature
               $('ul#creature-list li#creature-' + data.id).text(htmlescape(data.name))
                                                           .effect('highlight', {}, 2000);
            }
         }
      }
      //-->
   </script>
@stop
{extends file='base.tpl'}
{block name='title'}DSA - setup{/block}
{block name='menu_left'}{include file='setup_menu.tpl' selected_category='Kampftechniken'}{/block}
{block name='main'}
   <div id="main">
      <h3 onclick="toggle_h3('talente')">Talente</h3>
      <div id='talente' class="maxed" style="display: none"></div>
      <h3 onclick="toggle_h3('sonderfertigkeiten')">Sonderfertigkeiten</h3>
      <div id='sonderfertigkeiten' class="maxed" style="display: none"></div>
   </div>
{/block}
{block name='javascript'}
   <script type="text/javascript">
      <!--
      $(document).ready(function() {
         // Add validation method
         $.validator.addMethod('num', function(value, element, parameter) {
            return this.optional(element) || parseInt(value) == value;
         }, 'Value must be an integer');
      });
      jQuery.fn.center = function () {
          this.css("position","absolute");
          this.css("top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) +
                                                      $(window).scrollTop()) + "px");
          this.css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) +
                                                      $(window).scrollLeft()) + "px");
          return this;
      }
      function show_talente() {
         $('div#talente').load('setup_kampftechniken.php', { stage : 'show_talente' }, function(response, status, xhr) {
            if (status != 'success') {
               alertify.alert('An unknown error occurred');
               return;
            }
            $('div#talente').show();
            // Make table sortable
            $('div#talente #table_kampftechniken').tablesorter({ headers : { 2: { sorter: false },
                                                                             3: { sorter: false },
                                                                             4: { sorter: false }}});
         });
      }
      function htmlescape(s) {
         return $('<div />').text(s).html();
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
      function edit_kampftechnik(span) {
         var id = 0;
         if (span != '') {
            // Fetch id from parent span > td > tr
            id = $(span).parent().parent().prop('id').split('_')[1];
         }
         // Prepare popup
         $('#popup').text('Retrieving data').width('auto').height('auto').css('max-width', '').show().center();
         $('#popup').load('setup_kampftechniken.php',
                          { stage : 'frm_kampftechnik', id : id },
                          function(response, status, xhr) {
            if (status != 'success') {
               alertify.alert('An unknown error occurred');
               return;
            }
            $('#popup').center();
            $('#frm_kampftechniken #name').focus().select();
            $('#frm_kampftechniken').validate({
               rules        : {
                  name : { required : true },
                  skt  : { required : true, minlength: 1, maxlength: 1 },
                  be   : { num   : true },
               },
               submitHandler: function(form) {
                  $(form).ajaxSubmit({
                     success : do_update_kampftechnik,
                     // beforeSubmit: showRequest,
                     type    : 'post',
                     url     : 'setup_kampftechniken.php',
                     datatype: 'json'
                  });
                  $('#popup').hide();
               }
            });
         });
      }
      function remove_kampftechnik(span) {
         // Fetch row for id and name
         var row = $(span).parent().parent();
         // Fetch name to display in alert
         var name = $(row).children(':first').text();
         alertify.confirm('Remove ' + name + '?', function(e) {
            if (e) {
               var id = $(row).prop('id').split('_')[1];
               $.ajax({
                  datatype : 'json',
                  type     : 'post',
                  url      : 'setup_kampftechniken.php',
                  data     : { stage : 'remove',
                               id    : id },
                  success  : do_remove_kampftechnik
               });
            }
         });
      }
      function do_remove_kampftechnik(data) {
         data = extract_json(data);
         if (data.success) {
            var row = '#table_kampftechniken #row_' + data.id;
            $(row).effect('highlight', {}, 2000);
            setTimeout(function() {
               $(row).remove();
            }, 500);
         }
      }
      function do_update_kampftechnik(data) {
         data = extract_json(data);
         if (data.success) {
            var cell_ua = '&nbsp;';
            if (data.unarmed) {
               cell_ua = '<img src="images/bullet_orange.png" border="0" width="16" height="16" />';
            }
            if (data.is_new) {
               // Add to table
               var elem = '<tr id="row_' + data.id + '">' +
                  '<td id="cell_name">' + htmlescape(data.name) + '</td>' +
                  '<td id="cell_skt">' + htmlescape(data.skt) + '</td>' +
                  '<td id="cell_be">' + htmlescape(data.be) + '</td>' +
                  '<td id="cell_ua">' + cell_ua + '</td>' +
                  '<td>' +
                  '<span class="link-edit" onclick="edit_kampftechnik(this)">edit</span>' +
                  ' | <span class="link-cancel" onclick="remove_kampftechnik(this)">remove</span>' +
                  '</td>' +
                  '</tr>';
               $('#talente #table_kampftechniken tbody').append(elem);
               $('#table_kampftechniken #row_' + data.id).effect('highlight', {}, 2000);
            } else {
               var row = '#table_kampftechniken #row_' + data.id;
               $(row + ' #cell_name').text(data.name);
               $(row + ' #cell_skt').text(data.skt);
               $(row + ' #cell_be').text(data.be);
               $(row + ' #cell_ua').html(cell_ua);
               $(row).effect('highlight', {}, 2000);
            }
         }
      }
      function toggle_h3(div_name) {
         var div = 'h3 + div#' + div_name;
         if ($(div).is(':visible')) {
            $(div).hide();
            return;
         }
         if ($(div).html()) {
            $(div).show();
         } else {
            if (div_name == 'sonderfertigkeiten') {
               fetch_sonderfertigkeiten();
            } else {
               show_talente();
            }
         }
      }
      function fetch_sonderfertigkeiten() {
         $('div#sonderfertigkeiten').load('setup_kampftechniken.php',
                                          { stage : 'fetch_sf' },
                                          function(repsonse, status, xhr) {
            if (status != 'success') {
               alertify.alert('An unknown error occurred');
               return;
            }
            // Make table sortable
            $('div#sonderfertigkeiten #kampf_sf').tablesorter({ headers : { 3: { sorter: false },
                                                                            4: { sorter: false }}});
            $('div#sonderfertigkeiten').show();
         });
      }
      function show_note(span) {
         // Fetch id from parent span > td > tr
         var id = $(span).parent().parent().prop('id');
         $('#popup').text('Retrieving data').width('auto').height('auto').css('max-width', '500px').show().center();
         $('#popup').load('setup_kampftechniken.php',
                          { stage : 'note_sf', id : id },
                          function(response, status, xhr) {
            if (status != 'success') {
               alertify.alert('An unknown error occurred');
               return;
            }
            $('#popup').center();
         });
      }
      function edit_sf(span) {
         var id = 0;
         if (span != '') {
            id = $(span).parent().parent().prop('id');
         }
         $('#popup').text('Retrieving datat').width('auto').height('auto').css('max-width', '').show().center();
         $('#popup').load('setup_kampftechniken.php',
                          { stage : 'frm_sonderfertigkeit', id : id },
                          function(response, status, xhr) {
            if (status != 'success') {
               alertify.alert('An unknown error occurred');
               return;
            }
            $('#popup').center();
            // Set focus
            $('form#frm_sf #name').focus().select();
            // Add validation to form
            $('form#frm_kampf_sf').validate({
               rules        : {
                  name   : { required : true },
                  effect : { required : true },
                  ap     : { num : true },
                  gp     : { num : true },
               },
               submitHandler: function(form) {
                  $(form).ajaxSubmit({
                     success : do_update_kampf_sf,
                     type    : 'post',
                     url     : 'setup_kampftechniken.php',
                     datatype: 'json'
                  });
                  $('#popup').hide();
               }
            });
         });
      }
      function do_update_kampf_sf(data) {
         data = extract_json(data);
         if (data.success) {
            var row_id = 'tr#' + data.id;
            if (data.is_new) {
               // Add row
               var row = '<tr id="' + data.id + '">' +
                  '<td id="name">' + htmlescape(data.name) + '</td>' +
                  '<td id="gp">' + data.gp + '</td>' +
                  '<td id="ap">' + data.ap + '</td>' +
                  '<td id="effect">' + htmlescape(data.effect) + '</td>' +
                  '<td>' +
                     '<span class="link-info" onclick="show_note(this)">note</span>' +
                     ' | <span class="link-edit" onclick="edit_sf">edit</span>' +
                     ' | <span id="remove" class="link-cancel" onclick="remove_kampf_sf(' + data.id + ')">remove</span>' +
                  '</td></tr>';
               $('table#kampf_sf tbody').append(row);
               add_simpletip_sf($('table#kampf_sf tr#' + data.id).find('#edit'), data.id);
            } else {
               // change row
               $(row_id).children('#name').text(data.name);
               $(row_id).children('#gp').text(data.gp);
               $(row_id).children('#ap').text(data.ap);
               $(row_id).children('#effect').text(data.effect);
            }
            $(row_id).effect('highlight', {}, 2000);
         }
      }
      function remove_kampf_sf(id) {
         var selector = 'table#kampf_sf tr#' + id + ' td#name';
         var td = $('table#kampf_sf tr#' + id).find('#name');
         var name = $(td).text();
         alertify.confirm('Remove ' + name + '?', function(e) {
            if (e) {
               $.ajax({
                  datatype : 'json',
                  type     : 'post',
                  url      : 'setup_kampftechniken.php',
                  data     : { stage : 'remove_sf',
                               id    : id },
                  success  : do_remove_sf
               });
               alertify.log('Removing sonderfertigkeit ' + name);
            }
         });
      }
      function do_remove_sf(data) {
         data = extract_json(data);
         if (data.success) {
            var row = 'table#kampf_sf tr#' + data.id;
            $(row).effect('highlight', {}, 2000);
            setTimeout(function() {
               $(row).remove();
            }, 500);
         }
      }
      //-->
   </script>
{/block}

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
   <head>
      <title>DSA - setup</title>
      <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
      <link href="css/dsa.css" rel="stylesheet" type="text/css" />
      <link href="css/alertify.css" rel="stylesheet" type="text/css" />
   </head>
   <body>
      {include file="head.tpl"}
      {include file="setup_menu.tpl" selected_category="Kampftechniken"}
      <div style="float: left">
         <div id="main">
            <h3 onclick="toggle_h3('talente')">Talente</h3>
            <div id='talente' style="display: none"></div>
            <h3 onclick="toggle_h3('sonderfertigkeiten')">Sonderfertigkeiten</h3>
            <div id='sonderfertigkeiten' style="display: none">
               Sonderfertigkeiten
            </div>
         </div>
      </div>
      <script src="scripts/jquery.js"></script>
      <script src="tools/jquery-ui-1.10.4/ui/minified/jquery-ui.min.js"></script>
      <script type="text/javascript" src="scripts/alertify.min.js"></script>
      <script type="text/javascript" src="scripts/jquery.validate.min.js"></script>
      <script type="text/javascript" src="scripts/jquery.form.min.js"></script>
      <script type="text/javascript" src="scripts/jquery.simpletip-1.3.1.min.js"></script>
      <script type="text/javascript" src="scripts/jquery.tablesorter.min.js"></script>
      <script type="text/javascript">
         <!--{literal}
         hasData = {};
         $(document).ready(function() {
            // Activate talente
            show_talente();
            // Add validation method
            $.validator.addMethod('num', function(value, element, parameter) {
               return this.optional(element) || parseInt(value) == value;
            }, 'Value must be an integer');
         });
         function show_talente() {
            $.ajax({
               datatype : 'json',
               type     : 'post',
               url      : 'setup_kampftechniken.php',
               data     : {stage : 'show_talente'},
               success  : do_show_talente
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
         function attach_simpletip_frm(elem, id) {
            // places the simpletip on the specified element
            $(elem).simpletip({
               onBeforeShow : function() {
                  this.load('setup_kampftechniken.php', {stage : 'frm_kampftechnik',
                                                         id    : id});
               },
               onContentLoad : function() {
                  // Set focus
                  $('#frm_kampftechniken #name').focus().select();
                  // Add validation to form
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
                        close_kt_box();
                        return false;
                     }
                  });
               },
               persistent   : true,
               focus        : true
            });
            return false;
         }
         function do_show_talente(data) {
            data = extract_json(data);
            if (data.success) {
               $('#main div#talente').html(data.div);
               // Make table sortable
               $('div#talente #table_kampftechniken').tablesorter({headers : { 2: {sorter: false},
                                                                               3: {sorter: false},
                                                                               4: {sorter: false}}});
               // Add simpletip to button
               attach_simpletip_frm('#btn_add_kampftechnik', 0);
               // Add simpletip to links
               $('#table_kampftechniken span[id^=link_edit]').each(function() {
                  var id = $(this).prop('id');
                  var dummy = id.split('_');
                  attach_simpletip_frm('#' + id, dummy[2]);
               });
               // Add remove function to links
               $('tr[id^=row_] span[id^=link_remove_]').each(function(index) {
                  // Fetch id from name
                  var id = $(this).prop('id');
                  var dummy = id.split('_');
                  $(this).unbind('click').click(function() {remove_kampftechnik(dummy[2])});
               })
               hasData['talente'] = true;
               toggle_h3('talente');
            }
         }
         function close_kt_box() {
            var id = parseInt($('#frm_kampftechniken #id').val()) || 0;
            if (id == 0) {
               // Pop-up attached to btn
               $('#btn_add_kampftechnik').eq(0).simpletip().hide();
            } else {
               // Pop-up attached to row
               $('#table_kampftechniken #link_edit_' + id).eq(0).simpletip().hide();
            }
         }
         function remove_kampftechnik(id) {
            // Fetch name to display in alert
            var name = $('#table_kampftechniken #row_' + id + ' #cell_name').text();
            alertify.confirm('Remove ' + name + '?', function(e) {
               if (e) {
                  $.ajax({
                     datatype : 'json',
                     type     : 'post',
                     url      : 'setup_kampftechniken.php',
                     data     : {stage : 'remove',
                                 id    : id},
                     success  : do_remove_kampftechnik
                  });
                  alertify.log('Removing kampftechnik ' + name);
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
                     '<td id="cell_ua">' + cell_ua + '</td>';
                     '<td>' +
                     '<span id="link_edit_' + data.id + '" class="link-edit">edit</span>' +
                     ' | <span id="link_remove_' + data.id + '" class="link-cancel">remove</span>' +
                     '</td>' +
                     '</tr>';
                  $('#talente #table_kampftechniken tbody').append(elem);
                  $('#table_kampftechniken #row_' + data.id).effect('highlight', {}, 2000);
                  attach_simpletip_frm('#table_kampftechniken #link_edit_' + data.id);
                  $('#link_remove_' + data.id).unbind('click').click(function() {remove_kampftechnik(data.id)});
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
            $('h3 + div').each(function(index, value) {
               if (div_name != $(value).prop('id')) {
                  $(value).slideUp();
               }
            });
            if (! hasData[div_name]) {
               if (div_name == 'sonderfertigkeiten') {
                  fetch_sonderfertigkeiten();
               }
            } else {
               $('h3 + div#' + div_name).slideDown();
            }
         }
         function fetch_sonderfertigkeiten() {
            // make ajax-call to get the sonderfertigkeiten
            $.ajax({
               datatype : 'json',
               type     : 'post',
               url      : 'setup_kampftechniken.php',
               data     : { stage : 'fetch_sf' },
               success  : show_sonderfertigkeiten,
            });
         }
         function show_sonderfertigkeiten(data) {
            data = extract_json(data);
            if (data.success) {
               var div = 'div#main div#sonderfertigkeiten';
               $(div).html(data.out);
               $(div).slideDown();
               // Make table sortable
               $('div#sonderfertigkeiten #kampf_sf').tablesorter({headers : { 3: {sorter: false},
                                                                              4: {sorter: false}}});
               hasData['sonderfertigkeiten'] = true;
               // Add simpletip to button
               add_simpletip_sf($('#btn_add_sf'));
               // Add simpletip to edit-fields
               $('table#kampf_sf tr').each(function() {
                  var id = $(this).prop('id');
                  add_simpletip_sf($(this).find('#edit'), id);
                  add_note_sf($(this).find('#note'), id);
               });
            }
         }
         function add_note_sf(elem, id) {
            $(elem).unbind('click');
            $(elem).simpletip({
               onBeforeShow : function() {
                  this.load('setup_kampftechniken.php', {stage : 'note_sf',
                                                         id    : id});
               },
               persistent   : true,
               focus        : true,
            })
         }
         function add_simpletip_sf(elem, id) {
            // places the simpletip for sonderfertigkeiten on the specified element
            $(elem).unbind('click');
            $(elem).simpletip({
               onBeforeShow : function() {
                  this.load('setup_kampftechniken.php', {stage : 'frm_sonderfertigkeit',
                                                         id    : id});
               },
               onHide       : function() {
                  $('form#frm_kampf_sf').remove();
               },
               onContentLoad : function() {
                  // Set focus
                  $('form#frm_sf #name').focus().select();
                  // Add validation to form
                  $('form#frm_kampf_sf').validate({
                     rules        : {
                        name   : 'required',
                        effect : 'required',
                        ap     : 'digits',
                        gp     : 'digits',
                     },
                     submitHandler: function(form) {
                        $(form).ajaxSubmit({
                           success : do_update_kampf_sf,
                           type    : 'post',
                           url     : 'setup_kampftechniken.php',
                           datatype: 'json'
                        });
                        close_frm_kampf_sf();
                        return false;
                     }
                  });
               },
               persistent   : true,
               focus        : true
            });
            return false;
         }
         function close_frm_kampf_sf() {
            var id = $('form#kampf_sf #id').val();
            if (id > 0) {
               // edit
               $('table#kampf_sf tr#' + id + ' #edit').eq(0).simpletip().hide();
            } else {
               // new sf, close from button
               $('#btn_add_sf').eq(0).simpletip().hide();
            }
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
                        '<span id="note" class="link-info">note</span>' +
                        ' | <span id="edit" class="link-edit">edit</span>' +
                        ' | <span id="remove" class="link-cancel" onclick="remove_kampf_sf(' + data.id + ')">remove</span>' +
                     '</td></tr>';
                  $('table#kampf_sf tbody').append(row);
                  add_simpletip_sf($('table#kampf_sf tr#' + data.id).find('#edit'), data.id);
                  add_note_sf($('table#kampf_sf tr#' + data.id).find('#note'), data.id);
               } else {
                  // change row
                  $(row_id + ' #name').text(data.name);
                  $(row_id + ' #gp').text(data.gp);
                  $(row_id + ' #ap').text(data.ap);
                  $(row_id + ' #effect').text(data.effect);
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
                     data     : {stage : 'remove_sf',
                                 id    : id},
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
         //-->{/literal}
      </script>
   </body>
</html>

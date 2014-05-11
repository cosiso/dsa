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
         $(document).ready(function() {
            // Activate talente
            show_talente();
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
                        name : {
                           required : true
                        },
                        skt  : {

                           required : true,
                           minlength: 1,
                           maxlength: 1
                        },
                        be   : {
                           number   : true
                        }
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
                                                                               3: {sorter: false}}});
               // Add simpletip to button
               attach_simpletip_frm('#btn_add_kampftechnik', 0);
               // Add simpletip to links
               $('#table_kampftechniken a[id^=link_edit]').each(function() {
                  var id = $(this).prop('id');
                  var dummy = id.split('_');
                  attach_simpletip_frm('#' + id, dummy[2]);
               });
               // Add remove function to links
               $('tr[id^=row_] a[id^=link_remove_]').each(function(index) {
                  // Fetch id from name
                  var id = $(this).prop('id');
                  var dummy = id.split('_');
                  $(this).unbind('click').click(function() {remove_kampftechnik(dummy[2])});
               })
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
               if (data.is_new) {
                  // Add to table
                  var elem = '<tr id="row_' + data.id + '">' +
                     '<td id="cell_name">' + htmlescape(data.name) + '</td>' +
                     '<td id="cell_skt">' + htmlescape(data.skt) + '</td>' +
                     '<td id="cell_be">' + htmlescape(data.be) + '</td>' +
                     '<td>' +
                     '<a id="link_edit_' + data.id + '" href="#" class="link-edit">edit</a>' +
                     ' | <a id="link_remove_' + data.id + '" href="#" class="link-cancel">remove</a>' +
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
            $('h3 + div#' + div_name).slideDown();
         }
         //-->{/literal}
      </script>
   </body>
</html>
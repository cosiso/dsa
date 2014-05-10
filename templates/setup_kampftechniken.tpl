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
         function do_show_talente(data) {
            data = extract_json(data);
            if (data.success) {
               $('#main div#talente').html(data.div);
               // Make table sortable
               $('div#talente #table_kampftechniken').tablesorter({headers : { 2: {sorter: false},
                                                                               3: {sorter: false}}});
               // Add simpletip to button
               $('#btn_add_kampftechnik').simpletip({
                  onBeforeShow : function() {
                     this.load('setup_kampftechniken.php', {stage : 'frm_kampftechnik',
                                                            id    : 0});
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
               toggle_h3('talente');
            }
         }
         function close_kt_box() {
            var id = parseInt($('#frm_kampftechniken #id').val()) || 0;
            if (id == 0) {
               // Pop-up attached to btn
               $('#btn_add_kampftechnik').eq(0).simpletip().hide();
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
                     '<td>&nbsp;</td>';
                  $('#talente #table_kampftechniken tbody').append(elem);
                  $('#table_kampftechniken #row_' + data.id).effect('highlight', {}, 2000);
            /*
            var elem = '<tr id="vorteil_' + data.id + '">' +
                   '<td id="cell_img"><img src="images/' + img_src + '" border="0" /></td>' +
                   '<td id="cell_name">' + htmlescape(data.name) + '</td>' +
                   '<td id="cell_value">' + htmlescape(data.value) + '</td>' +
                   '<td id="cell_effect">' + htmlescape(data.effect) + '</td>' +
                   '<td id="cell_note">' + htmlescape(data.note) + '</td>' +
                   '<td>' +
                      '<a id="vorteile_link_desc" href="#" class="link-info">description</a>' +
                      ' | <a id="vorteile_link_edit" href="#" class="link-edit">edit</a>' +
                      ' | <a id="cell_remove" href="#" class="link-cancel" onclick="remove_vorteil(' + data.id + ', \'' + htmlescape(data.name) + '\')">remove</a>' +
                   '</td></tr>';
            $('#table_vorteile tbody').append(elem);
            $(row).effect('highlight', {}, 2000);
            add_simpletip_desc_to_link(row + ' #vorteile_link_desc');
            add_simpletip_edit_to_link(row + ' #vorteile_link_edit');
            */
               } else {
                  // Modify table
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
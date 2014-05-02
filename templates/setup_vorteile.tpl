<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
   <head>
      <title>DSA - setup</title>
      <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
      <link href="css/dsa.css" rel="stylesheet" type="text/css" />
   </head>
   <body>
      {include file="head.tpl"}
      {include file="setup_menu.tpl" selected_category="Vorteile"}
      <div style="float: left">
         <div id="main">
            <h3 onclick="toggle_h3(this)">Vorteile</h3>
            <div id="vorteile" style="display: none">
               <table id="table_vorteile" cellspacing="0" cellpadding="1" class="sortable">
                  <thead>
                     <tr>
                        <th>Name</th>
                        <th>GP</th>
                        <th>AP</th>
                        <th>Effect</th>
                        <th>&nbsp;</th>
                     </tr>
                  </thead>
                  <tbody class="hover">
                     {section name=idx loop=$vorteile}
                        <tr id="vorteil_{$vorteile[idx].id}">
                           <td id="cell_name">{$vorteile[idx].name|escape}</td>
                           <td id="cell_gp">{$vorteile[idx].gp|escape}</td>
                           <td id="cell_ap">{$vorteile[idx].ap|escape}</td>
                           <td id="cell_effect">{$vorteile[idx].effect}</td>
                           <td id="cell_links">
                              <span id="span_desc_{$vorteile[idx].id}" style="display: none"></span>
                              <a id="tip_desc_{$vorteile[idx].id}" href="#" class="link-info">info</a>
                              | <a id="edit_desc_{$vorteile[idx].id}" href="#" class="link-edit">edit</a>
                              | <a href="#" onclick="alert('delete')" class="link-cancel">remove</a>
                           </td>
                        </tr>
                     {/section}
                  </tbody>
               </table>
               {if ! $vorteile}
                  <div id="div_no_vorteile">No vorteile defined yet</div>
               {/if}
               <br />
               <a id="btn_add_vorteil" class="link-add" href="#">Add vorteil</a>
            </div>
            <h3 onclick="toggle_h3(this)">Nachteile</h3>
            <div id="nachteile" style="display: none">
               <table id="table_nachteile" cellspacing="0" cellpadding="1" class="sortable">
                  <thead>
                     <tr>
                        <th>Name</th>
                        <th>GP</th>
                        <th>AP</th>
                        <th>Effect</th>
                        <th>&nbsp;</th>
                     </tr>
                  </thead>
                  <tbody class="hover">
                     {section name=idx loop=$nachteile}
                        <tr id="vorteil_{$nachteile[idx].id}">
                           <td id="cell_name">{$nachteile[idx].name|escape}</td>
                           <td id="cell_gp">{$nachteile[idx].gp|escape}</td>
                           <td id="cell_ap">{$nachteile[idx].ap|escape}</td>
                           <td id="cell_effect">{$nachteile[idx].effect}</td>
                           <td id="cell_links">
                              <span id="span_desc_{$nachteile[idx].id}" style="display: none"></span>
                              <a id="tip_desc_{$nachteile[idx].id}" href="#" class="link-info">info</a>
                              | <a id="edit_desc_{$nachteile[idx].id}" href="#" class="link-edit">edit</a>
                              | <a href="#" onclick="alert('delete')" class="link-cancel">remove</a>
                           </td>
                        </tr>
                     {/section}
                  </tbody>
               </table>
               {if ! $nachteile}
                  <div id="div_no_nachteile">No nachteile defined yet</div>
               {/if}
               <br />
               <a id="btn_add_nachteil" class="link-add" href="#">Add nachteil</a>
            </div>
         </div>
      </div>
      <script src="scripts/jquery.js"></script>
      <script src="tools/jquery-ui-1.10.4/ui/minified/jquery-ui.min.js"></script>
      <script type="text/javascript" src="scripts/jquery.validate.min.js"></script>
      <script type="text/javascript" src="scripts/jquery.form.min.js"></script>
      <script type="text/javascript" src="scripts/jquery.simpletip-1.3.1.min.js"></script>
      <script type="text/javascript" src="scripts/jquery.tablesorter.min.js"></script>
      <script type="text/javascript">
         <!--{literal}
         $(document).ready(function() {
            // Make tables sortable
            $('#table_vorteile').tablesorter({headers : { 3: {sorter: false},
                                                          4: {sorter: false}}});
            $('#table_nachteile').tablesorter({headers : { 3: {sorter: false},
                                                           4: {sorter: false}}});
            // Set simpletips on info fields
            $('a[id^="tip_desc"]').each(function(index, value) {
               add_simpletip_to_info($(this));
            });
            // Set simpletips on edit links
            $('a[id^="edit_desc"]').each(function(index, value) {
               add_simpletip_to_edit($(this));
            });
            // Set simpletip on add_buttons
            $('#btn_add_vorteil').simpletip({
               persistent    : true,
               focus         : true,
               onBeforeShow  : function() {
                  this.load('setup_vorteile.php', {'stage'   : 'popup_edit',
                                                   'vorteil' : 1,
                                                   'id'      : 0});
               },
               onContentLoad : add_popup_validation
            });
            $('#btn_add_nachteil').simpletip({
               persistent    : true,
               focus         : true,
               onBeforeShow  : function () {
                  this.load('setup_vorteile.php', {'stage'   : 'popup_edit',
                                                   'vorteil' : 0,
                                                   'id'      : 0});
               },
               onContentLoad : add_popup_validation
            });
         })
         function destroy_popup_form() {
            var form = $('#frm_vorteil').unbind('validate');
            form.remove();
         }
         function add_simpletip_to_info(elem) {
            // The id is in the form tip_desc_<id>
            var id = elem.attr('id');
            var arr_id = id.split('_');
            id = arr_id[2];
            elem.simpletip({
               persistent    : true,
               onBeforeShow  : function() {
                  this.load('setup_vorteile.php', {'stage': 'tip_description',
                                                   'id'   : id});
               }
            })
         }
         function add_simpletip_to_edit(elem) {
            // id is in the form edit_desc_<id>
            var id = elem.attr('id');
            var arr_id = id.split('_');
            id = arr_id[2];
            // Set simpletip with load function on each link
            elem.simpletip({
               persistent    : true,
               focus         : true,
               onBeforeHide  : destroy_popup_form,
               onBeforeShow  : function() {
                  // Find whether this is a vorteil
                  var table_id = $('#edit_desc_' + id).closest('table').attr('id');
                  // table_id = table_vorteile or table_nachteile
                  var dummy = table_id.split('_');
                  this.load('setup_vorteile.php', {'stage'  : 'popup_edit',
                                                   'vorteil': (dummy[1] == 'vorteile') ? 1 : 0,
                                                   'id'     : id});
               },
               onContentLoad : add_popup_validation
            });
         }
         function add_popup_validation() {
            // Focus name-field in form
            $('#frm_vorteil #name').focus().select();
            // Adds validation to the form in the popup
            $('#frm_vorteil').validate({
               submitHandler: function(form) {
                  $(form).ajaxSubmit({
                     success : do_update_vorteil,
                     // beforeSubmit: showRequest,
                     type    : 'post',
                     datatype: 'json'
                  });
                  close_edit_box();
                  return false;
               }
            });
         }
         function close_edit_box() {
            var api;
            // Find element to which simpletip was added
            var id = $('#frm_vorteil #id').val();
            console.log('ID: ' + id);
            if (id == '' || id == '0') {
               // We were called with an add button
               console.log('Which add button??');
               // Check if vorteil is 1
               var vorteil = $('#frm_vorteil #is_vorteil').val();
               console.log('Vorteil: ' + vorteil);
               if (vorteil == '1') {
                  api = $('#btn_add_vorteil').eq(0).simpletip();
               } else {
                  api = $('#btn_add_nachteil').eq(0).simpletip();
               }
            } else {
               // We were used with an edit-link
               api = $('#edit_desc_' + id).eq(0).simpletip();
            }
            api.hide();
         }
         function showRequest(formData, jqForm, options) {
            // formData is an array; here we use $.param to convert it to a string to display it
            // but the form plugin does this for you automatically when it submits the data
            var queryString = $.param(formData);

            // jqForm is a jQuery object encapsulating the form element.  To access the
            // DOM element for the form do this:
            // var formElement = jqForm[0];

            alert('About to submit: \n\n' + queryString);

            // here we could return false to prevent the form from being submitted;
            // returning anything other than false will allow the form submit to continue
            return true;
         }
         function htmlescape(s) {
            return $('<div />').text(s).html();
         }
         function extract_json(data) {
            try {
               data = $.parseJSON(data);
            } catch(e) {
                  alert(e + "\nData: " + data.toSource());
                  return false;
            }
            if (! data.success && data.message) {
               alert('Error: ' + data.message);
            }
            return data;
         }
         function do_update_vorteil(response, status, xhr, form) {
            if (! status) {
               alert('Error processing request, try again');
               return false;
            }
            response = extract_json(response);
            if (! response.success) {
               return false;
            }
            if (response.update) {
               // Update the specified vorteil
               console.log('Name: ' + response.name + ', ID: ' + response.id);
               var row = '#vorteil_' + response.id;
               $(row + ' #cell_name').text(response.name);
               $(row + ' #cell_gp').text(response.gp);
               $(row + ' #cell_ap').text(response.ap);
               $(row + ' #cell_effect').text(response.effect);
               $(row).effect('highlight', {}, 2000);
            } else {
               // Add the specified vorteil
               var row = '<tr id="vorteil_' + response.id + '">';
               row += '<td id="cell_name">' + htmlescape(response.name) + '</td>';
               row += '<td id="cell_gp">' + htmlescape(response.gp) + '</td>';
               row += '<td id="cell_ap">' + htmlescape(response.ap) + '</td>';
               row += '<td id="cell_effect">' + htmlescape(response.effect) + '</td>';
               row += '<td id="cell_links">';
               row += '<a id="tip_desc_' + response.id + '" class="link-info" href="#">info</a>';
               row += ' | <a id="edit_desc_' + response.id + '" class="link-edit" href="#">edit</a>';
               row += ' | <a class="link-cancel" href="#">remove</a>';
               row += '</td></tr>';
               // Append the row to the table
               if (response.vorteil) {
                  $('#table_vorteile tbody').append(row);
               } else {
                  $('#table_nachteile tbody').append(row);
               }
               $('#vorteil_' + response.id).effect('highlight', {}, 2000);
               // Attach actions to links
               add_simpletip_to_info($('#tip_desc_' + response.id));
               add_simpletip_to_edit($('#edit_desc_' + response.id));
            }
         }
         function toggle_h3(elem_h3) {
            var div = $(elem_h3).text();
            div = div.toLowerCase();
            // Opens the div with the given name, closes all others
            $('#main h3 + div').slideUp();
            $('#' + div).slideDown();
         }
         //-->{/literal}
      </script>
   </body>
</html>
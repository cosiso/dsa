<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
   <head>
      {include file='part_head.tpl' title='DSA - setup'}
   </head>
   <body>
      {include file="head.tpl"}
      {include file="setup_menu.tpl" selected_category="Weapons"}
      <div style="float: left">
         <div id="main">
            <h3>Weapons</h3>
            <table id="table_weapons" cellspacing="0">
               <thead>
               <tr>
                  <th>Name</th>
                  <th>Technik</th>
                  <th>TP</th>
                  <th>TP/KK</th>
                  <th>Gewicht (uz)</th>
                  <th>Länge (cm)</th>
                  <th>BF</th>
                  <th>INI</th>
                  <th>Preis (Ag)</th>
                  <th>WM</th>
                  <th>DK</th>
                  <th>&nbsp;</th>
               </tr>
               </thead>
               <tbody class="hover">
                  {section name=idx loop=$weapons}
                     <tr id="row_{$weapons[idx].id}">
                        <td id="cell_name">{$weapons[idx].name|escape}</td>
                        <td id="cell_kampftechnik">{$weapons[idx].kampftechnik|escape}</td>
                        <td id="cell_tp">{$weapons[idx].tp|escape}</td>
                        <td id="cell_tpkk">{$weapons[idx].tpkk|escape}</td>
                        <td id="cell_gewicht">{$weapons[idx].gewicht|escape}</td>
                        <td id="cell_lange">{$weapons[idx].lange|escape}</td>
                        <td id="cell_bf">{$weapons[idx].bf|escape}</td>
                        <td id="cell_ini">{$weapons[idx].ini|escape}</td>
                        <td id="cell_preis">{$weapons[idx].preis|escape}</td>
                        <td id="cell_wm">{$weapons[idx].wm|escape}</td>
                        <td id="cell_dk">{$weapons[idx].dk|escape}</td>
                        <td>
                           <span id="link_info_{$weapons[idx].id}" class="link-info">info</span>
                           <span id="link_edit_{$weapons[idx].id}" class="link-edit">edit</span>
                           | <span id="link_remove_{$weapons[idx].id}" class="link-cancel" onclick="remove_weapon({$weapons[idx].id})">remove</span>
                        </td>
                     </tr>
                  {/section}
               </tbody>
            </table><br />
            <span id="btn_add_weapon" class="link-add">Add weapon</span>
         </div>
      </div>
      {include file='part_script_include.tpl'}
      <script type="text/javascript">
         <!--
         var kampftechniken = new Array(
            {ldelim} value: 0, text : '  Select a kampftechnik' {rdelim}
            {section name=idx loop=$kt}
               ,{ldelim} value: {$kt[idx].id}, text : '{$kt[idx].name|escape}' {rdelim}
            {/section}
         )
         {literal}
         $(document).ready(function() {
            // Make table sortable
            $('#table_weapons').tablesorter({headers : { 2: {sorter: false},
                                                         3: {sorter: false},
                                                         9: {sorter: false},
                                                        10: {sorter: false},
                                                        11: {sorter: false}}});
            // Add simpletip to button
            add_simpletip('#btn_add_weapon', 0);
            // Add simpletip to links
            $('#table_weapons a[id^=link_edit]').each(
               function() {
                  // Id of element is in form edit_link_<id>
                  var link_id = $(this).prop('id');
                  var id = link_id.split('_');
                  id = id[2];
                  add_simpletip('#' + link_id, id);
               }
            );
            $('#table_weapons a[id^=link_info]').each(
               function() {
                  add_note_simpletip($(this).prop('id'));
               }
            )
         });
         function do_remove_weapon(data) {
            data= extract_json(data);
            if (data.success) {
               var row = '#table_weapons #row_' + data.id;
               $(row).effect('highlight', {}, 2000);
               setTimeout(function() {
                  $(row).remove();
               }, 500);
            }
         }
         function remove_weapon(id) {
            var name = $('#table_weapons #row_' + id + ' #cell_name').text();
            alertify.confirm('Remove ' + name + '?', function(e) {
               if (e) {
                  $.ajax({
                     datatype : 'json',
                     type     : 'post',
                     url      : 'setup_weapons.php',
                     data     : {stage : 'remove',
                                 id    : id},
                     success  : do_remove_weapon
                  });
                  alertify.log('Removing weapon ' + name);
               }
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
         function add_note_simpletip(elem) {
            var dummy = elem.split('_');
            $('#' + elem).unbind('click');
            $('#' + elem).simpletip({
               persistent    : true,
               focus         : true,
               onBeforeShow  : function() {
                  this.load('setup_weapons.php', {stage : 'note',
                                                  id    : dummy[2]});
               },
            });
         }
         function add_simpletip(elem, id) {
            $(elem).unbind('click');
            $(elem).simpletip({
               persistent    : true,
               focus         : true,
               onBeforeShow  : function() {
                  this.load('setup_weapons.php', {stage : 'show_form',
                                                  id    : id});
               },
               onContentLoad : function() {
                  // Selectize select field
                  $('#frm_weapons #kampftechnik').selectize({
                     sortField   : 'text',
                     options     : kampftechniken,
                     selectOnTab : true,
                  });
                  var sel = $('#frm_weapons #kampftechnik_id').val() || 0;
                  $('#frm_weapons #kampftechnik')[0].selectize.addItem(sel);
                  // Set focus
                  $('#frm_weapons #name').focus().select();
                  // Add validation to form
                  $('#frm_weapons').validate({
                     rules        : {
                        name    : 'required',
                        tp      : 'required',
                        tpkk    : 'required',
                        gewicht : 'number',
                        lange   : 'number',
                        bf      : 'number',
                        ini     : 'number',
                        wm      : 'required',
                     },
                     submitHandler: function(form) {
                        $(form).ajaxSubmit({
                           success : do_update_weapon,
                           type    : 'post',
                           url     : 'setup_weapons.php',
                           datatype: 'json'
                        });
                        close_box();
                        return false;
                     },
                  });
               },
            });
         }
         function do_update_weapon(data) {
            data = extract_json(data);
            if (data.success) {
               if (data.is_new) {
                  // Add row
                  alertify.log('Adding weapon')
                  var elem = '<tr id="row_' + data.id + '">' +
                        '<td id="cell_name">' + htmlescape(data.name) + '</td>' +
                        '<td id="cell_kampftechnik">' + htmlescape(data.kt) + '</td>' +
                        '<td id="cell_tp">' + data.tp + '</td>' +
                        '<td id="cell_tpkk">' + data.tpkk + '</td>' +
                        '<td id="cell_gewicht">' + data.gewicht + '</td>' +
                        '<td id="cell_lange">' + data.lange + '</td>' +
                        '<td id="cell_bf">' + data.bf + '</td>' +
                        '<td id="cell_ini">' + data.ini+ '</td>' +
                        '<td id="cell_preis">' + data.preis + '</td>' +
                        '<td id="cell_wm">' + data.wm + '</td>' +
                        '<td id="cell_dk">' + data.dk + '</td>' +
                        '<td>' +
                        '<span id="link_info_' + data.id + '" class="link-info">info</span>' +
                        '| <span id="link_edit_' + data.id + '" class="link-edit">edit</span>' +
                        '| <span id="link_remove_' + data.id + '" class="link-cancel">remove</span>' +
                        '</td></tr>';
                  $('#table_weapons tbody').append(elem);
                  attach_simpletip_frm('#table_weapons #link_edit_' + data.id);
                  $('#link_remove_' + data.id).unbind('click').click(function() {remove_weapon(data.id)});
               } else {
                  // Update row
                  alertify.log('Updating weapon')
                  var row = '#table_weapons #row_' + data.id;
                  $(row + ' #cell_name').text(data.name);
                  $(row + ' #cell_kampftechnik').text(data.tk);
                  $(row + ' #cell_tp').text(data.tp);
                  $(row + ' #cell_tpkk').text(data.tpkk);
                  $(row + ' #cell_gewicht').text(data.gewicht);
                  $(row + ' #cell_lange').text(data.lange);
                  $(row + ' #cell_bf').text(data.bf);
                  $(row + ' #cell_ini').text(data.ini);
                  $(row + ' #cell_preis').text(data.preis);
                  $(row + ' #cell_wm').text(data.wm);
                  $(row + ' #cell_dk').text(data.dk);
               }
               $('#table_weapons #row_' + data.id).effect('highlight', {}, 2000);
            }
         }
         function close_box() {
            var id = $('#frm_weapons #id').val();
            if (id) {
               $('#link_edit_' + id).eq(0).simpletip().hide();
               // attached to link
            } else {
               $('#btn_add_weapon').eq(0).simpletip().hide();
            }
         }
         //-->{/literal}
      </script>
   </body>
</html>

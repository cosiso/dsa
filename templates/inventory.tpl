<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
      "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
   {include file=part_head.tpl title='DSA - Inventory'}
</head>
<body>
   {include file=head.tpl }
   {include file=character_menu.tpl selected='inventory'}
   <div id="div" style="float: left">
      <div id="main">
         <div onclick="close_all_divs()" style="cursor: pointer">
            <img src="images/badge-square-direction-up-24.png" border="0" width="24" height="24" />
            Close all
         </div>
         {section name=idx loop=$chars}
            <h3 id="h3_{$chars[idx].id}" class="toggle" onclick="toggle({$chars[idx].id})">{$chars[idx].name|escape}</h3>
            <div id="char_{$chars[idx].id}" style="display: none;"></div>
         {sectionelse}
            <script type="text/javascript">
               alert('No characters defined yet');
            </script>
         {/section}
      </div>
   </div>
   {include file=part_script_include.tpl}
   <script type="text/javascript">
      <!--{literal}
      var hasData = {};
      var is_retrieving = false;
      $(document).ready(function() {
         $.validator.addMethod('tp', function(value, element) {
            return this.optional(element) || value.match(/\d+[dwDW]\d+(\+\d+)/);
         }, 'Please format like f.e. 1d6+1');
         $.validator.addMethod('tpkk', function(value, element) {
            return this.optional(element) || value.match(/\d+\/\d+/);
         }, 'Please format like f.e. 2/3');
      })
      function add_simpletip(elem, id, char_id) {
         $(elem).unbind('click');
         var row_id = $(elem).closest('tr').prop('id');
         console.log('Add simpletip to row ' + row_id + ', having id ' + id + ' and char id: ' + char_id);
         $(elem).simpletip({
            persistent    : true,
            focus         : true,
            onBeforeShow  : function() {
               this.load('inventory.php', {stage   : 'show_weapon_form',
                                           id      : id,
                                           char_id : char_id});
            },
            onContentLoad : function() {
               var dummy = $('#frm_weapons #id').val();
               if (dummy > 0) {
                  // an edit, name is disabled, so focus on tp
                  $('#frm_weapons #tp').focus().select();
               } else {
                  $('#frm_weapons #name').selectize({
                     sortField   : 'text',
                     selectOnTab : true,
                  });
                  $('#frm_weapons #name')[0].selectize.addItem(0);
               }
               $('#frm_weapons').validate({
                  rules         : {
                     ini  : 'number',
                     at   : 'number',
                     pa   : 'number',
                     bf   : 'number',
                     tp   : 'tp',
                     tpkk : 'tpkk',
                     wm   : 'tpkk',
                  },
                  submitHandler : function(form) {
                     // Verify a weapon has been selected if adding
                     if ($('#frm_weapons #id').val() == 0 &&
                         $('#frm_weapons #name').val() == 0) {
                        alertify.alert('No weapon selected');
                        return false;
                     }
                     $(form).ajaxSubmit({
                        success  : do_update_weapon,
                        type     : 'post',
                        url      : 'inventory.php',
                        datatype : 'json',
                     });
                     close_box();
                     return false;
                  }
               });
            },
         });
      }
      function htmlescape(s) {
         return $('<div />').text(s).html();
      }
      function do_update_weapon(data) {
         data = extract_json(data);
         if (data.success) {
            var id = data.id;
            var table_id = 'table#weapons_' + data.char_id;
            if (data.is_new) {
               // Add row
               var elem = '<tr id="' + id + '">' +
                     '<td id="name">' + htmlescape(data.name) + '</td>' +
                     '<td id="tp">' + htmlescape(data.tp) + '</td>' +
                     '<td id="tpkk">' + htmlescape(data.tpkk) + '</td>' +
                     '<td id="ini">' + htmlescape(data.ini) + '</td>' +
                     '<td id="wm">' + htmlescape(data.wm) + '</td>' +
                     '<td id="at">' + htmlescape(data.at) + '</td>' +
                     '<td id="pa">' + htmlescape(data.pa) + '</td>' +
                     '<td id="bf">' + htmlescape(data.bf) + '</td>' +
                     '<td>' +
                        '<a id="note" href="#" class="link-info">note</a> ' +
                        '| <a id="edit" href="#" class="link-edit">edit</a> ' +
                        '| <a id="remove" href="#" class="link-cancel" onclick="remove_weapon(' + id + ')">remove</a>' +
                     '</td></tr>';
               $(table_id + ' tbody').append(elem);
               add_simpletip($(table_id + ' tr#' + id), id, 0);
               add_note_tip($(table_id + ' tr#' + id + ' #note'), id);

            } else {
               var row_id = table_id + ' #' + id;
               // Update values
               $(row_id + ' #tp').text(data.tp);
               $(row_id + ' #tpkk').text(data.tpkk);
               $(row_id + ' #ini').text(data.ini);
               $(row_id + ' #wm').text(data.wm);
               $(row_id + ' #at').text(data.at);
               $(row_id + ' #pa').text(data.pa);
               $(row_id + ' #bf').text(data.bf);
            }
            $(table_id + ' #' + id).effect('highlight', {}, 2000);
         }
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
      function close_all_divs() {
         $('#main h3 + div[id^=char_]').slideUp();
      }
      function toggle(char_id) {
         var div='#main div#char_' + char_id;
         var isVisible = $(div).is(':visible');
         if (! hasData[char_id] && ! isVisible) {
            alertify.log('Retrieving data for ' + $('#main #h3_' + char_id).text());
            $.ajax({
               datatype : 'json',
               type     : 'post',
               url      : 'inventory.php',
               data     : {stage : 'get_char',
                           id    : char_id},
               success  : do_show_char,
            });
         } else {
            // Toggle div
            $(div).toggle();
         }
      }
      function do_show_char(data) {
         data = extract_json(data);
         if (data.success) {
            var div='#main div#char_' + data.id;
            $(div).html(data.out);
            $(div).slideDown();
            hasData[data.id] = true;
            // Add simpletip to button
            add_simpletip('#btn_add_weapon_' + data.id, 0, data.id);
            // Add simpletip to links
            $('table#weapons_' + data.id + ' #edit').each(function() {
               var id = $(this).closest('tr').prop('id');
               console.log('Add id ' + id + ' to edit field of char: ' + data.id);
               add_simpletip($(this), id, 0);
            });
            $('table#weapons_' + data.id + ' #note').each(function() {
               var id=$(this).closest('tr').prop('id');
               add_note_tip($(this), id);
            })
         }
      }
      function add_note_tip(href, id) {
         $(href).unbind('click');
         $(href).simpletip({
            persistent    : true,
            focus         : true,
            onBeforeShow  : function() {
               this.load('inventory.php', {stage   : 'show_weapon_note',
                                           id      : id,
                                          });
            },
         });
      }
      function note_weapon(href, id) {
         console.log('Check to see if a simpletip is attached');
         var tip = $(href).eq(0).simpletip();
         console.log('Tooltip is: ' + tip.getParent().toSource());
         console.log('Attaching simpletip');
         console.log('Displaying simpletip');
         alertify.alert('ToDo: note_weapon, ID: ' + id);
         return false;
      }
      function remove_weapon(id) {
         var name = $('tr#' + id + ' #name').text();
         alertify.confirm('Remove weapon ' + name + '?', function(e) {
            if (e) {
               $.ajax({
                  datatype : 'json',
                  type     : 'post',
                  url      : 'inventory.php',
                  data     : { stage : 'remove_weapon',
                               id    : id},
                  success  : do_remove_weapon,
               });
            }
         });
         return false;
      }
      function do_remove_weapon(data) {
         data = extract_json(data);
         if (data.success) {
            // Weapon removed from invwentory, remove row from list
            var row = 'tr#' + data.id;
            $(row).effect('highlight', {}, 2000);
            setTimeout(function() {
               $(row).remove();
            }, 500);
         }
      }
      function close_box() {
         var id = $('#frm_weapons #id').val();
         if (id > 0) {
            // attached to link
            $('tr#' + id + ' #edit').eq(0).simpletip().hide();
         } else {
            $('a[id^="btn_add_weapon_"]').each(function() {
               $(this).eq(0).simpletip().hide();
            })
         }
         $('#frm_weapons').remove();
      }
      //-->{/literal}
   </script>
</body>
</html>
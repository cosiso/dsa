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
      $(document).ready(function() {
         $.validator.addMethod('tp', function(value, element) {
            return this.optional(element) || value.match(/\d+[dwDW]\d+(\+\d+)/);
         }, 'Please format like f.e. 1d6+1');
         $.validator.addMethod('tpkk', function(value, element) {
            return this.optional(element) || value.match(/\d+\/\d+/);
         }, 'Please format like f.e. 2/3');
         $.validator.addMethod('non-zero-option', function(value, element) {
            return this.optional(element) || $(element).val() !== 0;
         }, 'Select an option')
      })
      function add_simpletip(elem, id, char_id) {
         $(elem).unbind('click');
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
               if (dummy) {
                  // an edit, name is disabled, so focus on tp
                  $('#frm_weapons #tp').focus().select();
               } else {
                  // ToDo: selectize and focus name field
                  $('#frm_weapons #name').selectize({
                     sortField   : 'text',
                     selectOnTab : true,
                  });
                  // var sel = $('#frm_weapons #kampftechnik_id').val() || 0;
                  $('#frm_weapons #name')[0].selectize.addItem(0);
               }
               $('#frm_weapons').validate({
                  rules         : {
                     name : 'required, non-zero-option',
                     ini  : 'number',
                     at   : 'number',
                     pa   : 'number',
                     bf   : 'number',
                     tp   : 'tp',
                     tpkk : 'tpkk',
                     wm   : 'tpkk',
                  },
                  submitHandler : function(form) {
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
      function do_update_weapon(data) {
         data = extract_json(data);
         if (data.success) {
            if (data.is_new) {
               // Add row
            } else {
               // Update values
               var id = data.id;
               $('table#weapons #' + id + ' #tp').text(data.tp);
               $('table#weapons #' + id + ' #tpkk').text(data.tpkk);
               $('table#weapons #' + id + ' #ini').text(data.ini);
               $('table#weapons #' + id + ' #wm').text(data.wm);
               $('table#weapons #' + id + ' #at').text(data.at);
               $('table#weapons #' + id + ' #pa').text(data.pa);
               $('table#weapons #' + id + ' #bf').text(data.bf);
            }
            $('table#weapons #' +id).effect('highlight', {}, 2000);
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
            $('table#weapons #edit').each(function() {
               var id = $(this).closest('tr').prop('id');
               add_simpletip($(this), id, 0);
            });
         }
      }
      function note_weapon(href, id) {
         alertify.alert('ToDo: note_weapon, ID: ' + id);
         return false;
      }
      function remove_weapon(id) {
         alertify.alert('ToDo: remove_weapon, ID: ' + id);
         return false;
      }
      function close_box() {
         var id = $('#frm_weapons #id').val();
         if (id) {
            // attached to link
            $('table#weapons tr#' + id + ' #edit').eq(0).simpletip().hide();
         } else {
            $('a[id^="btn_add_weapon_"]').each(function() {
               $(this).eq(0).simpletip().hide();
            })
         }
      }
      //-->{/literal}
   </script>
</body>
</html>
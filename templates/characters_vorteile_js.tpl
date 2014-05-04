<script type="text/javascript">
   <!--{literal}
   function do_remove_vorteil(data) {
      data = extract_json(data);
      if (data.success) {
         // Remove row from table
         $('#table_vorteile #vorteil_' + data.id).effect('highlight', {}, 2000);
         $('#table_vorteile #vorteil_' + data.id).remove();
      }
   }
   function remove_vorteil(id, name) {
      alertify.confirm('Remove ' + name + '?', function (e) {
         if (e) {
            $.ajax({
               datatype : 'json',
               url      : 'char_vorteile.php',
               type     : 'post',
               data     : {stage : 'remove_vorteil',
                           id    : id},
               success  : do_remove_vorteil
            });
            alertify.log('Removing vorteil ' + name);
         }
      });
      return false;
   }
   function do_update_vorteile(data) {
      data = extract_json(data);
      if (data.success) {
         $('#vorteile').html(data.html);
         // Add simpletip to btn_add
         $('#btn_add_vorteil').simpletip({
            persistent    : true,
            focus         : true,
            onBeforeShow  : function() {
               this.load('char_vorteile.php', {'stage' : 'fetch_vorteile'});
            },
            onHide        : destroy_form_vorteile,
            onContentLoad : add_select_to_vorteile});
         // Add simpletip to links
         $('#table_vorteile tr[id^=vorteil_]').each(function (index, value) {
            add_simpletip_desc_to_link($('#vorteile_link_desc',this));
            add_simpletip_edit_to_link($('#vorteile_link_edit',this));
         });
         // Make table sortable
         $('#table_vorteile').tablesorter({headers : { 0: {sorter: false},
                                                       5: {sorter: false}}})
      }
   }
   function add_simpletip_edit_to_link(link) {
      // id is in parent row
      var tr_id = $(link).closest('tr').attr('id');
      var dummy = tr_id.split('_');
      var id = dummy[1];
      $(link).simpletip({
         onContentLoad : add_select_to_vorteile,
         onBeforeShow  : function() {
            this.load('char_vorteile.php', {stage : 'fetch_vorteile',
                                            id    : id});
         },
         onHide        : destroy_form_vorteile,
         focus         : true,
         persistent    : true});
   }
   function add_simpletip_desc_to_link(link) {
      // id is in parent row
      var tr_id = $(link).closest('tr').attr('id');
      var dummy = tr_id.split('_');
      var id = dummy[1];
      $(link).simpletip({
         onBeforeShow : function() {
            this.load('char_vorteile.php', {'stage': 'tip_description',
                                            'id'   : id});
         },
         persistent   : true
      });
   }
   function retrieve_vorteile(id) {
      var name = $('#main_name').text();
      alertify.log('Retrieving vorteile for ' + name);
      $.ajax({
         datatype : 'json',
         type     : 'post',
         url      : 'char_vorteile.php',
         data     : {'stage' : 'retrieve_vorteile',
                     'id'    : id},
         success  : do_update_vorteile
      });
   }
   function close_edit_vorteile_box() {
      // See where we are attached
      var id = $('#frm_vorteil #id').val();
      if (id) {
         $('tr#vorteil_' + id + ' #vorteile_link_edit').eq(0).simpletip().hide();
      } else {
         $('#btn_add_vorteil').eq(0).simpletip().hide();
      }
   }
   function destroy_form_vorteile() {
      // Remove selectize from list
      $('#list_vorteile')[0].selectize.destroy();
      $('#frm_vorteile').remove();
   }
   function do_update_vorteil(data) {
      data = extract_json(data);
      if (data.success) {
         var row = '#vorteil_' + data.id;
         var img_src = (data.vorteil) ? 'plus-16.png' : 'minus-16.png';
         if (data.update) {
            // Update the row
            $(row + ' #cell_value').text(data.value);
            $(row + ' #cell_note').text(data.note);
            $(row).effect('highlight', {}, 2000);
         } else {
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
         }
      }
   }
   function add_select_to_vorteile() {
      $('#list_vorteile').selectize({
         valueField  : 'fId',
         labelField  : 'fVorteil',
         searchField : 'fVorteil',
         create      : false,
         render      : {
            option : function (item, escape) {
               var dummy = item.fVorteil.split(' - ');
               var src = (dummy[0] == 'Vorteil') ? 'plus-16.png' : 'minus-16.png';
               var out = '<div><img src="images/' + src + '" border="0" />' + dummy[1] + '</div>';
               return out;
            },
            item  : function (item, escape) {
               var dummy = item.fVorteil.split(' - ');
               var src = (dummy[0] == 'Vorteil') ? 'plus-16.png' : 'minus-16.png';
               var out = '<div><img src="images/' + src + '" border="0" />' + dummy[1] + '</div>';
               return out;
            }
         }
      });
      // Clear if vorteil not set
      if (! $('#frm_vorteil #vorteil').val()) {
         $('#list_vorteile')[0].selectize.clear();
         $('#list_vorteile').focus();
      } else {
         // Make list readonly if vorteil is set
         $('#list_vorteile')[0].selectize.disable();
         $('#frm_vorteil #vorteil_value').focus().select();
      }
      // Set character id
      $('#frm_vorteil #character_id').val(character_id);
      // Also add validation
      $('#frm_vorteil').validate({
         submitHandler: function(form) {
            // Set vorteil with selected value
            $('#frm_vorteil #vorteil').val($('#list_vorteile')[0].selectize.getValue());
            $(form).ajaxSubmit({
               success : do_update_vorteil,
               // beforeSubmit: showRequest,
               type    : 'post',
               url     : 'char_vorteile.php',
               datatype: 'json'
            });
            close_edit_vorteile_box();
            return false;
         }
      });
   }
   {/literal}
</script>

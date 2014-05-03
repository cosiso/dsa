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
   function vorteile_description(elem, id) {
      $(elem).simpletip({
         persistent    : true,
         onBeforeShow  : function() {
            this.load('setup_vorteile.php', {'stage': 'tip_description',
                                             'id'   : id});
         }
      });
      return false;
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
      console.log('Funtion adds to ' + $(link).attr('id'));
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
         console.log('Connected from link with ID: ' + id);
      } else {
         $('#btn_add_vorteil').eq(0).simpletip().hide();
      }
   }
   function destroy_form_vorteile() {
      // Remove select2 from list
      $('#list_vorteile').select2("destroy");
      $('#frm_vorteile').remove();
   }
   function do_update_vorteil(data) {
      data = extract_json(data);
   }
   function list_vorteile_format(state) {
      var is_vorteil = $(state.element).data('is_vorteil');
      var src = (is_vorteil) ? 'plus-16.png' : 'minus-16.png';
      return '<img src="images/' + src + '" border="0" />' + state.text;
   }
   function add_select_to_vorteile() {
      $('#list_vorteile').select2({
         formatResult    : list_vorteile_format,
         formatSelection : list_vorteile_format,
         escapeMarkup    : function(m) {return m;}
      });
      // Select correct line if field id is set
      console.log('Selected: ' + $('#list_vorteile').select2('val'));
      $('#list_vorteile').select2('val', $('#frm_vorteil #vorteil').val());
      // Set character id
      $('#frm_vorteil #character_id').val(character_id);
      // Set focus
      $('#list_vorteile').focus();
      // Also add validation
      $('#frm_vorteil').validate({
         submitHandler: function(form) {
            // First get value of list
            var vorteil = $('#list_vorteile').select2('val');
            $('#frm_vorteil #vorteil').val(vorteil);
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

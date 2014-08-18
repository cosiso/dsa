<script type="text/javascript">
   <!--
   var vb_old_le = 0;
   var vb_old_au = 0;
   var vb_old_ae = 0;
   function vb_focus(id, inp) {
      var v = parseInt($(inp).val());
      if (isNaN(v)) {
         return;
      }
      if (id == 'le') {
         vb_old_le = v;
      } else if (id == 'au') {
         vb_old_au = v;
      } else if (id == 'ae') {
         vb_old_ae = v;
      }
   }
   function vb_change(id, inp) {
      var vb_old_value = 0;
      if (id == 'le') {
         vb_old_value = vb_old_le;
      } else if (id == 'au') {
         vb_old_value = vb_old_au;
      } else if (id == 'ae') {
         vb_old_value = vb_old_ae;
      } else {
         // Should not happen
         return;
      }
      var vb_new_value = parseInt($(inp).val());
      if (isNaN(vb_new_value)) {
         // Illegal input, set old value back
         $(inp).val(vb_old_value);
         return;
      }
      var diff = vb_new_value - vb_old_value;
      if (diff == 0) {
         // No change, simply return
         return;
      }
      // Save new value as old
      if (id == 'le') {
         vb_old_le = vb_new_value;
      } else if (id == 'au') {
         vb_old_au = vb_new_value;
      } else if (id == 'ae') {
         vb_old_ae = vb_new_value;
      }
      // Update field
      var field = "span#vb_" + id;
      var cur_value = parseInt($(field).text()) || 0;
      var new_value = cur_value - diff;
      $(field).text(new_value);
      // Update database
      var char_id = $('input#vb_char_id').val();
      $.ajax({
         url  : 'value-bar.php',
         type : 'post',
         data : { stage : 'set_lost', id : id, value : vb_new_value, char_id : char_id },
      });
   }
   //-->
</script>
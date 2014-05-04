<script type="text/javascript">
   <!--{literal}
   var old_basevalues = {};
   function roll(eigenschaft) {
      var value=$('#eigenschaften #' + eigenschaft).val();
      var die = Math.floor(Math.random() * 20 + 1);
      var result = value - die;
      var out = $('#main_name').text() + ' rolled on ' + eigenschaft + ': ' + die + ', result: ' + (value - die);
      if (result < 0) {
         alertify.error(out);
      } else {
         alertify.success(out);
      }
   }
   function recalc_total(name, highlight) {
      if (name == 'konstitution') {
         recalc_lebenspunkte();
      } else if (name == 'körperkraft') {
         recalc_lebenspunkte();
      }
      if (highlight) {
         $('#div_basevalues #' + name).effect('highlight', {}, 2000);
      }
   }
   function blur_eigenschaften(e) {
      // Verify if this field may be edited
      fieldname = this.id;
      if (! fieldname.match(/_(base|zugekauft|modifier)$/)) {
         alertify.alert('This field (' + fieldname + ') cannot be edited');
         return false;
      }
      // See if value actually changed
      var v = $(this).val();
      if (v != old_val[fieldname]) {
         // New value must be an integer
         var intRegEx = /^-?\d*$/;
         if (! intRegEx.test(v)) {
            $(this).addClass('error');
            return false;
         } else {
            $(this).removeClass('error');
            // Disable field and make Ajax-request
            this.disabled = true;
            $.ajax({
               datatype: 'json',
               type    : 'post',
               url     : 'character_eigenschaften.php',
               data    : {'stage'    : 'update_eigenschaft',
                          'char_id'  : character_id,
                          'fieldname': fieldname,
                          'value'    : v},
               success : update_eigenschaft
            });
         }
      }
   }
   function update_eigenschaft(data) {
      data = extract_json(data)
      if (! data.success) {
         // Something went wrong, restore old value
         if (! data.fieldname) {
            alertify.alert('Unexpected error');
            return false;
         }
         $('#eigenschaften #' + data.fieldname).val(old_val[data.fieldname]);
         $('#eigenschaften #' + data.fieldname).prop('disabled', false);
         return false;
      }
      if (data.is_zero &&
          old_val[data.fieldname] != '' &&
          old_val[data.fieldname] != 0) {
         // Something went wrong
         alertify.alert('An error occurred, field ' + data.fieldname + ' set to 0');
         old_val[data.fieldname] = 0;
         $('#eigenschaften #' + data.fieldname).val(old_val[data.fieldname]);
         $('#eigenschaften #' + data.fieldname).prop('disabled', false);
      }
      // All went fine, recalc total and enable field
      var field = data.fieldname.split('_');
      recalc_total(field[0], true);
      $('#eigenschaften #' + data.fieldname).prop('disabled', false);
   }
   function retrieve_eigenschaften(char_id) {
      var name = $('#main_name').text();
      alertify.log('Retrieving eigenschaften for ' + name);
      $.ajax({
         datatype : 'json',
         type     : 'post',
         url      : 'character_eigenschaften.php',
         success  : do_update_eigenschaften,
         data     : {stage : 'retrieve_eigenschaften',
                     id    : char_id}
      })
   }
   function do_update_eigenschaften(data) {
      data = extract_json(data);
      if (data.success) {
         $('h3 + div#eigenschaften').html(data.html);
         // Set blur on edit-fields
         $('#data #eigenschaften #div_eigenschaften input[type=text], #data textarea').unbind('blur').blur(blur_eigenschaften);
         $('#eigenschaften #div_basevalues input[type=text]').unbind('blur').blur(blur_basevalues);

         toggle_h3('eigenschaften', false);
         // Recalc all
         recalc_lebenspunkte();
         // Set array with old_values
         $('#eigenschaften #div_basevalues input[type=text]').each(function(index, value) {
            old_basevalues[$(value).prop('id')] = $(value).val();
         });
         old_basevalues['aap'] = 10;
      }
      console.log('VALUES: ' + old_basevalues.toSource());
   }
   function blur_basevalues(e) {
      var field = this.id;
      var old_val = parseInt(old_basevalues[field]) || 0;
      var new_val = parseInt($('#div_basevalues #' + field).val()) || 0;
      if (old_val != new_val) {
         console.log('Need to update');
      }
   }
   function recalc_lebenspunkte() {
      var kk = parseInt($('#div_eigenschaften #körperkraft').val());
      var ko = parseInt($('#div_eigenschaften #konstitution').val());
      var le = Math.ceil(( (2 * ko) + kk) / 2);
      $('#div_basevalues #le_base').val(le);
      var lost = parseInt($('#div_basevalues #le_used').val()) || 0;
      var mod = parseInt($('#div_basevalues #le_mod').val()) || 0;
      var bought = parseInt($('#div_basevalues #le_bought').val()) || 0;
      var total = le + lost + mod + bought;
      $('#div_basevalues #lebenspunkte').val(total);
   }
   //-->{/literal}
</script>

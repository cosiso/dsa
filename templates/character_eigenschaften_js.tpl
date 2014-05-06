<script type="text/javascript">
   <!--{literal}
   var old_basevalues = {};
   function roll(eigenschaft) {
      var out; var result;
      if (eigenschaft == 'ini') {
         // Add rolled value to initiativ
         var value=parseInt($('#div_basevalues #initiativ').val()) || 0;
         var die = Math.floor(Math.random() * 6 + 1);
         result = value + die;
         out = $('#main_name').text() + ' rolled as initiativ: <b>' + result + '</b> (' + value + ' + ' + die + ')';
      } else {
         var value=$('#eigenschaften #' + eigenschaft).val();
         var die = Math.floor(Math.random() * 20 + 1);
         result = value - die;
         out = $('#main_name').text() + ' rolled on ' + eigenschaft + ': ' + die + ', result: <b>' + (value - die) + '</b>';

      }
      if (result < 0) {
         alertify.error(out);
      } else {
         alertify.success(out);
      }
   }
   function recalc_total(name, highlight) {
      var base = parseInt($('#div_eigenschaften #' + name + '_base').val()) || 0;
      var bought = parseInt($('#div_eigenschaften #' + name +'_zugekauft').val()) || 0
      var mod = parseInt($('#div_eigenschaften #' + name + '_modifier').val()) || 0;
      var total = base + bought + mod;
      $('#div_eigenschaften #' + name).val(total);
      if (name == 'konstitution') {
         recalc_lebenspunkte();
         recalc_ausdauer();
         recalc_magieresistenz();
      } else if (name == 'körperkraft') {
         recalc_lebenspunkte();
         recalc_attack();
         recalc_parry();
         recalc_fernkampf();
      } else if (name == 'mut') {
         recalc_ausdauer();
         recalc_astralenergie();
         recalc_magieresistenz();
         recalc_attack();
         recalc_initiativ();
      } else if (name == 'gewandtheit') {
         recalc_ausdauer();
         recalc_initiativ();
         recalc_attack();
         recalc_parry();
      } else if (name == 'intuition') {
         recalc_astralenergie();
         recalc_initiativ();
         recalc_parry();
         recalc_fernkampf();
      } else if (name == 'charisma') {
         recalc_astralenergie();
      } else if (name == 'klugheit') {
         recalc_magieresistenz();
      } else if (name =='fingerfertigkeit') {
         recalc_fernkampf();
      }
      if (highlight) {
         $('#div_eigenschaften #' + name).effect('highlight', {}, 2000);
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
      console.log('FIELD: ' + field.toSource());
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
         recalc_ausdauer();
         recalc_astralenergie();
         recalc_magieresistenz();
         recalc_initiativ();
         recalc_attack();
         recalc_parry();
         recalc_fernkampf();
         // Set array with old_values
         $('#eigenschaften #div_basevalues input[type=text]').each(function(index, value) {
            old_basevalues[$(value).prop('id')] = $(value).val();
         });
      }
   }
   function blur_basevalues(e) {
      var field = this.id;
      var old_val = parseInt(old_basevalues[field]) || 0;
      var new_val = parseInt($('#div_basevalues #' + field).val()) || 0;
      if (old_val != new_val) {
         this.disabled = true;
         $.ajax({
            datatype : 'json',
            type     : 'post',
            url      : 'character_eigenschaften.php',
            data     : {stage : 'update_basevalue',
                        field : field,
                        value : parseInt($(this).val() || 0),
                        id    : character_id},
            success  : do_update_basevalue
         });
      }
   }
   function do_update_basevalue(data) {
      data = extract_json(data);
      if (data.success) {
         $('#basevalues #' + data.field).val(data.value);
         old_basevalues[data.field] = data.value;
         recalc_basevalue(data.total, true);
      } else {
         // Reset old value
         if (data.field && data.total) {
            var v = parseInt(old_basevalues[data.field]) || 0;
            $('#basevalues #' + data.field).val(v);
            recalc_basevalue(data.total, false);
         }
      }
      // In any case enable the field again and recalc
      $('#div_basevalues #' + data.field).prop('disabled', false);
   }
   function recalc_basevalue(name, highlight) {
      var f = 'recalc_' + name;
      window[f]();
      if (highlight) {
         $('#div_basevalues #' + name).effect('highlight', {}, 2000);
      }
   }
   function recalc_fernkampf() {
      var int = parseInt($('#div_eigenschaften #intuition').val()) || 0;
      var ff = parseInt($('#div_eigenschaften #fingerfertigkeit').val()) || 0;
      var kk = parseInt($('#div_eigenschaften #körperkraft').val()) || 0;
      var fk = Math.round((int + ff + kk) / 5);
      $('#div_basevalues #fk_base').val(fk);
      var mod = parseInt($('#div_basevalues #fk_mod').val()) || 0;
      var total = fk + mod;
      $('#div_basevalues #fernkampf').val(total);
   }
   function recalc_parry() {
      var int = parseInt($('#div_eigenschaften #intuition').val()) || 0;
      var ge = parseInt($('#div_eigenschaften #gewandtheit').val()) || 0;
      var kk = parseInt($('#div_eigenschaften #körperkraft').val()) || 0;
      var pa = Math.round((int + ge + kk) / 5);
      $('#div_basevalues #pa_base').val(pa);
      var mod = parseInt($('#div_basevalues #pa_mod').val()) || 0;
      var total = pa + mod;
      $('#div_basevalues #parry').val(total);
   }
   function recalc_attack() {
      var mu = parseInt($('#div_eigenschaften #mut').val()) || 0;
      var ge = parseInt($('#div_eigenschaften #gewandtheit').val()) || 0;
      var kk = parseInt($('#div_eigenschaften #körperkraft').val()) || 0;
      var at = Math.round((mu + ge + kk) / 5);
      $('#div_basevalues #at_base').val(at);
      var mod = parseInt($('#div_basevalues #at_mod').val()) || 0;
      var total = at + mod;
      $('#div_basevalues #attack').val(total);
   }
   function recalc_initiativ() {
      var mu = parseInt($('#div_eigenschaften #mut').val()) || 0;
      var int = parseInt($('#div_eigenschaften #intuition').val()) || 0;
      var ge = parseInt($('#div_eigenschaften #gewandtheit').val()) || 0;
      var ini = Math.round((2 * mu + int + ge) / 5);
      $('#div_basevalues #ini_base').val(ini);
      if ($('#div_basevalues #kampfgespur').val()) {
         ini += 2;
      }
      if ($('#div_basevalues #kampfreflexe').val()) {
         ini += 4;
      }
      var mod = parseInt($('#div_basevalues #ini_mod').val()) || 0;
      var total = ini + mod;
      $('#div_basevalues #initiativ').val(total);
   }
   function recalc_magieresistenz() {
      var mu = parseInt($('#div_eigenschaften #mut').val()) || 0;
      var kl = parseInt($('#div_eigenschaften #klugheit').val()) || 0;
      var ko = parseInt($('#div_eigenschaften #konstitution').val()) || 0;
      var mr = Math.round((mu + kl + ko) / 5);
      $('#div_basevalues #mr_base').val(mr);
      var lost = parseInt($('#div_basevalues #mr_used').val()) || 0;
      var mod = parseInt($('#div_basevalues #mr_mod').val()) || 0;
      var bought = parseInt($('#div_basevalues #mr_bought').val()) || 0;
      var total = mr + lost + mod + bought;
      $('#div_basevalues #magieresistenz').val(total);
   }
   function recalc_lebenspunkte() {
      var kk = parseInt($('#div_eigenschaften #körperkraft').val()) || 0;
      var ko = parseInt($('#div_eigenschaften #konstitution').val()) || 0;
      var le = Math.round(( (2 * ko) + kk) / 2);
      $('#div_basevalues #le_base').val(le);
      var lost = parseInt($('#div_basevalues #le_used').val()) || 0;
      var mod = parseInt($('#div_basevalues #le_mod').val()) || 0;
      var bought = parseInt($('#div_basevalues #le_bought').val()) || 0;
      var total = le + lost + mod + bought;
      $('#div_basevalues #lebenspunkte').val(total);
   }
   function recalc_ausdauer() {
      var mu = parseInt($('#div_eigenschaften #mut').val()) || 0;
      var ko = parseInt($('#div_eigenschaften #konstitution').val()) || 0;
      var ge = parseInt($('#div_eigenschaften #gewandtheit').val()) || 0;
      var au = Math.round((mu + ko + ge) / 2);
      $('#div_basevalues #au_base').val(au);
      var lost = parseInt($('#div_basevalues #au_used').val()) || 0;
      var mod = parseInt($('#div_basevalues #au_mod').val()) || 0;
      var bought = parseInt($('#div_basevalues #au_bought').val()) || 0;
      var total = au + lost + mod + bought;
      $('#div_basevalues #ausdauer').val(total);

   }
   function recalc_astralenergie() {
      var mu = parseInt($('#div_eigenschaften #mut').val()) || 0;
      var int = parseInt($('#div_eigenschaften #intuition').val()) || 0;
      var ch = parseInt($('#div_eigenschaften #charisma').val()) || 0;
      var ae = mu + int + ch;
      if ($('#div_basevalues #gefass').val()) {
         ae += ch;
      }
      ae = Math.round(ae / 2);
      $('#div_basevalues #ae_base').val(ae);
      var lost = parseInt($('#div_basevalues #ae_used').val()) || 0;
      var mod = parseInt($('#div_basevalues #ae_mod').val()) || 0;
      var bought = parseInt($('#div_basevalues #ae_bought').val()) || 0;
      var total = ae + lost + mod + bought;
      $('#div_basevalues #astralenergie').val(total);
   }
   //-->{/literal}
</script>

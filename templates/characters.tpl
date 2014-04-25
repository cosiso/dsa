<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
   <head>
      <title>DSA - setup</title>
      <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
      <link href="css/dsa.css" rel="stylesheet" type="text/css" />
   </head>
   <body>
      <script src="scripts/jquery.js"></script>
      <script src="tools/jquery-ui-1.10.4/ui/minified/jquery-ui.min.js"></script>
      <script type="text/javascript" src="scripts/jquery.validate.min.js"></script>
      <script type="text/javascript" src="scripts/jquery.form.min.js"></script>
      {include file="head.tpl"}
      {include file="character_menu.tpl" selected="main"}
      <div style="float: left">
         <div id="main" style="display: none; padding-bottom: 8px">
            <div>
               <h2 id="main_name" style="display: inline"></h2>
               {carto_spacer width=40}
               <img id="img_edit_name" src="images/page_white_paint.png" alt="edit" border="0" style="cursor: pointer" />
            </div>
            <div id="data">
               <h3 onclick="toggle_h3('general_data')">General data</h3>
               <div id="general_data">
                  <div class="column" style="margin-left: 0px">
                     <label for="rasse">Rasse:</label>
                     {html_text name='rasse'}
                     <label for="kultur">Kultur:</label>
                     {html_text name='kultur'}
                     <label for="profession">Profession:</label>
                     {html_text name='profession'}
                  </div>
                  <div class="column">
                     <label for="geschlecht">Geschlecht:</label>
                     {html_text name='geschlecht'}
                     <label for="alter">Alter:</label>
                     {html_text name='alter'}
                     <label for="haarfarbe">Haarfarbe:</label>
                     {html_text name='haarfarbe'}
                  </div>
                  <div class="column">
                     <label for="grosse">Grösse</label>
                     {html_text name='grosse'}
                     <label for="gewicht">Gewicht:</label>
                     {html_text name='gewicht'}
                     <label for='augenfarbe'>Augenfarbe</label>
                     {html_text name='augenfarbe'}
                  </div><br />
                  <label for="aussehen">Aussehen:</label>
                  {html_textarea name='aussehen' style='width: 100%; height: 60px'}
               </div>
               <h3 onclick="toggle_h3('eigenschaften')">Eigenschaften &amp; Basiswerte</h3>
               <div id="eigenschaften" style="display: none">
                  <div class="column" style="margin-left: 0px">
                     {section name=idx loop=$eigenschaften}
                        <label for="{$eigenschaften[idx].name|lower}">{$eigenschaften[idx].name|capitalize|escape}</label>
                        <b>Current</b> {html_text name=$eigenschaften[idx].name|lower class='show_disabled' style='width: 40px' disabled=true}
                        <b>Base</b> {html_text name=$eigenschaften[idx].name|lower|cat:'_base' style='width: 25px'}
                        <b>Bought</b> {html_text name=$eigenschaften[idx].name|lower|cat:'_zugekauft' style='width: 25px'}
                        <b>Modifier</b> {html_text name=$eigenschaften[idx].name|lower|cat:'_modifier' style='width: 25px'}
                     {/section}
                  </div><br />
               </div>
            </div>
         </div>
         {carto_button name='btn_new_character' value='New Character' onclick="new_character()"}
      </div>
      <div id="div_name" class="popup" style="display: none; width: 350px">
         <form name="frm_name" id="frm_name">
            {html_hidden name="stage" value="new"}
            {html_hidden name='char_id' value=0}
            <label class="normal" for="name">Name</label>
            <input type="text" id="name" name="name" style="width: 20em" required />
            <div class="button_bar">
               {carto_button type='submit'}
               {carto_button type='close' onclick="$('#div_name').slideUp()"}
            </div>
         </form>
      </div>
      <script type="text/javascript">
         <!--
         var old_val = new Array();
         var character_id = 0;{literal}
         $(document).ready(function() {
            // Set validation on new character-form
            $('#frm_name').validate({
               submitHandler: function(form) {
                  $(form).ajaxSubmit({
                     success : do_add_character,
                     type    : 'post',
                     datatype: 'json'
                  });
                  $('#div_name').slideUp();
                  return false;
               }
            });
            // Set onfocus on edit-fields
            $('#data input[type=text], #data textarea').focus(function(e) {
               // Save original value
               old_val[this.id] = $(this).val();
               console.log('Old value of ' + this.id + ' = ' + old_val[this.id]);
            });
            // Set onblur on edit-fields
            $('#data #general_data input[type=text], #data textarea').blur(blur_general_data);
            $('#data #eigenschaften input[type=text], #data textarea').blur(blur_eigenschaften);
         });
         function blur_eigenschaften(e) {
            // Verify if this field may be edited
            fieldname = this.id;
            if (! fieldname.match(/_(base|zugekauft|modifier)$/)) {
               alert('This field (' + fieldname + ') cannot be edited');
               return false;
            }
            // See if value actually changed
            var v = $(this).val();
            if (v != old_val[fieldname]) {
               // New value must be an integer
               var intRegEx = /^\d*$/;
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
                     url     : 'characters.php',
                     data    : {'stage'    : 'update_eigenschaft',
                                'char_id'  : character_id,
                                'fieldname': fieldname,
                                'value'    : v},
                     success : update_eigenschaft
                  });
               }
            }
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
         function update_eigenschaft(data) {
            data = extract_json(data)
            if (! data.success) {
               // Something went wrong, restore old value
               if (! data.fieldname) {
                  alert('Unexpected error');
                  return false;
               }
               alert('Could not update ' + data.fieldname + ', reset to ' + old_val[data.fieldname]);
               $('#eigenschaften #' + data.fieldname).val(old_val[data.fieldname]);
               $('#eigenschaften #' + data.fieldname).prop('disabled', false);
               return false;
            }
            // All went fine, enable field
            $('#eigenschaften #' + data.fieldname).prop('disabled', false);
         }
         function blur_general_data(e) {
            var v = $(this).val();
            if (old_val[this.id] == v) {
               // Nothing changed, return
               return;
            }
            // Update edit field in database
            if (this.id == 'alter' ||
                this.id == 'grosse' ||
                this.id == 'gewicht') {
               // Should be a number, show error if not and focus field again
               var intRegEx = /^\d*$/;
               if (! intRegEx.test(v)) {
                  $(this).addClass('error');
                  return;
               } else {
                  $(this).removeClass('error');
               }
            }
            // Disable field
            this.disabled = true;
            // Send ajax-request
            $.ajax({
               datatype: 'json',
               type    : 'post',
               url     : 'characters.php',
               data    : {stage    : 'update_field',
                          char_id  : character_id,
                          fieldname: this.id,
                          value    : v},
               success : update_field
            });
         }
         function toggle_h3(div_name) {
            // Opens the div with the given name, closes all others
            $('#data h3 + div').slideUp();
            $('#' + div_name).slideDown();
         }
         function update_field(data) {
            try {
               data = $.parseJSON(data);
            } catch(e) {
                  alert(e + "\nData: " + data.toSource());
                  return false;
            }
            if (! data.success) {
               if (data.message) {
                  alert('Error: ' + data.message);
               }
               // Something went wrong, restore old value
               alert('Could not update ' + data.fieldname + ', reset to ' + old_val[data.fieldname]);
               $('#' + data.fieldname).val(old_val[data.fieldname]);
               $('#' + data.fieldname).prop('disabled', false);
               return false;
            }
            // All went fine, enable field
            $('#' + data.fieldname).prop('disabled', false);
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
         function do_add_character(response, status, xhr, form) {
            if (! status) {
               alert('Error processing request, try again');
               return false;
            }
            response = $.parseJSON(response);
            if (! response.success) {
               alert('Error: ' + response.message);
               return false;
            }
            // Check if this was an update
            if (response.update) {
               // This is an update return from another function
               return update_name(response.name);
            }
            // Add character to menu
            var last = null; var put_before = null;
            $('#sub-menu-helden li').each(function() {
               var listname = $(this).text();
               if (response.name.localeCompare(listname) <= 0) {
                  last = $(this);
                  put_before = $(this);
                  return false;
               }
            });
            var new_li = '<li id="li-char-' + response.character_id + '"><a href="#">' + htmlescape(response.name) + '</a></li>';
            if (last == null || put_before == null) {
               // No elements examined, add to <ol> or add as last
               new_li = $('#sub-menu-helden').append(new_li);
            } else {
               // Add before given element
               new_li = $(new_li).insertBefore(put_before);
            }
            // Add onclick to <li>
            new_li.click(function() {
               select_char(response.character_id);
            });
         }
         function update_name(new_name) {
            // Update h2 element
            $('#main_name').text(htmlescape(new_name));
         }
         function edit_name(char_id) {
            $('#char_id').val(char_id);
            $('#name').val($('#main_name').text());
            show_div($('#div_name'), $('#img_edit_name'), $('#name'));
         }
         function select_char(char_id) {
            $.ajax({
               type    : 'POST',
               url     : 'characters.php',
               data    : { 'stage'   : 'main',
                           'char_id' : char_id },
               datatype: 'json',
               success : show_char_main
            });
         }
         function show_char_main(data) {
            try {
               character = $.parseJSON(data);
            } catch(e) {
                  alert(e + "\nData: " + character.toSource());
                  return false;
            }
            if (! character.success) {
               if (character.message) {
                  alert('Error: ' + character.message);
               }
               return false;
            }
            // Character data is in an array called data, retrieve that
            data = character.data;
            character_id = data.id;
            // Set data
            $('#main_name').text(htmlescape(data.name));
            $('#geschlecht').val(htmlescape(data.geschlecht));
            $('#alter').val(htmlescape(data.alter));
            $('#haarfarbe').val(htmlescape(data.haarfarbe));
            $('#grosse').val(htmlescape(data.grosse));
            $('#gewicht').val(htmlescape(data.gewicht));
            $('#augenfarbe').val(htmlescape(data.augenfarbe));
            $('#aussehen').val(htmlescape(data.aussehen));
            $('#rasse').val(htmlescape(data.rasse));
            $('#kultur').val(htmlescape(data.kultur));
            $('#profession').val(htmlescape(data.profession));
            // Set function
            $('#img_edit_name').click(function() {
               edit_name(data.id);
            });
            // Show main
            $('#main').show();
            // Set eigenschaften from array 'eigenschaften'
            $.each(character.eigenschaften, function(index, value) {
               var eigenschaft = value.name.toLowerCase();
               $('#eigenschaften #' + eigenschaft + '_base').val(value.base);
               var total = value.base;
               if (value.zugekauft) {
                  total += value.zugekauft;
                  $('#eigenschaften #' + eigenschaft + '_zugekauft').val(value.zugekauft);
               }
               if (value.modifier) {
                  total += value.modifier;
                  $('#eigenschaften #' + eigenschaft + '_modifier').val(value.modifier);
               }
               $('#eigenschaften #' + eigenschaft).val(total);
            });
         }
         function new_character() {
            // Empty fields
            $('#name').val('');
            $('#char_id').val(0);
            // Ask for name and show div
            show_div($('#div_name'), $('#btn_new_character'), $('#name'));
         }
         function show_div(div_to_show, elem_to_align, elem_to_focus) {
            // Align div
            var pos = elem_to_align.position();
            div_to_show.css({top  : pos.top + 30,
                             left : pos.left + elem_to_align.width - div_to_show.width() + 15});
            // Show div
            div_to_show.slideDown();
            elem_to_focus.focus();
         }
         {/literal}//-->
      </script>
   </body>
</html>

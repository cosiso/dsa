<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
   <head>
      <title>DSA - characters</title>
      <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
      <link href="css/dsa.css" rel="stylesheet" type="text/css" />
      <link href="css/alertify.css" rel="stylesheet" type="text/css" />
      <link href="css/selectize.default.css" rel="stylesheet" type="text/css" />
   </head>
   <body>
      {include file="head.tpl"}
      {include file="character_menu.tpl" selected="main"}
      <div style="float: left">
         <div id="main">
            <div>
               <h2 id="main_name" style="display: inline"></h2>
               {carto_spacer width=40}
               <img id="img_edit_name" src="images/page_white_paint.png" alt="edit" border="0" style="cursor: pointer" />
            </div>
            <div id="data">
               <h3 onclick="toggle_h3('general_data', false)">General data</h3>
               <div id="general_data" style="display: none">
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
                  <div>{carto_spacer}</div>
                  <label for="aussehen">Aussehen:</label>
                  {html_textarea name='aussehen' style='width: 100%; height: 60px'}
                  <hr />
                  <label>Abenteurpunkte</label>
                  Available: {html_text name='ap' value=$ap style="width: 6em"}
                  Add {html_text name="add_ap" style="width: 4em" onblur='add_ap(1)'}
                  Subtract {html_text name="sub_ap" style="width: 4em" onblur='add_ap(-1)'}
               </div>
               <hr />
               <h3 id="h3_eigenschaften">Eigenschaften &amp; Basiswerte</h3>
               <div id="eigenschaften" style="display: none">
               </div>
               <hr />
               {* Vor- & Nachteile *}
               <h3 id="h3_vorteile">Vor- &amp; Nachteile</h3>
               <div id="vorteile"></div>
               <hr />
            </div>
            {carto_spacer height=16}<br /><a id="btn_remove_char" class="link-del">Remove character</a>
         </div>
      </div>
      <script src="scripts/jquery.js"></script>
      <script src="tools/jquery-ui-1.10.4/ui/minified/jquery-ui.min.js"></script>
      <script type="text/javascript" src="scripts/jquery.validate.min.js"></script>
      <script type="text/javascript" src="scripts/jquery.form.min.js"></script>
      <script type="text/javascript" src="scripts/alertify.min.js"></script>
      <script type="text/javascript" src="scripts/selectize.min.js"></script>
      <script type="text/javascript" src="scripts/jquery.simpletip-1.3.1.min.js"></script>
      <script type="text/javascript" src="scripts/jquery.tablesorter.min.js"></script>
      <script type="text/javascript">
         <!--{literal}
         var old_val = {};
         var character_id = 0;
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
            });
            // Set onblur on edit-fields
            $('#data #general_data input[type=text], #data textarea').blur(blur_general_data);
         });
         function add_ap(multiply) {
            if (multiply > 0) {
               // Add
               field = '#general_data #add_ap';
               var value = parseInt($('#general_data #add_ap').val()) || 0;
            } else {
               // Subtract
               var value = parseInt($('#general_data #sub_ap').val()) || 0;
               value = 0 - value
               field = '#general_data #sub_ap';
            }
            if (! character_id or value == 0) {
               // No character selected or no value, simply clear field and return
               $(field).val('');
               return;
            }
            // TODO
         }
         function ask_new_character() {
            alertify.prompt('Name of new character', function(e, str) {
               if (e && str != '') {
                  $.ajax({
                     datatype : 'json',
                     url      : 'characters.php',
                     data     : {'stage'   : 'new',
                                 'char_id' : 0,
                                 'name'    : str},
                     success  : do_add_character
                  });
               }
            });
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
         function toggle_h3(div_name, close_others) {
            // set close_others to true, TODO change later
            close_others = true;
            // Opens the div with the given name, closes all others
            if (close_others) {
               $('#data h3 + div').slideUp();
            }
            $('h3 + div#' + div_name).slideDown();
         }
         function update_field(data) {
            try {
               data = $.parseJSON(data);
            } catch(e) {
                  alertify.alert(e + "\nData: " + data.toSource());
                  return false;
            }
            if (! data.success) {
               if (data.message) {
                  alertify.alert('Error: ' + data.message);
               }
               // Something went wrong, restore old value
               alertify.alert('Could not update ' + data.fieldname + ', reset to ' + old_val[data.fieldname]);
               $('#' + data.fieldname).val(old_val[data.fieldname]);
               $('#' + data.fieldname).prop('disabled', false);
               return false;
            }
            // All went fine, enable field
            $('#' + data.fieldname).prop('disabled', false);
            return true;
         }
         function showRequest(formData, jqForm, options) {
            // formData is an array; here we use $.param to convert it to a string to display it
            // but the form plugin does this for you automatically when it submits the data
            var queryString = $.param(formData);

            // jqForm is a jQuery object encapsulating the form element.  To access the
            // DOM element for the form do this:
            // var formElement = jqForm[0];

            alertify.alert('About to submit: \n\n' + queryString);

            // here we could return false to prevent the form from being submitted;
            // returning anything other than false will allow the form submit to continue
            return true;
         }
         function htmlescape(s) {
            return $('<div />').text(s).html();
         }
         function do_add_character(response, status, xhr, form) {
            if (! status) {
               alertify.alert('Error processing request, try again');
               return false;
            }
            response = $.parseJSON(response);
            if (! response.success) {
               alertify.alert('Error: ' + response.message);
               return false;
            }
            // Check if this was an update
            if (response.update) {
               // This is an update return from another function
               return update_name(response.name, response.character_id);
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
         function update_name(new_name, id) {
            // Update h2 element
            $('#main_name').text(htmlescape(new_name));
            // Update li-item
            $('#li-char-' + id).text(new_name);
         }
         function edit_name(char_id) {
            var name = $('#main_name').text();
            alertify.prompt('New name of character', function(e, str) {
               if (e && str != '') {
                  $.ajax({
                     datatype : 'json',
                     url      : 'characters.php',
                     data     : {'stage'   : 'new',
                                 'char_id' : char_id,
                                 'name'    : str},
                     success  : do_add_character
                  });
               }
            }, name);
            return false;
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
                  alertify.alert(e + "\nData: " + character.toSource());
                  return false;
            }
            if (! character.success) {
               if (character.message) {
                  alertify.alert('Error: ' + character.message);
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
            // Set ap
            $('#general_data #ap').val(data.ap);
            // Set or replace function for name editing
            $('#img_edit_name').unbind('click').click(function() {
               edit_name(data.id);
            });
            // Set function on remove button
            $('#btn_remove_char').unbind('click').click(function() {
               confirm_delete_char(data.name, data.id);
            });
            // Set funtion on h3-elements
            $('#h3_vorteile').unbind('click').click(function() {
               retrieve_vorteile(data.id);
               toggle_h3('vorteile', false);
            })
            $('#h3_eigenschaften').unbind('click').click(function() {
               retrieve_eigenschaften(data.id);
               toggle_h3('eigenschaften', false);
            })

            // Set page on general data
            toggle_h3('general_data', true);
            // Set array with old_values
            $('#eigenschaften #div_eigenschaften input[type=text]').each(function(index, value) {
               old_val[$(value).prop('id')] = $(value).val();
            });
         }
         function confirm_delete_char(name, id) {
            alertify.confirm('Remove ' + name + '?', function(e) {
               if (e) {
                  $.ajax({
                     datatype : 'json',
                     url      : 'characters.php',
                     data     : {'stage' : 'remove',
                                 'id'    : id},
                     success  : do_remove_character
                  });
                  alertify.log('Removing ' + name);
               }
            })
            return false;
         }
         function do_remove_character(data) {
            data = extract_json(data);
            if (data.success) {
               // Hide main as the character is no longer available
               $('#main').hide();
               // Remove from list
               $('#li-char-' + data.id).remove();
            }
         }
         {/literal}//-->
      </script>
      {include file='characters_vorteile_js.tpl'}
      {include file='character_eigenschaften_js.tpl'}
   </body>
</html>

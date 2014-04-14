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
         <!--{literal}
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
         });
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
            character = $.parseJSON(data);
            // Character data is in an array called data, retrieve that
            data = character.data;
            // Set data
            $('#main_name').text(htmlescape(data.name));
            // Set function
            $('#img_edit_name').click(function() {
               edit_name(data.id);
            });
            // Show main
            $('#main').show();
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

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
      {include file="character_menu.tpl"}
      {carto_button name='btn_new_character' value='New Character' onclick="new_character()"}
      <div id="div_name" class="popup" style="display: none; width: 350px">
         <form name="frm_name" id="frm_name">
            {html_hidden name="stage" value="new"}
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
            // Nothing yet
            $('#frm_name').validate({
               submitHandler: function(form) {
                  $(form).ajaxSubmit({
                     success : do_add_character,
                     type    : 'post',
                     beforeSubmit: showRequest,
                     datatype: 'json'
                  });
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
         function do_add_character(responseText, statusText, xhr, $form) {
            alert('responseText: ' + responseText.toString());
            alert('statusText: ' + statusText.toString());
            alert('xhr' + xhr.toString());
            alert('form ' + form.toString());
         }
         function submit_name() {
            // Validate frm_name and do something
            alert('Submit nothing :)');
            return false;
         }
         function new_character() {
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

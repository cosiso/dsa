<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
   <head>
      <title>DSA - setup</title>
      <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
      <link href="css/dsa.css" rel="stylesheet" type="text/css" />
   </head>
   <body>
      {include file="head.tpl"}
      {include file="setup_menu.tpl" selected_category="Vorteile"}
      <div style="float: left">
         <div id="main">
            <h3 onclick="toggle_h3(this)">Vorteile</h3>
            <div id="vorteile" style="display: none">
               Vorteile...
            </div>
            <h3 onclick="toggle_h3(this)">Nachteile</h3>
            <div id="nachteile" style="display: none">
               Nachteile...
            </div>
         </div>
      </div>
      <br style="float: none" /><br />
      {carto_spacer width='200px'}
      {carto_button id='btn_add_vorteil' value='Add vorteil' onclick='add_vorteil(true)'}
      <div id="div_vorteil" class="popup" style="display: none; width: 700px; height: 350px">
         <form name="frm_vorteil" id="frm_vorteil">
            {html_hidden name="stage" value="new"}
            {html_hidden name='id' value=0}
            {html_hidden name="is_vorteil" value=1}
            <label for="name">Name</label>
            <input type="text" id="name" name="name" style="width: 20em" required /><br />
            <label for="gp">GP</label>
            {html_text name='gp' style='width: 3em'}
            <label for="gp">AP</label>
            {html_text name='ap' style='width: 3em'}
            <label for="effect">Effect</label>
            <textarea name="effect" id="effect" style="width: 90%; height: 4em" required></textarea>
            <label for="description">Description</label>
            <textarea name="description" id="effect" style="width: 90%; height: 4em"></textarea>
            <div class="button_bar">
               {carto_button type='submit'}
               {carto_button type='close' onclick="$('#div_vorteil').slideUp()"}
            </div>
         </form>
      </div>
      <script src="scripts/jquery.js"></script>
      <script src="tools/jquery-ui-1.10.4/ui/minified/jquery-ui.min.js"></script>
      <script type="text/javascript">
         <!--{literal}
         function toggle_h3(elem_h3) {
            var div = $(elem_h3).text();
            div = div.toLowerCase();
            // Opens the div with the given name, closes all others
            $('#main h3 + div').slideUp();
            $('#' + div).slideDown();
         }
         function fill_frm_vorteil(id, name, gp, ap, effect, description, is_vorteil) {
            $('#frm_vorteil #id').val(id);
            $('#frm_vorteil #name').val(name);
            $('#frm_vorteil #gp').val(gp);
            $('#frm_vorteil #ap').val(ap);
            $('#frm_vorteil #effect').val(effect);
            $('#frm_vorteil #description').val(description);
            if (is_vorteil) {
               $('#frm_vorteil #is_vorteil').val(1);
            } else {
               $('#frm_vorteil #is_vorteil').val(0);
            }
         }
         function add_vorteil(is_vorteil) {
            fill_frm_vorteil(0, '', '', '', '', '', is_vorteil);
            show_div($('#div_vorteil'), $('#btn_add_vorteil'), $('#frm_vorteil #name'));
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
         //-->{/literal}
      </script>
   </body>
</html>
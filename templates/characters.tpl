<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
   <head>
      <title>DSA - setup</title>
      <link href="css/dsa.css" rel="stylesheet" type="text/css" />
      {$xajax_script}
   </head>
   <body>
      {include file="head.tpl"}
      <div class="caption_left" style="width: 200px; float: left">Characters</div>
      <div style="float: left">
         <table cellspacing="0">
            <tr id="chars_head">
               <th style="text-align: left">Name</th>
               <th>&nbsp;</th>
            </tr>
            {section name=idx loop=$characters}
               <tr id="row_{$characters[idx].id}" onmouseover="highlight_row({$characters[idx].id})" onmouseout="unhighlight_row({$characters[idx].id})">
                  <td style="padding-right: 5px">{$characters[idx].name|escape}</td>
                  <td>
                     <a href="javascript:edit_char({$characters[idx].id})" class="link-edit">edit</a>
                     | <a href="javascript:remove_char({$characters[idx].id})" class="link-cancel">remove</a>
                  </td>
               </tr>
            {/section}
         </table>
         <div id="div_char" style="display: none; border: 1px solid #4682b4; margin-top: 5px; padding: 2px">
         </div>
      </div>
      <br style="float: none" /><br />
      {carto_spacer width='200px'}
      {carto_button id='btn_new_char' value='New character' onclick='new_character()'}
      <br />
      <div id="div_new_char" class="popup" style="display: none; height: 100px">
         Name:<br />
         {html_text name='name' style='width: 10em'}<br />
         <br />
         {carto_button type='submit' onclick="submit_new_character()"}
         {carto_button type='close' onclick="$('div_new_char').hide()"}
      </div>
   </body>
   <script type="text/javascript" src="scripts/prototype.js"></script>
   <script type="text/javascript" src="scriptaculous-js/src/scriptaculous.js?load=effects"></script>
   <script type="text/javascript">
      <!--
      {literal}
      var old_bg = document.body.style.backgroundColor
      var hi_bg = '#ffe4c4'
      var sel_char = 0
      function submit_general() {
         // No validation done here
         xajax_save_general(xajax.getFormValues('frm_char_general'))
         // Don't make a request, so always return false
         return false;
      }
      function display_general() {
         // Do nothing if there is no character selected
         if (sel_char == 0) {
            alert('No character selected')
            return false
         }
         // Make request to fill div
         xajax_show_general(sel_char)
      }
      function edit_char(char_id) {
         // Set selected character
         sel_char = char_id
         // Make sure character div is visible
         $('div_char').show()
         display_general()
      }
      function do_remove_char(char_id) {
         var row = $('row_' + char_id)
         new Effect.Fade(row)
         row.remove()
         // Unset sel_char if the selected character was removed
         if (sel_char == char_id) {
            $('div_char').hide()
            sel_char = 0
         }
      }
      function remove_char(char_id) {
         // Set different old_bg to prevent highlight from disappearing
         var tmp = old_bg
         old_bg = '#cd5c5c'
         $('row_' + char_id).style.backgroundColor = '#cd5c5c'
         if (confirm('Do you really want to delete this character?')) {
            xajax_remove_character(char_id)
         }
         old_bg = tmp
         $('row_' + char_id).style.backgroundColor = old_bg
      }
      function highlight_row(row_id) {
         $('row_' + row_id).style.backgroundColor = hi_bg
      }
      function unhighlight_row(row_id) {
         $('row_' + row_id).style.backgroundColor = old_bg
      }
      function do_new_character(char_id, char_name) {
         // Build the element
         var row = '<tr id="row_' + char_id +'" style="display:none" onmouseover="highlight_row(' + char_id + ')" onmouseout="unhighlight_row(' + char_id + ')">'
         row += '<td>' + char_name.escapeHTML() + '</td>'
         row += '<td><a href="javascript:edit_char(' + char_id + ')" class="link-edit">edit</a> | '
         row += '<a href="javascript:remove_char(' + char_id +')" class="link-cancel">remove</a></td></tr>'
         // Get the siblings of the table head row, i.e. the defined rows
         var siblings = $('chars_head').siblings()
         if ( siblings.length == 0) {
            // No traits defined yet, insert after table header
            is_inserted = 1
            $('chars_head').insert({after: row})
         } else {
            var is_inserted = 0
            var newrow     //declare newrow here, so it can be accessed outside of the loop
            // We have an array of siblings, find our spot
            for (var idx=0; idx < siblings.length; idx++) {
               newrow = siblings[idx]
               // Get the childelements
               var childs = newrow.childElements()
               // We need to have the name, which is in the first child
               var name = childs[0].innerHTML
               if (char_name.localeCompare(name) < 0) {
                  // We should be before this one, insert element
                  is_inserted = 1
                  newrow.insert({before: row})
                  break
               }
            }
            // Check to see if we still need to be inserted
            if (is_inserted == 0) {
               // Put us at the back, newrow contains the last row
               newrow.insert({after: row})
            }
         }
         // Row is at the right spot, show it
         new Effect.Appear('row_' + char_id)
      }
      function new_character() {
         // Clear name
         $('name').value = ''
         var div = $('div_new_char')
         if (! div.visible()) {
            // Place div
            var off = $('btn_new_char').cumulativeOffset()
            div.style.left = off[0] + 'px'
            var newtop = off[1] +25
            div.style.top = newtop + 'px'
            // Make div visible
               new Effect.toggle(div, 'blind', {duration: 0.3})
         }
      }
      function submit_new_character() {
         var char_name = $F('name')
         if (char_name == '') {
            alert('No character name specified')
            $('name').focus
            return false
         }
         xajax_new_character(char_name)
         $('div_new_char').hide()
      }
      //{/literal}-->
   </script>
</html>
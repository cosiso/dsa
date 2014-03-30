<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
   <head>
      <title>DSA - setup</title>
      <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
      <link href="css/dsa.css" rel="stylesheet" type="text/css" />
      {$xajax_script}
   </head>
   <body>
      {include file="head.tpl"}
      <div class="caption_left" style="width: 200px; float: left">Traits</div>
      <div style="float: left">
         <table cellspacing="0">
            <tr id="traits_head">
               <th style="text-align: left">Name</th>
               <th style="text-align: left">Abbreviation</th>
               <th>&nbsp;</th>
            </tr>
            {section name=idx loop=$traits}
               <tr id="row_{$traits[idx].id}" onmouseover="highlight_row({$traits[idx].id})" onmouseout="unhighlight_row({$traits[idx].id})">
                  <td style="padding-right: 5px">{$traits[idx].name|escape}</td>
                  <td style="padding-right: 5px">{$traits[idx].abbr|escape}</td>
                  <td>
                     <a href="javascript:edit_trait({$traits[idx].id})" class="link-edit">edit</a>
                     | <a href="javascript:remove_trait({$traits[idx].id})" class="link-cancel">remove</a>
                  </td>
               </tr>
            {/section}
         </table>
      </div>
      <br style="float: none" /><br />
      {carto_spacer width='200px'}
      {carto_button id='btn_add_trait' value='Add trait' onclick='add_trait()'}
      <br />
      <div id="add_trait" class="popup" style="display: none">
         {html_hidden name='trait_id' value=0}
         Name:<br />
         {html_text name='trait_name' style='width: 10em'}<br />
         Abbreviation:<br />
         {html_text name='trait_abbr' style='width: 3em' maxlength=3}<br /><br />
         {carto_button type='submit' onclick="submit_add_trait()"}
         {carto_button type='close' onclick="$('add_trait').hide()"}
      </div>
   </body>
   <script type="text/javascript" src="scripts/prototype.js"></script>
   <script type="text/javascript" src="scriptaculous-js/src/scriptaculous.js?load=effects"></script>
   <script type="text/javascript">
      <!--{literal}
      var old_bg = document.body.style.backgroundColor
      var hi_bg = '#ffe4c4'
      function highlight_row(row_id) {
         $('row_' + row_id).style.backgroundColor = hi_bg
      }
      function unhighlight_row(row_id) {
         $('row_' + row_id).style.backgroundColor = old_bg
      }
      function show_add_trait() {
         var div = $('add_trait')
         if (! div.visible()) {
            // Place div
            var div = $('add_trait')
            var off = $('btn_add_trait').cumulativeOffset()
            div.style.left = off[0] + 'px'
            var newtop = off[1] +25
            div.style.top = newtop + 'px'
            // Make div visible
               new Effect.toggle(div, 'blind', {duration: 0.3})
         }
      }
      function edit_trait(trait_id) {
         // Fetch row and get current values
         var children = $('row_' + trait_id).childElements()
         $('trait_name').value = children[0].innerHTML.unescapeHTML()
         $('trait_abbr').value = children[1].innerHTML.unescapeHTML()
         $('trait_id').value = trait_id
         show_add_trait()
      }
      function add_trait() {
         // Set empty values
         $('trait_id').value = 0
         $('trait_name').value = ''
         $('trait_abbr').value = ''
         show_add_trait()
      }
      function do_edit_trait(trait_id, trait_name, trait_abbr) {
         // Get the row that needs updating
         var row = $('row_' + trait_id)
         var children = row.childElements()
         // Update fields
         children[0].update(trait_name.escapeHTML())
         children[1].update(trait_abbr.escapeHTML())
         new Effect.Highlight(row, {duration: 1})
      }
      function do_add_trait(trait_id, trait_name, trait_abbr) {
         // Build the element
         var row = '<tr id="row_' + trait_id +'" style="display:none" onmouseover="highlight_row(' + trait_id + ')" onmouseout="unhighlight_row(' + trait_id + ')">'
         row += '<td>' + trait_name.escapeHTML() + '</td>'
         row += '<td>' + trait_abbr.escapeHTML() + '</td>'
         row += '<td><a href="javascript:add_trait(' + trait_id + ')" class="link-edit">edit</a> | '
         row += '<a href="javascript:remove_trait(' + trait_id +')" class="link-cancel">remove</a></td></tr>'
         // Get the siblings of the table head row, i.e. the defined rows
         var siblings = $('traits_head').siblings()
         if ( siblings.length == 0) {
            // No traits defined yet, insert after table header
            is_inserted = 1
            $('traits_head').insert({after: row})
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
               if (trait_name.localeCompare(name) < 0) {
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
         new Effect.Appear('row_' + trait_id)
      }
      function submit_add_trait() {
         // Check values
         if (! $F('trait_name')) {
            alert('No name for trait entered')
            $('trait_name').focus()
            return false;
         }
         if (! $F('trait_abbr')) {
            alert('No abbreviation specified for this trait')
            $('trait_abbr').focus()
            return false
         }
         // Make Ajax-request, close div
         xajax_add_trait($F('trait_id'), $F('trait_name'), $F('trait_abbr'))
         $('add_trait').hide()
         return false
      }
      function remove_trait(trait_id) {
         // Set different old_bg to prevent highlight from disappearing
         var tmp = old_bg
         old_bg = '#cd5c5c'
         $('row_' + trait_id).style.backgroundColor = '#cd5c5c'
         if (confirm('Do you really want to delete this trait?')) {
            xajax_remove_trait(trait_id)
         }
         old_bg = tmp
         $('row_' + trait_id).style.backgroundColor = old_bg
      }
      function do_remove_trait(trait_id) {
         var row = $('row_' + trait_id)
         new Effect.Fade(row)
         row.remove()
      }
      //-->{/literal}
   </script>
</html>

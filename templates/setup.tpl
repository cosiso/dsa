<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
   <head>
      <title>DSA - setup</title>
      <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
      <link href="css/dsa.css" rel="stylesheet" type="text/css" />
      {$xajax_script}
   </head>
   <body>
      <script type="text/javascript" src="scripts/prototype.js"></script>
      <script type="text/javascript" src="scriptaculous-js/src/scriptaculous.js?load=effects"></script>
      <script src="scripts/jquery.js"></script>
      <script src="tools/jquery-ui-1.10.4/ui/minified/jquery-ui.min.js"></script>
      <script type="text/javascript">
         <!--{literal}
         jQuery.noConflict();
         jQuery(document).ready(function( $ ) {
            // give hover action to rows with attribute rowhover
            $( "tr[rowhover]" ).hover(function(){$(this).toggleClass('row-hover')});
            // Position add_trait div
            var div = $('#add_trait');
            var btn = $('#btn_add_trait');
            var pos = btn.position();
            div.css({top:  pos.top + 30,
                     left: pos.left + btn.width() - div.width() + 15}); 
            // Capture enter key on inputs for add_trait div
            $('#add_trait').on('keydown', 'input', function(e) {
               if (e.keyCode == 13) {
                  submit_add_trait();
               }
            });
         });
         //-->{/literal}
      </script>
      {include file="head.tpl"}
      <div class="caption_left" style="width: 200px; float: left">Eigenschaften</div>
      <div style="float: left">
         <table id="table_traits" cellspacing="0">
            <thead>
            <tr id="traits_head">
               <th style="text-align: left">Name</th>
               <th style="text-align: left">Abbreviation</th>
               <th>&nbsp;</th>
            </tr>
            </thead>
            {section name=idx loop=$traits}
               <tr rowhover="yes" id="row_{$traits[idx].id}">
                  <td style="padding-right: 5px" id="cell_name">{$traits[idx].name|escape}</td>
                  <td style="padding-right: 5px" id="cell_abbr">{$traits[idx].abbr|escape}</td>
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
         {carto_button type='close' onclick="jQuery('#add_trait').slideUp()"}
      </div>
   </body>
   <script type="text/javascript">
      <!--{literal}
      function show_add_trait() {
         jQuery('#add_trait').slideDown();
         jQuery('#trait_name').focus();
      }
      function fill_trait_form(id, name, abbr) {
         jQuery('#trait_id').val(id);
         jQuery('#trait_name').val(name);
         jQuery('#trait_abbr').val(abbr);
      }
      function edit_trait(trait_id) {
         // Fetch row and get current values
         var row = '#row_' + trait_id;
         var name = row + ' > #cell_name';
         var abbr = row + ' > #cell_abbr';
         fill_trait_form(trait_id, jQuery(name).text(), jQuery(abbr).text());
         show_add_trait();
      }
      function add_trait() {
         // Set empty values
         fill_trait_form(0, '', '');
         show_add_trait();
      }
      function do_edit_trait(trait_id, trait_name, trait_abbr) {
         // Get the row that needs updating
         jQuery('#row_' + trait_id + ' > #cell_name').text(trait_name);
         jQuery('#row_' + trait_id + ' > #cell_abbr').text(trait_abbr);
         jQuery('#row_' + trait_id).effect('highlight', {}, 2000);
      }
      function do_add_trait(trait_id, trait_name, trait_abbr) {
         // Find where to insert
         var row_id = 0; var cur_row = 0; var last = true;
         jQuery('#table_traits td#cell_name').each(function() {
            cur_row++;
            row_text = jQuery(this).text();
            // alert('Current row = ' + cur_row + ', Trait: ' + trait_name + ', Row: ' + row_text);
            if (trait_name.localeCompare(row_text) <= 0) {
              // New trait should be before inspected trait
              row_id = cur_row;
              last = false;
              return false;
            }
         });
         // Build the element
         var row = '<tr rowhover="yes" id="row_' + trait_id +'" >';
         row += '<td style="padding-right: 5px" id="cell_name">' + trait_name.escapeHTML() + '</td>';
         row += '<td style="padding-right: 5px" id="cell_abbr">' + trait_abbr.escapeHTML() + '</td>';
         row += '<td><a href="javascript:edit_trait(' + trait_id + ')" class="link-edit">edit</a> | ';
         row += '<a href="javascript:remove_trait(' + trait_id + ')" class="link-cancel">remove</a></td></tr>';
         // Insert new element
         if (last == true) {
            jQuery(row).insertAfter(jQuery('#table_traits tr').last());
         } else {
            jQuery(row).insertBefore(jQuery('#table_traits tr:nth(' + row_id + ')'));
         }
         // Highlight element
         jQuery('#row_' + trait_id).effect('highlight', {}, 2000);
         // Add hover-class to element
         jQuery('#row_' + trait_id).hover(function(){jQuery(this).toggleClass('row-hover')});
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
         var row = jQuery('#row_' + trait_id);
         row.addClass('row-highlight');
         // Set different old_bg to prevent highlight from disappearing
         if (confirm('Do you really want to delete this trait?')) {
            xajax_remove_trait(trait_id)
         }
         row.removeClass('row-highlight');
      }
      function do_remove_trait(trait_id) {
         var row = $('row_' + trait_id)
         new Effect.Fade(row)
         row.remove()
      }
      //-->{/literal}
   </script>
</html>

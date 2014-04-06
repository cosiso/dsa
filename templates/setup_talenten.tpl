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
      {* <script src="scripts/jquery.easytabs.min.js"></script> *}
      <script type="text/javascript">
         <!--{literal}
         $(document).ready(function( $ ) {
            // give hover action to rows with attribute rowhover
            $( "tr[rowhover]" ).hover(function(){$(this).toggleClass('row-hover')});
            // Capture enter key on inputs for add_trait div
            $('#add_category').on('keydown', 'input', function(e) {
               if (e.keyCode == 13) {
                  submit_add_category();
               }
            });
            // Activate tabs
            //$('#tab-container').easytabs({tabClass: 'tab-inactive',
            //                              tabActiveClass: 'tab-active',
            //                              defaultTab: '#default-tab'});
            $('#default-tab a').addClass('tab-inactive').addClass('tab-active');
         });
         //-->{/literal}
      </script>
      {include file="head.tpl"}
      {include file="setup_menu.tpl" selected_category="Talenten"}
      <div style="float: left" id="tab-container">
         <ul class="tabs">
            <li id="default-tab"><a href="#tabs-categories">Categories</a></li>
            {* <li><a href="#tabs-unused">Unused</a></li> *}
         </ul>
         <div id="tabs-categories">
            <br />
            <table id="table_categories" cellspacing="0">
               <thead>
               <tr id="traits_head">
                  <th style="text-align: left">Name</th>
                  <th style="text-align: left">SKT</th>
                  <th>&nbsp;</th>
               </tr>
               </thead>
               {section name=idx loop=$categories}
                  <tr rowhover="yes" id="row_{$categories[idx].id}">
                     <td style="padding-right: 5px" id="cell_name">{$categories[idx].name|escape}</td>
                     <td style="padding-right: 5px" id="cell_skt">{$categories[idx].default_skt|escape}</td>
                     <td>
                        <a href="javascript:edit_categories({$categories[idx].id})" class="link-edit">edit</a>
                        | <a href="javascript:remove_categories({$categories[idx].id})" class="link-cancel">remove</a>
                     </td>
                  </tr>
               {/section}
            </table>
            <br style="float: none" /><br />
            {carto_spacer width='200px'}
            {carto_button id='btn_add_category' value='Add category' onclick='add_category()'}
            <br />
            <div id="add_category" class="popup" style="display: none">
               {html_hidden name='category_id' value=0}
               <label>Name:</label>
               {html_text name='category_name' style='width: 10em'}<br />
               <label>Default SKT</label>
               {html_text name='default_skt' style='width: 2em'} (A, B, C, D, E, F, G or H)<br />
               <div class="button_bar">
                  {carto_button type='submit' onclick="submit_add_category()"}
                  {carto_button type='close' onclick="hide_add_category()"}
               </div>
            </div>
         </div>
      </div>
   </body>
   <script type="text/javascript">
      <!--{literal}
      function add_category() {
         fill_category_form(0, '', '');
         show_add_category();
      }
      function fill_category_form(id, name, skt) {
         $('#category_id').val(id);
         $('#category_name').val(name);
         $('#default_skt').val(skt);
      }
      function show_add_category() {
         // Position add_trait div
         var div = $('#add_category');
         var btn = $('#btn_add_category');
         var pos = btn.position();
         div.css({top:  pos.top + 30,
                  left: pos.left + btn.width() - div.width() + 15});
         $('#add_category').slideDown();
         $('#category_name').focus();
      }
      function hide_add_category() {
         $('#add_category').slideUp();
      }
      function submit_add_category() {
         // Check values
         if (! $('#category_name').val()) {
            alert('No name for category specified');
            $('#category_name').focus();
            return false;
         }
         // Data for posting
         var postForm = {
            'stage'        : 'add_category',
            'category_id'  : $('#category_id').val(),
            'category_name': $('#category_name').val(),
            'default_skt'  : $('#default_skt').val()
         }
         // Make Ajax-request
         $.ajax({
            type    : 'POST',
            url     : 'setup_talenten.php',
            data    : postForm,
            datatype: 'json',
            success : function(data) {
               try {
                  data = $.parseJSON(data);
               } catch(e) {
                  alert(e + "\nData: " + data.toSource());
               }
               if (data.success) {
                  // See if this is and edit (existing)
                  if ($('#row_' + data.id).length) {
                     do_edit_category(data.id, data.name, data.skt);
                  } else {
                     do_add_category(data.id, data.name, data.skt);
                  }
               } else {
                  alert('Error adding category: ' + data.message);
               }
            }
         }
         )
         hide_add_category();
      }
      function do_add_category(category_id, category_name, category_skt) {
         // Find where to insert
         var row_id = 0; var cur_row = 0; var last = true;
         $('#table_categories #cell_name').each(function() {
            cur_row++;
            row_text = $(this).text();
            if (category_name.localeCompare(row_text) <= 0) {
               // New category should be before inspected category
               row_id = cur_row;
               last = false;
               return false;
            }
         });
         // Build the element
         var row = '<tr rowhover="yes" id="row_' + category_id +'" >';
         row += '<td style="padding-right: 5px" id="cell_name">' + category_name + '</td>';
         row += '<td style="padding-right: 5px" id="cell_skt">' + category_skt + '</td>';
         row += '<td><a href="javascript:edit_category(' + category_id + ')" class="link-edit">edit</a> | ';
         row += '<a href="javascript:remove_categories(' + category_id + ')" class="link-cancel">remove</a></td></tr>';
         // Insert new element
         if (last == true) {
            $(row).insertAfter($('#table_categories tr').last());
         } else {
            $(row).insertBefore($('#table_categories tr:nth(' + row_id + ')'));
         }
         // Highlight element
         $('#row_' + category_id).effect('highlight', {}, 2000);
         // Add hover-class to element
         $('#row_' + category_id).hover(function(){$(this).toggleClass('row-hover')});
      }
      function edit_categories(category_id) {
         // Fetch row and get current values
         var row = '#row_' + category_id;
         var name = row + ' #cell_name';
         var skt = row + ' #cell_skt';
         fill_category_form(category_id, jQuery(name).text(), jQuery(skt).text());
         show_add_category();
      }
      function do_edit_category(category_id, name, skt) {
         // Get the row that needs updating
         jQuery('#row_' + category_id + ' #cell_name').text(name);
         jQuery('#row_' + category_id + ' #cell_skt').text(skt);
         jQuery('#row_' + category_id).effect('highlight', {}, 2000);
      }
      function remove_categories(category_id) {
         var row = jQuery('#row_' + category_id);
         row.addClass('row-highlight');
         // Set different old_bg to prevent highlight from disappearing
         if (confirm('Do you really want to delete this category?')) {
            // Make Ajax-request
            $.ajax({
               type    : 'POST',
               url     : 'setup_talenten.php',
               data    : {'stage'      : 'remove_category',
                          'category_id': category_id},
               datatype: 'json',
               success : function(data) {
                  try {
                     data = $.parseJSON(data);
                  } catch(e) {
                     alert(e + "\nData: " + data.toSource());
                  }
                  if (data.success) {
                     $('#row_' + data.id).remove();
                  } else {
                    alert('Error adding category: ' + data.message);
                  }
               }
            });
         }
         row.removeClass('row-highlight');
      }
      //-->{/literal}
   </script>
</html>

{extends file='base.tpl'}
{block name='title'}DSA - Setup{/block}
{block name='menu_left'}{include file="setup_menu.tpl" selected_category="Vorteile"}{/block}
{block name='main'}
   <div style="float: left">
      <div id="main">
         <h3 onclick="toggle_h3(this)">Vorteile</h3>
         <div id="vorteile" style="display: none; max-width: 800px">
            <table id="table_vorteile" cellspacing="0" cellpadding="1" class="sortable">
               <thead>
                  <tr>
                     <th>Name</th>
                     <th>GP</th>
                     <th>AP</th>
                     <th>Effect</th>
                     <th>&nbsp;</th>
                  </tr>
               </thead>
               <tbody class="hover">
                  {section name=idx loop=$vorteile}
                     <tr id="vorteil_{$vorteile[idx].id}">
                        <td id="cell_name">{$vorteile[idx].name|escape}</td>
                        <td id="cell_gp">{$vorteile[idx].gp|escape}</td>
                        <td id="cell_ap">{$vorteile[idx].ap|escape}</td>
                        <td id="cell_effect">{$vorteile[idx].effect}</td>
                        <td id="cell_links">
                           <span id="span_desc_{$vorteile[idx].id}" style="display: none"></span>
                           <a href="#" class="link-info" onclick="show_info(this)">info</a>
                           | <a href="#" class="link-edit" onclick="show_edit(this)">edit</a>
                           | <a href="#" onclick="confirm_delete({$vorteile[idx].id})" class="link-cancel">remove</a>
                        </td>
                     </tr>
                  {/section}
               </tbody>
            </table>
            {if ! $vorteile}
               <div id="div_no_vorteile">No vorteile defined yet</div>
            {/if}
            <br />
            <a class="link-add" href="#" onclick="show_edit_cont(0, 1)">Add vorteil</a>
         </div>
         <h3 onclick="toggle_h3(this)">Nachteile</h3>
         <div id="nachteile" style="display: none">
            <table id="table_nachteile" cellspacing="0" cellpadding="1" class="sortable">
               <thead>
                  <tr>
                     <th>Name</th>
                     <th>GP</th>
                     <th>AP</th>
                     <th>Effect</th>
                     <th>&nbsp;</th>
                  </tr>
               </thead>
               <tbody class="hover">
                  {section name=idx loop=$nachteile}
                     <tr id="vorteil_{$nachteile[idx].id}">
                        <td id="cell_name">{$nachteile[idx].name|escape}</td>
                        <td id="cell_gp">{$nachteile[idx].gp|escape}</td>
                        <td id="cell_ap">{$nachteile[idx].ap|escape}</td>
                        <td id="cell_effect">{$nachteile[idx].effect}</td>
                        <td id="cell_links">
                           <span id="span_desc_{$nachteile[idx].id}" style="display: none"></span>
                           <a href="#" class="link-info" onclick="show_info(this)">info</a>
                           | <a href="#" class="link-edit" onclick="show_edit(this)">edit</a>
                           | <a href="#" onclick="alert('delete')" class="link-cancel">remove</a>
                        </td>
                     </tr>
                  {/section}
               </tbody>
            </table>
            {if ! $nachteile}
               <div id="div_no_nachteile">No nachteile defined yet</div>
            {/if}
            <br />
            <a class="link-add" href="#" onclick="show_edit_cont(0, 0)">Add nachteil</a>
         </div>
      </div>
   </div>
{/block}
{block name='javascript'}
   <script type="text/javascript">
      <!--
      $(document).ready(function() {
         // Make tables sortable
         $('#table_vorteile').tablesorter({ headers : { 3: { sorter: false },
                                                        4: { sorter: false }}});
         $('#table_nachteile').tablesorter({ headers : { 3: { sorter: false },
                                                         4: { sorter: false }}});
         // Set simpletips on edit links
         $('a[id^="edit_desc"]').each(function(index, value) {
            add_simpletip_to_edit($(this));
         });
      })
      jQuery.fn.center = function () {
          this.css("position","absolute");
          this.css("top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) +
                                                      $(window).scrollTop()) + "px");
          this.css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) +
                                                      $(window).scrollLeft()) + "px");
          return this;
      }
      function confirm_delete(id) {
         // Retrieve name of vorteil
         var name=$('#vorteil_' + id + ' #cell_name').text();
         alertify.confirm('Remove: ' + name + '?', function(e) {
            if (e) {
               $.ajax({
                  type     : 'post',
                  url      : 'setup_vorteile.php',
                  data     : { 'stage' : 'remove',
                               'id'    : id },
                  datatype : 'json',
                  success  : do_delete_vorteil
               });
            }
         });
         return false;
      }
      function do_delete_vorteil(data) {
         data = extract_json(data);
         if (data.success) {
            var row = $('#vorteil_' + data.id);
            row.effect('highlight', {}, 2000);
            row.remove();
         }
      }
      function htmlescape(s) {
         return $('<div />').text(s).html();
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
      function do_update_vorteil(response, status, xhr, form) {
         response = extract_json(response);
         if (! response.success) {
            return false;
         }
         if (response.update) {
            // Update the specified vorteil
            var row = '#vorteil_' + response.id;
            $(row + ' #cell_name').text(response.name);
            $(row + ' #cell_gp').text(response.gp);
            $(row + ' #cell_ap').text(response.ap);
            $(row + ' #cell_effect').text(response.effect);
            $(row).effect('highlight', {}, 2000);
         } else {
            // Add the specified vorteil
            var row = '<tr id="vorteil_' + response.id + '">' +
               '<td id="cell_name">' + htmlescape(response.name) + '</td>' +
               '<td id="cell_gp">' + htmlescape(response.gp) + '</td>' +
               '<td id="cell_ap">' + htmlescape(response.ap) + '</td>' +
               '<td id="cell_effect">' + htmlescape(response.effect) + '</td>' +
               '<td id="cell_links">' +
               '<a class="link-info" href="#" onclick="show_info(this)">info</a>' +
               '| <a href="#" class="link-edit" onclick="show_edit(this)">edit</a>' +
               ' | <a class="link-cancel" onclick="confirm_delete(' + response.id + ')" href="#">remove</a>' +
               '</td></tr>';
            // Append the row to the table
            if (response.vorteil) {
               $('#table_vorteile tbody').append(row);
            } else {
               $('#table_nachteile tbody').append(row);
            }
            $('#vorteil_' + response.id).effect('highlight', {}, 2000);
         }
      }
      function toggle_h3(elem_h3) {
         var div = $(elem_h3).text();
         div = div.toLowerCase();
         // Opens the div with the given name, closes all others
         $('#main h3 + div').slideUp();
         $('#' + div).slideDown();
      }
      function show_info(link) {
         // Get id from parent a > td > tr
         var id = $(link).parent().parent().prop('id');
         var dummy = id.split('_');
         id = dummy[1];
         $('#popup').text('Retrieving information');
         $('#popup').css('max-width', '500px').width('auto').height('auto').center();
         $('#popup').show();
         $('#popup').load('setup_vorteile.php', { stage : 'info', id : id }, function(response, status, xhr) {
            if (status == 'error') {
               alertify.alert('Unknown error');
               $('#popup').hide();
            } else {
               // Center again
               $('#popup').center();
            }
         });
         return false;
      }
      function show_edit(link) {
         // Get id from parent a > td > tr
         var id = $(link).parent().parent().prop('id');
         var dummy = id.split('_');
         id = dummy[1];
         show_edit_cont(id, undefined)
         return false;
      }
      function show_edit_cont(id, is_vorteil) {
         $('#popup').text('Retrieving information');
         $('#popup').css('max-width', '500px').width('auto').height('auto').center();
         $('#popup').show();
         $('#popup').load('setup_vorteile.php', { stage : 'show_edit', id : id, is_vorteil : is_vorteil }, function(response, status, xhr) {
            if (status == 'error') {
               alertify.alert('Unknown error');
               $('#popup').hide();
            } else {
               // Center again
               $('#popup').center();
               // Add validation
               $('form#edit_vorteil #name').focus().select();
               $('form#edit_vorteil').validate({
                  rules : {
                     name        : { required : true, maxlength : 64 },
                     gp          : { digits : true },
                     ap          : { digits : true },
                     effect      : { maxlength : 255 },
                     description : { maxlength : 4096 },
                  },
                  submitHandler : function(form) {
                     $(form).ajaxSubmit({
                        datatype : 'json',
                        url      : 'setup_vorteile.php',
                        type     : 'post',
                        success  : do_update_vorteil,
                     });
                     $('#popup').hide();
                  },
               });
            }
         });
         return false;
      }
      //-->
   </script>
{/block}

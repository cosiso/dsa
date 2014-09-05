{extends file='base.tpl'}
{block name='title'}DSA - Characters{/block}
{block name='menu_left'}{include file='character_menu.tpl' selected='talente'}{/block}
{block name='main'}
   {section name='idx' loop=$categories}
      <h3 class="toggle" onclick="toggle($(this).next())">{$categories[idx].name|escape}</h3>
      <div id="cat_{$categories[idx].id}" class="maxed" style="display: none"></div>
      <br>
   {sectionelse}
      <b>No talente defined yet</b>
   {/section}
{/block}
{block name='javascript'}
   <script type="text/javascript">
      <!--
      $(document).ready(function() {
         $.validator.addMethod('num', function(value, element, parameter) {
            return this.optional(element) || parseInt(value) == value;
         }, 'Value must be an integer');
      });
      function htmlescape(s) {
         return $('<div />').text(s).html();
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
      jQuery.fn.center = function () {
          this.css("position","absolute");
          this.css("top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) +
                                                      $(window).scrollTop()) + "px");
          this.css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) +
                                                      $(window).scrollLeft()) + "px");
          return this;
      }
      function toggle(div) {
         if ($(div).is(':visible')) {
            $(div).hide();
         } else {
            if (! $(div).html()) {
               var dummy = $(div).prop('id');
               dummy = dummy.split('_');
               var id = dummy[1];
               $(div).load('char_talente.php', { stage : 'show_talente', id : id }, function(response, status, xhr) {
                  if (status == 'error') {
                     alertify.alert('Unknown error');
                     return;
                  }
               });
            }
            $(div).show();
         }
      }
      function add_char(span) {
         // Get id from parent span > td > tr > tbody > table
         var dummy = $(span).parent().parent().parent().parent().prop('id');
         dummy = dummy.split('-');
         var talent_id = dummy[1];
         // Show div
         $('#popup').width('auto').height('auto').css('max-width', '').text('Fetching form').center().show();
         $('#popup').load('char_talente.php', { stage : 'form-add', id : talent_id }, function(response, status, xhr) {
            // Load succeeded
            $('#popup').center();
            $('#popup #frm_add').validate({
               rules : {
                  character_id : { required : true },
                  value        : { required : true, num : true },
                  note         : { maxlength : 1024 },
               },
               submitHandler : function(form) {
                  $(form).ajaxSubmit({
                     datatype : 'json',
                     url      : 'char_talente.php',
                     type     : 'post',
                     success  : do_add_char,
                  });
                  $('#popup').hide();
               },
            });
         });
      }
      function do_add_char(data) {
         data = extract_json(data);
         if (data.success) {
            var row = '<tr id="ct-' + data.ct_id + '">' +
               '<td>' + htmlescape(data.name) + '</td>' +
               '<td id="values">' + data.eig1 + ' - ' + data.eig2 + ' - ' + data.eig3 + '</td>' +
               '<td style="text-align: right">' + data.value + '</td>' +
               '<td>' +
                  '<img src="images/plus-16.png" border="0" alt="plus" style="cursor: pointer" onclick="ct_change(this, 1)"> ' +
                  '<img src="images/minus-16.png" border="0" alt="minus" style="cursor: pointer" onclick="ct_change(this, -1)">' +
               '</td>' +
               '<td onclick="roll_talent(this)"><img src="images/dice-red-16.png" border="0" alt="roll"></td>' +
               '<td id="note">' + htmlescape(data.note) + '</td>' +
               '<td>' +
               '<span class="link-edit" onclick="edit_note(this)">edit note</span> | ' +
               '<span class="link-cancel" onclick="remove_char(this)">remove</span></td>' +
               '</tr>';
            // Find where to prepend
            var last = $('table#chars-' + data.talent_id + ' tr:last');
            $(last).before(row);
            $(last).prev().effect('highlight', {}, 2000);
         }
      }
      function remove_char(span) {
         // Fetch row
         var row = $(span).parent().parent();
         // Fetch id from row
         var id = $(row).prop('id').split('-')[1];
         // Fetch char-name from td
         var name = $(row).children('td:first').text();
         console.log('Name: ' + name);
         alertify.confirm('Remove talent from ' + name + '?', function(e) {
            if (e) {
               // Remove row
               $(row).effect('highlight', {}, 2000);
               setTimeout(function() {
                  $(row).remove();
               }, 500);
               // Update database
               $.ajax({
                  datatype : 'json',
                  url      : 'char_talente.php',
                  type     : 'post',
                  data     : { stage : 'remove', id : id },
               });
            }
         })
      }
      function ct_change(img, value) {
         // Fetch id from parent img > td > tr
         var dummy = $(img).parent().parent().prop('id');
         dummy = dummy.split('-');
         var id = dummy[1];
         // Fetch value from parent img > td
         var current = parseInt($(img).parent().prev().text());
         var new_value = current + value;
         // Set new value
         $(img).parent().prev().text(new_value);
         // Update database
         $.ajax({
            datatype : 'json',
            url      : 'char_talente.php',
            type     : 'post',
            data     : { stage : 'update_ct', id : id, value : new_value },
            success  : do_update_ct,
         });
      }
      function do_update_ct(data) {
         data = extract_json(data);
         if (! data.success) {
            alertify.alert('An error occurred, reload the page for the actual values');
         }
      }
      function edit_note(span) {
         // Fetch id from parent span > td > tr
         var dummy= $(span).parent().parent().prop('id');
         dummy = dummy.split('-');
         var id = dummy[1];
         $('#popup').width('auto').height('auto').css('max-width', '').text('Fetching note').center().show();
         $('#popup').load('char_talente.php', { stage : 'show-note', id : id }, function(response, status, xhr) {
            $('#popup').center();
            $('#popup #note').select().focus();
            $('#frm_note').validate({
               rules : {
                  note : { maxlength : 1024 },
               },
               submitHandler : function(form) {
                  $('#popup').hide();
                  $(form).ajaxSubmit({
                     datatype : 'json',
                     url      : 'char_talente.php',
                     type     : 'post',
                     success  : do_edit_note,
                  });
               }
            });
         });
      }
      function do_edit_note(data) {
         data = extract_json(data);
         if (data.success) {
            // Set note in td in row
            $('tr#ct-' + data.id).children('#note').text(data.note).effect('highlight', {}, 2000);
         }
      }
      function roll_talent(td) {
         // Get TD with values
         var values = $(td).parent().children('#values').text().split(' - ');
         // Get talent_id from div td > tr > tbody > table
         var dummy = $(td).parent().parent().parent().prop('id');
         dummy = dummy.split('-');
         var talent_id = dummy[1];
         // Get div with talent, from there span with abbreviations
         var abbr = $('div#talent-' + talent_id + ' > h4 > span').text().trim();
         // Remove '(' and ')'
         abbr = abbr.substring(1, abbr.length - 1);
         abbr = abbr.split(' - ');
         var msg = "You rolled:<br>";
         var success = true;
         $.each(values, function(index, value) {
            value = parseInt(value.trim());
            var roll = Math.floor(Math.random() * 20 + 1);
            msg = msg + '<b>' + abbr[index] + '</b>: ' + roll;
            if (roll > value) { success = false; }
            msg = msg + ' (' + (value - roll) + ')<br>';
         });
         if (success) {
            alertify.success(msg);
         } else {
            alertify.error(msg);
         }
      }
      //-->
   </script>
{/block}

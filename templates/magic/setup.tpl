{extends file='base.tpl'}
{block name='title'}DSA - Magic setup{/block}
{block name="menu_left"}{include file="magic/divs/menu-left.tpl" selected='setup'}{/block}
{block name='main'}
   <h3 onclick='toggle(this)'>Quellen</h3>
   <div id='quellen' style='display: none; max-width: 800px'></div>
   <h3 onclick='toggle(this)'>Instruktionen</h3>
   <div id='instruktionen' style='display: none; max-width: 800px'></div>
{/block}
{block name='javascript'}
   <script type="text/javascript">
      <!--
      jQuery.fn.center = function () {
          this.css("position","absolute");
          this.css("top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) +
                                                      $(window).scrollTop()) + "px");
          this.css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) +
                                                      $(window).scrollLeft()) + "px");
          return this;
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
      function htmlescape(s) {
         return $('<div />').text(s).html();
      }
      function toggle(h3) {
         // Fetch id from text
         var id = $(h3).text().toLowerCase();
         var div = $('div#' + id);
         if ($(div).is(':visible')) {
            $(div).hide();
            return;
         }
         if ($(div).html()) {
            $(div).show();
         } else {
            $(div).load('magic_setup.php', { stage : 'show_div', div : id }, function(response, status, xhr) {
               if (status != 'success') {
                  alertify.alert('Error: ' + status + ' occurred');
                  return;
               }
               $(div).show();
            });
         }
      }
      function add_quelle() {
         show_quelle('');
      }
      function show_quelle(span) {
         var id = 0
         if (span != '') {
            // Fetch id from parent span > td > tr
            id = $(span).parent().parent().prop('id').split('-')[1];
         }
         $('#popup').text('Retrieving form').width('auto').height('auto').css('max-width', '').show().center();
         $('#popup').load('magic_setup.php', { stage : 'form-quelle', id : id }, function(response, status, xhr) {
            if (status != 'success') {
               alertify.alert('An unknown error occurred');
               return;
            }
            $('#popup').center();
            $('#form-quelle > #name').focus().select();
            $('#form-quelle').validate({
               rules : {
                  name : { required : true, maxlength : 64 },
                  desc : { maxlength : 4096 },
               },
               submitHandler : function(form) {
                  $(form).ajaxSubmit({
                     datatype : 'json',
                     url      : 'magic_setup.php',
                     type     : 'post',
                     success  : update_quelle,
                  });
                  $('#popup').hide();
               }
            });
         });
      }
      function update_quelle(data) {
         data = extract_json(data);
         if (data.success) {
            if (data.is_new) {
               // Add row
               var row = '<tr id="quelle-' + data.id + '">' +
                  '<td>' + htmlescape(data.name) + '</td>' +
                  '<td><span class="link-info" onclick="note_quelle(this)">description</span> ' +
                  '| <span class="link-edit" onclick="show_quelle(this)">edit</span> ' +
                  '| <span class="link-cancel" onclick="remove_quelle(this)">remove</span>' +
                  '</td></tr>';
               last = $('#tbl_quellen > tbody > tr:last');
               $(last).before(row);
               $(last).prev().effect('highlight', {}, 2000);
            } else {
               var td = $('#quelle-' + data.id + ' > td:first');
               $(td).text(data.name);
               $(td).parent().effect('highlight', {}, 2000);
            }
         }
      }
      function remove_quelle(span) {
         // Fetch id from parent span > td > tr
         var id = $(span).parent().parent().prop('id').split('-')[1];
         // Fetch name
         var name = $('#quelle-' + id + ' > td:first').text();
         alertify.confirm('Remove ' + name + '?', function(e) {
            if (e) {
               $.ajax({
                  datatype : 'json',
                  url      : 'magic_setup.php',
                  type     : 'post',
                  data     : { stage : 'remove', id : id },
                  success  : do_remove_quelle
               });
            }
         });
      }
      function do_remove_quelle(data) {
         data = extract_json(data);
         if (data.success) {
            var tr = $('#quelle-' + data.id);
            $(tr).effect('highlight', {}, 2000);
            setTimeout(function() {
               $(tr).remove()
            }, 500);
         }
      }
      function note_quelle(span) {
         // Fetch id from parent span > td > tr
         var id = $(span).parent().parent().prop('id').split('-')[1];
         $('#popup').text('Retrieving description').width('auto').height('auto').css('max-width', '500').show().center();
         $('#popup').load('magic_setup.php', { stage : 'note-quelle', id : id }, function(response, status, xhr) {
            if (status != 'success') {
               alertify.alert('An unknown error occurred');
               return;
            }
            $('#popup').center();
         });
      }
      //-->
   </script>
{/block}

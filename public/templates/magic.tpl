{extends file='layouts/magic.tpl'}
{block name='title'}Magic{/block}
{block name='main'}
   {section i $characters}
      <h3 onclick="show_character({$characters[i].id})">{$characters[i].name|escape}</h3>
      <div id="char-{$characters[i].id}" class="maxed" style="display: none"></div>
   {/section}
{/block}

{block name='javascript'}
   <script type="text/javascript">
      <!--
      $('body').css('background-image', 'url(/images/bg-magicchars.png)');
      jQuery.fn.center = function () {
          this.css("position","absolute");
          this.css("top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) +
                                                      $(window).scrollTop()) + "px");
          this.css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) +
                                                      $(window).scrollLeft()) + "px");
          return this;
      }
      $.validator.addMethod('skt', function(value, element, parameter) {
         var v = value.toUpperCase();
         if (v != 'A' && v != 'B' && v != 'C' && v != 'D' && v != 'E' && v != 'F' && v != 'G' && v != 'H' && v != '') {
            v = false;
         } else {
            v = true;
         }
         return this.optional(element) || v;
      }, 'Invalid SKT');
      $.validator.addMethod('num', function(value, element, parameter) {
         return this.optional(element) || parseInt(value) == value;
      }, 'Value must be an integer');
      $.validator.addMethod('notempty', function(value, element, parameter) {
         var v = parseInt(value) || 0;
         return this.optional(element) || v > 0;
      }, 'Select an option');
      function extract_json(data) {
         try {
            data = $.parseJSON(data);
         } catch(e) {
            alertify.alert(e + "\nData: " + data.toSource());
            return false;
         }
         if (! data.success && data.message) {
            alertify.alert('Error: ' + data.message);
            if ( data.show_popup ) {
               $('#popup').show();
            }
         }
         return data;
      }
      function htmlescape(s) {
         return $('<div />').text(s).html();
      }
      function show_character(id) {
         var div = '#char-' + id;
         if ($(div).is(':visible')) {
            $(div).hide();
            return;
         }
         if (true || ! $(div).html()) {
            $(div).text('Retrieving information about character');
            $(div).load('magic.php', { stage : 'show_character', id : id }, function(response, status, xhr) {
               if (status != 'success') {
                  $(div).text('');
                  alertify.alert('An unknown error occurred');
               }
            });
         }
         $(div).show();
      }
      function fetch_edit_form(url, success) {
         $('#popup').text('Retrieving form').width('auto').height('auto').css('max-width', '500').show().center();
         $('#popup').load(url , function(response, status, xhr) {
            if (status != 'success') {
               alertify.alert('An unknown error occurred');
               return;
            }
            $('#frm-charmagic').validate({
               rules : {
                  quelle : { notempty : true },
                  tradition : { notempty : true },
                  beschworung : { notempty : true },
                  skt : { required : true, skt : true },
                  value : { required : true, num : true },
               },
               submitHandler: function(form) {
                  $(form).ajaxSubmit({
                     datatype : 'json',
                     url      : url,
                     type     : 'post',
                     success  : success,
                  });
                  $('#popup').hide();
               }
            });
            $('#popup').center();
            $('#frm-charmagic #quelle').focus();
         });
      }
      function add_source(span) {
         // locate character id span > td > tr > tbody > table > div
         var id = $(span).parent().parent().parent().parent().parent().prop('id');
         id = id.split('-')[1];
         {* set variables and call function *}
         //var url = 'charmagic/create/' + id;
         var url = 'magic.php?stage=frm-charmagic&id=' + id;
         var on_success = do_add_source;
         fetch_edit_form(url, on_success);
      }
      function do_add_source(data) {
         data = extract_json(data);
         if (data.success) {
            var row = '<tr id="cm-' + data.id + '">' +
               '<td>' + htmlescape(data.quelle) + '</td>' +
               '<td>' + data.value + '</td>' +
               '<td>' + htmlescape(data.tradition) + '</td>' +
               '<td>' + htmlescape(data.beschworung) + '</td>' +
               '<td>' + htmlescape(data.wesen) + '</td>' +
               '<td>' + data.skt + '</td>' +
               '<td> <span class="link-edit" onclick="edit_source(this)">edit</span> | <span class="link-cancel" onclick="remove_source(this)">remove</span></td>' +
               '</tr>';
            var last = $('div#char-' + data.character_id + ' tbody > tr:last');
            $(last).before(row);
            $(last).prev().effect('highlight', {}, 2000);
         }
      }
      function edit_source(span) {
         {* Get id from parent: span > td > tr *}
         var id = $(span).parent().parent().prop('id');
         id = id.split('-')[1];
         {* set variables and call function *}
         var url = 'charmagic/edit/' + id;
         var on_success = do_edit_source;
         fetch_edit_form(url, on_success);
      }
      function remove_source(span) {
         // Get tr: span > td > tr
         var row = $(span).parent().parent();
         var id = $(row).prop('id');
         id = id.split('-')[1];
         var name = $(row).children('td:first-child').text();
         alertify.confirm('Remove ' + name + '?', function(e) {
            if (e) {
               $.ajax({
                  datatype : 'json',
                  url      : 'charmagic/remove/' + id,
                  type     : 'post',
                  data     : { _method : 'DELETE' },
                  success  : do_remove_source
               });
            }
         });
      }
      function do_remove_source(data) {
         data = extract_json(data);
         if (data.id) {
            $('#cm-' + data.id).effect('highlight', {}, 2000);
            setTimeout(function() {
               $('#cm-' + data.id).remove();
            }, 500);
         }
      }
      function do_edit_source(data) {
         data = extract_json(data);
         if (data.success) {
            var tr = '#cm-' + data.id;
            $(tr + ' td:nth-child(1)').text(data.quelle);
            $(tr + ' td:nth-child(2)').text(data.value);
            $(tr + ' td:nth-child(3)').text(data.tradition);
            $(tr + ' td:nth-child(4)').text(data.beschworung);
            $(tr + ' td:nth-child(5)').text(data.wesen);
            $(tr + ' td:nth-child(6)').text(data.skt);
            $(tr).effect('highlight', {}, 2000);
         }
      }
      function add_instruktion(span) {
         {* Retrieve id: span > div > div *}
         var id = $(span).parent().parent().prop('id');
         id = id.split('-')[1];
         $('#popup').text('Retrieving form').width('auto').height('auto').css('max-width', '500').show().center();
         $('#popup').load('/magic/instruktion/' + id, function(response, status, xhr) {
            if (status != 'success') {
               alertify.alert('An unknown error occurred');
               $('#popup').hide();
            } else {
               $('#frm-instruktion').validate({
                  rules : {
                     instruktion : { required : true },
                  },
                  submitHandler: function(form) {
                     $(form).ajaxSubmit({
                        datatype : 'json',
                        url      : '/magic/instruktion/' + id,
                        type     : 'post',
                        success  : do_add_instruktion,
                     });
                     $('#popup').hide();
                  }
               });
               $('#popup').center();
               $('#frm-charmagic #quelle').focus();

            }
         });
      }
      function do_add_instruktion(data) {
         data = extract_json(data);
         if (data.success) {
            var ul = '#char-' + data.character_id + ' ul';
            var li = '<li id="' + data.instruktion_id + '">' + htmlescape(data.name) + '</li>';
            $(ul).append(li);
            $(ul + ' li#' + data.instruktion_id).effect('highlight', {}, 2000);
         }
      }
      function remove_instruktion(li) {
         var id = $(li).prop('id');
         var name = $(li).text();
         alertify.confirm('Remove ' + name + '?', function(e) {
            if (e) {
               $.ajax({
                  datatype : 'json',
                  url      : '/magic/instruktion/' + id,
                  type     : 'post',
                  data     : { _method : 'DELETE' },
                  success  : do_remove_instruktion,
               });
            }
         })
      }
      function do_remove_instruktion(data) {
         data = extract_json(data);
         if (data.success) {
            var li = 'div[id^=char] ul li#' + data.id;
            $(li).effect('highlight', {}, 2000);
            setTimeout(function() {
               $(li).remove();
            }, 500);
         }
      }
      //-->
   </script>
{/block}
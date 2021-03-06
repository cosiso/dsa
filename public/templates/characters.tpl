{extends file='base.tpl'}
{block name='title'}DSA - Characters{/block}
{block name='menu_left'}{include file='character_menu.tpl' selected='main'}{/block}
{block name='main'}
   <div onclick="close_all_divs()" style="cursor: pointer">
      <img src="images/badge-square-direction-up-24.png" border="0" width="24" height="24" />
      Close all
   </div>
   <h3 class="toggle" onclick="toggle_base()">Basiswerte &amp; Eigenschafte</h3>
   <div id="basiswerte" class="maxed" style="display: none"></div>
   <h3 class="toggle" onclick="toggle_vorteile()">Vor- &amp; Nachteile</h3>
   <div id="vor_nach_teile" class="maxed" style="display: none"></div>
   <h3 class="toggle" onclick="toggle_kampftechniken()">Kampftechniken</h3>
   <div id="kampftechniken" class="maxed" style="display: none"></div>
   {section name=idx loop=$chars}
      <h3 id="{$chars[idx].id}" class="toggle" onclick="toggle({$chars[idx].id})">{$chars[idx].name|escape}</h3>
      <div id="char_{$chars[idx].id}" style="display: none; padding-left: 20px"></div>
   {/section}
{/block}
{block name='javascript'}
   <script type="text/javascript">
      <!--
      $(document).ready(function() {
         // Add validation method
         $.validator.addMethod('num', function(value, element, parameter) {
            return this.optional(element) || parseInt(value) == value;
         }, 'Value must be an integer');
         toggle_base();
      });
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
      function close_all_divs() {
         $('h3 + div').hide();
      }
      function toggle_base() {
         var elem = 'div#basiswerte';
         if ($(elem).is(':visible')) {
            // close and return
            $(elem).hide();
            return;
         }
         if (! $(elem).html()) {
            $(elem).text('Retrieving data, please wait.');
            $.ajax({
               datatype : 'json',
               url      : 'characters.php',
               type     : 'post',
               data     : { stage : 'retrieve_base'},
               success  : show_basevalues
            });
         }
         $(elem).slideDown();
      }
      function show_basevalues(data) {
         data = extract_json(data);
         if (data.success) {
            $('div#basiswerte').html(data.out);
         }
      }
      function roll(span, eigenschaft) {
         var value = parseInt($(span).parent().text()) || 0;
         var name = $(span).parent().parent().children().first().text();
         var d20 = Math.floor(Math.random() * 20 + 1);
         var out = name + ' rolled <b>' + d20 + '</b>';
         if (d20 > value || d20 == 20) {
            alertify.error(out + ' on ' + eigenschaft);
         } else {
            value = value - d20;
            alertify.success(out + ' (+' + value + ') on ' + eigenschaft);
         }
      }
      function rename(span) {
         // Get id from parent_row span > td > tr
         var id = $(span).parent().parent().prop('id');
         $('#popup').html('Retrieving name');
         $.ajax({
            datatype : 'json',
            url      : 'characters.php',
            type     : 'get',
            data     : { stage : 'get_name', id : id },
            success  : show_rename
         });
         $('#popup').width(250).height(80).css('max-width', '');
         $('#popup').show();
         $('#popup').position({
            my        : 'left top',
            at        : 'left top',
            of        : $(span),
            collision : 'none',
         });
      }
      function show_rename(data) {
         data = extract_json(data);
         if (data.success) {
            $('#popup').html(data.out);
            $('#popup #name').focus().select();
            $('#popup form#rename').validate({
               rules : {
                  name : 'required',
               },
               submitHandler : function(form) {
                  $('#popup').hide();
                  $.ajax({
                     datatype : 'json',
                     url      : 'characters.php',
                     type     : 'post',
                     data     : { stage : 'set_name',
                                  id    : $('form#rename #id').val(),
                                  name  : $('form#rename #name').val()},
                     success  : do_rename
                  })
               }
            })
         }
      }
      function do_rename(data) {
         data = extract_json(data);
         if (data.success) {
            $('table#basiswerte span#name-' + data.id).text(data.name);
            $('table#basiswerte span#name-' + data.id).effect('highlight', {}, 2000);
         }
      }
      function edit_basiswert(span, basiswert) {
         // Retrieve id from parent row span > td > tr
         var id = $(span).parent().parent().prop('id');
         $('#popup').html('Retrieving values for ' + basiswert);
         $('#popup').load('characters.php',
                          { stage : 'get_eigenschaft', eigenschaft : basiswert, id : id},
                          basiswert_loaded
         );
         $('#popup').width(250).height(175).css('max-width', '');
         $('#popup').show();
         $('#popup').position({
            collision : 'none',
            my        : 'left top',
            at        : 'left top',
            of        : $(span),
         });
      }
      function basiswert_loaded(response, status, xhr) {
         if (status == 'success') {
            $('form#edit_eigenschaft #modifier').focus().select();
            $('form#edit_eigenschaft').validate({
               rules : {
                  modifier : { num : true },
                  bought   : { digits : true },
               },
               submitHandler : function(form) {
                  $('#popup').hide();
                  $(form).ajaxSubmit({
                     datatype : 'json',
                     url      : 'characters.php',
                     type     : 'post',
                     success  : do_change_basiswert,
                  });
               }
            })
         } else {
            alertify.alert('An error occured');
            $('#popup').hide();
         }
      }
      function do_change_basiswert(data) {
         data = extract_json(data);
         if (data.success) {
            // Update field
            var field = '#' + data.eigenschaft + '-' + data.id;
            $(field).text(data.value);
            $(field).effect('highlight', {} , 2000);
         }
      }
      function ask_new_character() {
         $('#popup').center();
         $('#popup').html('Retrieving form');
         $('#popup').load('characters.php',
                          { stage : 'show_new_char' },
                          show_new_character
         );
         $('#popup').width(250).height(175).css('max-width', '');
         $('#popup').show();
         return false;
      }
      function show_new_character() {
         $('form#new_char #name').focus().select();
         $('form#new_char').validate({
            rules : {
               name : { required : true },
            },
            submitHandler: function(form) {
               $('#popup').hide();
               form.submit();
            }
         });
      }
      function remove_char(lnk) {
         // Get id from parent link > td > tr
         var id = $(lnk).parent().parent().prop('id');
         // Get name
         var name = $('#name-' + id).text();
         alertify.confirm('Remove ' + name + '?', function(e) {
            if (e) {
               var frm = '<div style="display: none"><form id="remove" method="post">' +
                  '<input type="hidden" name="stage" value="remove">' +
                  '<input type="hidden" name="id" value="' + id + '">' +
                  '</form></div>';
                $(frm).appendTo('body');
               $('form#remove').submit();
            }
         });
      }
      function char_edit(span) {
         // Get id from parent span > td > tr
         var id = $(span).parent().parent().prop('id');
         $('#popup').center();
         $('#popup').html('Retrieving data');
         $('#popup').width('auto').height('auto').css('max-width', '');
         $('#popup').load('characters.php',
                          { stage : 'show_char', id : id },
                          show_edit_char);
         $('#popup').show();
      }
      function show_edit_char() {
         $('#popup').center();
         $('form#edit_char #rasse').focus().select();
         $('form#edit_char').validate({
            rules : {
               grosse  : { digits : true },
               gewicht : { digits : true },
               alter   : { digits : true },
            },
            submitHandler : function(form) {
               $(form).ajaxSubmit({
                  datatype : 'json',
                  url      : 'characters.php',
                  type     : 'post',
                  success  : done_edit_char,
               });
               $('#popup').hide();
            }
         });
      }
      function done_edit_char(data) {
         data = extract_json(data);
         if (data.errormsg) {
            // Validation error, show errmsg and show form again
            $('#popup').show();
            alertify.alert(data.errmsg);
         } else if (data.success) {
            alertify.log('Character values saved');
         }
      }
      function edit_eigenschaft(span) {
         // Retrieve id from parent span > td > tr
         var id = $(span).parent().parent().prop('id');
         // Retrieve eigenschaft
         var dummy = $(span).parent().children('span').first().prop('id');
         dummy = dummy.split('-');
         var eigenschaft = dummy[0];
         $('#popup').html('Retrieving eigenschaft values');
         $('#popup').width('auto').height('auto').center().show().css('max-width', '');
         $('#popup').load('characters.php',
                          { stage : 'show_eigenschaft', id : id, eigenschaft : eigenschaft },
                          show_eigenschaft);
      }
      function show_eigenschaft() {
         $('form#eigenschaft #base').focus().select();
         $('form#eigenschaft').validate({
            rules : {
               base      : { digits : true, required : true },
               modifier  : { num : true },
               zugekauft : { digits : true },
               note      : { maxlength : 255 },
            },
            submitHandler : function(form) {
               $(form).ajaxSubmit({
                  datatype : 'json',
                  url      : 'characters.php',
                  type     : 'post',
                  success  : do_change_eigenschaft,
               });
               $('#popup').hide();
            },
         });
      }
      function do_change_eigenschaft(data) {
         data = extract_json(data);
         if (data.success) {
            // Set new value
            var span ='table#eigenschafte span#' + data.eigenschaft + '-' + data.char_id;
            $(span).text(data.total);
            $(span).effect('highlight', {}, 2000);
         }
      }
      function toggle_vorteile() {
         var elem = 'div#vor_nach_teile';
         if ($(elem).is(':visible')) {
            // close and return
            $(elem).hide();
            return;
         }
         if (! $(elem).html()) {
            $(elem).text('Retrieving data, please wait.');
            $(elem).load('char_vorteile.php', {});
         }
         $(elem).slideDown();
      }
      function toggle_kampftechniken() {
         var elem='div#kampftechniken';
         if ($(elem).is(':visible')) {
            $(elem).hide();
            return;
         }
         if (! $(elem).html() || 1) {
            $(elem).text('Retrieving data, please wait');
            $(elem).load('char_kampftechniken.php');
         }
         $(elem).slideDown();
      }
      function show_vorteil(span) {
         var id = $(span).prop('id');
         // get character from parent
         var dummy = $(span).parent().prop('id');
         dummy = dummy.split('-');
         var char_id = dummy[1];
         $('#popup').html('Retrieving information about vorteil');
         $('#popup').show();
         $('#popup').width('auto').height('auto').center().css('max-width', '500px');
         $('#popup').load('char_vorteile.php', { stage : 'info', id : id, char_id : char_id }, do_show_vorteil);
      }
      function do_show_vorteil() {
         $('#popup').center();
         $('form#edit_vorteil #value').focus().select();
         $('form#edit_vorteil').validate({
            rules : {
               value : { digits    : true },
               note  : { maxlength : 1024 },
            },
            submitHandler : function(form) {
               $(form).ajaxSubmit({
                  datatype : 'json',
                  url      : 'char_vorteile.php',
                  type     : 'post',
                  success  : do_edit_vorteil,
               });
               $('#popup').hide();
            }
         });
      }
      function do_edit_vorteil(data) {
         data = extract_json(data);
         if (data.success) {
            var v = data.name;
            if (data.value != '') {
               v = v + ' (' + data.value + ')';
            }
            var span = (data.vorteil) ? '#vorteile' : '#nachteile';
            span += '-' + data.char_id + ' span#' + data.vorteil_id;
            $(span).text(v);
            $(span).effect('highlight', {}, 2000);
         }
      }
      function remove_vorteil(cv_id) {
         // Fetch name from popup
         var name = $('#popup h4').text();
         alertify.confirm('Remove ' + name + '?', function(e) {
            if (e) {
               $('#popup').hide();
               $.ajax({
                  datatype : 'json',
                  url      : 'char_vorteile.php',
                  type     : 'post',
                  data     : { stage : 'remove', id : cv_id },
                  success  : do_remove_vorteil
               });
            }
         });
      }
      function do_remove_vorteil(data) {
         data = extract_json(data);
         if (data.success) {
            // Remove the span from both vor- and nachteile
            var t = 'vorteile';
            if (! data.vorteil) { t = 'nachteile' };
            var span = 'span#' + t + '-' + data.char_id + ' span#' + data.vorteil_id + '.vorteil';
            $(span).effect('highlight', {}, 2000);
            setTimeout(function() {
               $(span).remove();
            }, 500);
         }
      }
      function fn_add_vorteil() {
         show_add_vorteil(1);
      }
      function fn_add_nachteil() {
         show_add_vorteil(0);
      }
      function show_add_vorteil(vorteil) {
         $('#popup').html('Retrieving information');
         $('#popup').show();
         $('#popup').width('auto').height('auto').center().css('max-width', '500px');
         $('#popup').load('char_vorteile.php', { stage : 'load_vorteil', vorteil : vorteil }, do_show_add_vorteil);
      }
      function do_show_add_vorteil() {
         $('#popup').center();
         $('#popup form#add_vorteil').validate({
            rules : {
               char    : { required : true },
               vorteil : { required : true },
            },
            submitHandler : function(form) {
               $('#popup').hide();
               $(form).ajaxSubmit({
                  datatype : 'json',
                  url      : 'char_vorteile.php',
                  type     : 'post',
                  success  : do_add_vorteil,
               })
            },
         });
         return falsedd
      }
      function do_add_vorteil(data) {
         data = extract_json(data);
         if (data.success) {
            if (data.existing) {
               alertify.log('Character already had this vor-/nachteil');
               return;
            }
            var parent = 'vorteile-';
            if (! data.is_vorteil) { parent = 'nachteile-' }
            parent += data.char_id;
            var span = '<span id="' + data.vorteil_id + '" class="vorteil" onclick="show_vorteil(this)">' +
               ' - ' + htmlescape(data.name) + '</span>';
            $('#' + parent).append(span);
            $('#' + parent + ' span#' + data.vorteil_id + '.vorteil').effect('highlight', {}, 2000);
         }
      }
      function raise_kt(img, kind, value) {
         // Get parent row img > td > tr
         var tr = $(img).parent().parent();
         var ckt_id = $(tr).prop('id');
         // Get column based on "kind"
         var td = $(tr).find('#' + kind);
         var v = $(td).text();
         // Set new value
         v = parseInt(v) + parseInt(value);
         $(td).text(v);
         $.ajax({
            url  : 'char_kampftechniken.php',
            type : 'post',
            data : { stage : 'update', id : ckt_id, kind : kind, value : v },
         });
      }
      function kt_add(char_id) {
         $('#popup').width('auto').height('auto').css('max-width', '').text('Fetching kampftechniken').center().show();
         $('#popup').load('char_kampftechniken.php', { stage : 'list_techniken', id : char_id }, function(response, status, xhr) {
            if (status == 'error') {
               alertify.alert('Unknown error');
               $('#popup').hide();
               return;
            }
            $('#popup').center();
            $('#frm_kt_add').validate({
               rules : {
                  technik : { required : true, min : 1 },
               },
               submitHandler : function(form) {
                  $(form).ajaxSubmit({
                     datatype : 'json',
                     type     : 'post',
                     url      : 'char_kampftechniken.php',
                     success  : do_add_kampftechnik,
                  });
                  $('#popup').hide();
               }
            });
         });
      }
      function do_add_kampftechnik(data) {
         data = extract_json(data);
         if (data.success) {
            var name = '';
            var img_plus = '<img src="images/plus-16.png" alt="plus" border="0" style="cursor: pointer" ';
            var img_minus = '<img src="images/minus-16.png" alt="plus" border="0" style="cursor: pointer" ';
            if (data.unarmed) {
               name = '<img src="images/bullet_orange.png" alt="yes" border="0">' + htmlescape(data.name);
            } else {
               name = htmlescape(data.name)
            }
            var row = '<tr id="' + data.id + '">' +
               '<td>' + name + '</td>' +
               '<td style="text-align: right"><span id="at">0</span> ' +
               img_plus + ' onclick="raise_kt(this, \'at\', 1)"> ' +
               img_minus + ' onclick="raise_kt(this, \'at\', -1)">' +
               '</td>' +
               '<td style="text-align: right"><span id="pa">0</span> ' +
               img_plus + ' onclick="raise_kt(this, \'pa\', 1)"> ' +
               img_minus + ' onclick="raise_kt(this, \'pa\', -1)">' +
               '</td>' +
               '<td><span class="link-cancel" onclick="remove_kt(this)">remove</span></td>' +
               '</tr>';
            // Find where to prepend
            var tr = $('tr#kt_add_' + data.char_id);
            $(tr).before(row);
            $(tr).prev().effect('highlight', {}, 2000);
         }
      }
      function remove_kt(span) {
         // Get kampftechnik from parent span > td > tr (and down to td)
         var tr = $(span).parent().parent();
         var ckt_id = $(tr).prop('id');
         var technik = $(tr).children(':first-child').text();
         alertify.confirm('Remove ' + technik + '?', function(e) {
            if (e) {
               $.ajax({
                  datatype : 'json',
                  url      : 'char_kampftechniken.php',
                  type     : 'post',
                  data     : { stage : 'remove', id : ckt_id },
                  success  : do_remove_kt,
               })
            }
         });
      }
      function do_remove_kt(data) {
         data = extract_json(data);
         if (data.success) {
            // Find row
            var tr = $('div#kampftechniken').find('tr#' + data.id);
            $(tr).effect('highlight', {}, 2000);
            setTimeout(function() {
               $(tr).remove();
            }, 500);
         }
      }
      //-->
   </script>
{/block}

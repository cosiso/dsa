{extends file='base.tpl'}
{block name='title'}DSA - Characters{/block}
{block name='menu_left'}{include file='character_menu.tpl' selected='main'}{/block}
{block name='main'}
   <div onclick="close_all_divs()" style="cursor: pointer">
      <img src="images/badge-square-direction-up-24.png" border="0" width="24" height="24" />
      Close all
   </div>
   <h3 class="toggle" onclick="toggle_base()">Basiswerte &amp; Eigenschafte</h3>
   <div id="basiswerte" style="display: none; padding-left: 20px"></div>
   {section name=idx loop=$chars}
      <h3 id="{$chars[idx].id}" class="toggle" onclick="toggle({$chars[idx].id})">{$chars[idx].name|escape}</h3>
      <div id="char_{$chars[idx].id}" style="display: none; padding-left: 20px"></div>
   {/section}
{/block}
{block name='javascript'}
   <script type="text/javascript">
      <!--
      $(document).ready(function() {
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
      function toggle_base() {
         var elem = 'div#basiswerte';
         if ($(elem).is(':visible')) {
            // close and return
            $(elem).hide();
            return;
         }
         if (! $(elem).html() || 1) {
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
         $('#popup').width(250).height(80);
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
      function edit_eigenschaft(span, eigenschaft) {
         // Retrieve id from parent row span > td > tr
         var id = $(span).parent().parent().prop('id');
         $('#popup').html('Retrieving values for ' + eigenschaft);
         $('#popup').load('characters.php',
                          { stage : 'get_eigenschaft', eigenschaft : eigenschaft, id : id},
                          eigenschaft_loaded
         );
         $('#popup').width(250).height(175);
         $('#popup').show();
         $('#popup').position({
            collision : 'none',
            my        : 'left top',
            at        : 'left top',
            of        : $(span),
         });
      }
      function eigenschaft_loaded(response, status, xhr) {
         if (status == 'success') {
            $('form#edit_eigenschaft #modifier').focus().select();
            $('form#edit_eigenschaft').validate({
               rules : {
                  modifier : { digits : true },
                  bought   : { digits : true },
               },
               submitHandler : function(form) {
                  $('#popup').hide();
                  $(form).ajaxSubmit({
                     datatype : 'json',
                     url      : 'characters.php',
                     type     : 'post',
                     success  : do_change_eigenschaft,
                  });
               }
            })
         } else {
            alertify.alert('An error occured');
            $('#popup').hide();
         }
      }
      function do_change_eigenschaft(data) {
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
         $('#popup').width(250).height(175);
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
         $('#popup').width('auto').height('auto');
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
      /*
      function toggle(char_id) {
         var elem = $('h3#' + char_id ).next('div#char_' + char_id);
         var isVisible = $(elem).is(':visible');
         if (isVisible) {
            // close and return
            $(elem).hide();
            return;
         }
         if (! hasData[char_id]) {
            // Retriev data
            $(elem).text('Retrieving data, please wait.');
            $.ajax({
               datatype : 'json',
               url      : 'characters.php',
               type     : 'post',
               data     : { id : char_id, stage : 'retrieve'},
               success  : show_char
            });
         }
         $(elem).slideDown();
      }
      function show_char(data) {
         data = extract_json(data);
         if (data.success) {
            var elem = $('h3#' + data.id).next('div#char_' + data.id);
            $(elem).html(data.out);
         }
      }
      */
      //-->
   </script>
{/block}

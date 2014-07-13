<!DOCTYPE html>
<html>
<head>
   {include file='part_head.tpl' title='DSA - Characters'}
</head>
<body>
   {include file='head.tpl'}
   {include file='character_menu.tpl' selected='main'}
   <div id="main" style="float: left">
      <div onclick="close_all_divs()" style="cursor: pointer">
         <img src="images/badge-square-direction-up-24.png" border="0" width="24" height="24" />
         Close all
      </div>
      <h3 class="toggle" onclick="toggle_base()">Basiswerte &amp; Eigenschafte</h3>
      <div id="basiswerte" style="display: none; padding-left: 20px"></div>
      {section name=idx loop=$chars}
         <h3 id="{$chars[idx].id}" class="toggle" onclick="toggle({$chars[idx].id})">{$chars[idx].name|escape}</h3>
         <div id="char_{$chars[idx].id}" style="display: none; padding-left: 20px"></div>
      {sectionelse}
         <script type="text/javascript">
            alert('No characters defined yet');
         </script>
      {/section}
   </div>
   <div id="popup" style="display: none"></div>
   {include file='part_script_include.tpl'}
   <script type="text/javascript">
      <!--
      var hasData = {};
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
         console.log('ID: ' + id);
         $('#popup').html('Retrieving values for ' + eigenschaft);
         $('#popup').load('characters.php',
                          { stage : 'get_eigenschaft', eigenschaft : eigenschaft, id : id},
                          eigenschaft_loaded
         );
         $('#popup').width(250).height(250);
         $('#popup').show();
         $('#popup').position({
            collision : 'none',
            my        : 'left top',
            at        : 'left top',
            of        : $(span),
         });
      }
      function eigenschaft_loaded(response, status, xhr) {
         alertify.aleret('Loaded, success: ' + status.toSource());
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
</body>
</html>
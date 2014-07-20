{extends file='base.tpl'}
{block name='title'}DSA - Combat{/block}
{block name='menu_left'}{include file='character_menu.tpl' selected='combat'}{/block}
{block name='main'}
   <div id="div" style="float: left">
      <div id="main" style="max-width: 800px">
         <div onclick="close_all_divs()" style="cursor: pointer">
            <img src="images/badge-square-direction-up-24.png" border="0" width="24" height="24" />
            Close all
         </div>
         {section name=idx loop=$chars}
            <h3 id="h3_{$chars[idx].id}" class="toggle" onclick="toggle({$chars[idx].id})">{$chars[idx].name|escape}</h3>
            <div id="char_{$chars[idx].id}" style="display: none; padding-left: 20px"></div>
         {sectionelse}
            <script type="text/javascript">
               alert('No characters defined yet');
            </script>
         {/section}
      </div>
   </div>
   <div id="popup" style="display: none"></div>
{/block}
{block name='javascript'}
   {include file='divs/valuebar/value-bar.js.tpl'}
   <script type="text/javascript">
      <!--
      var hasData = {};
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
         $('#main h3 + div[id^=char_]').slideUp();
      }
      function toggle(char_id) {
         var div='#main div#char_' + char_id;
         var isVisible = $(div).is(':visible');
         if (! hasData[char_id] && ! isVisible) {
            alertify.log('Retrieving data for ' + $('#main #h3_' + char_id).text());
            $.ajax({
               datatype : 'json',
               type     : 'post',
               url      : 'combat.php',
               data     : { stage : 'get_char',
                            id    : char_id },
               success  : do_show_char,
            });
         } else {
            // Toggle div
            $(div).toggle();
         }
      }
      function do_show_char(data) {
         data = extract_json(data);
         if (data.success) {
            var div='#main div#char_' + data.id;
            $(div).html(data.out);
            $(div).slideDown();
            hasData[data.id] = true;
            $(div + ' #value-bar').load('value-bar.php', { id: data.id });
         }
      }
      function rollIni(td_elem) {
         var ini = parseInt($(td_elem).text().trim()) || 0;
         ini += Math.floor(Math.random() * 6 + 1);
         var name = $(td_elem).closest('div').prev().text();
         var log = name + ' rolled initiative <b>' + ini + '</b> on ' +
                   $(td_elem).parent().children('td').eq(0).text();
         alertify.log(log);
      }
      function rollATorPA(td_elem, at) {
         var typ = (at) ? 'attack' : 'parry';
         var sk = parseInt($(td_elem).text().trim()) || 0;
         var roll = Math.floor(Math.random() * 20 + 1);
         var name = $(td_elem).closest('div').prev().text();
         var skill = $(td_elem).parent().children('td').eq(0).text();
         if (roll > sk || roll == 20) {
            alertify.error(name + ' rolled <b> ' + roll + '</b> and failed a ' + skill + ' ' + typ);
         } else {
            alertify.success(name + ' rolled ' + roll + '(<b>+' + (sk - roll) + '</b>) on ' + skill + ' ' + typ);
         }
      }
      function rollTP(td_elem) {
         var description = $(td_elem).text().trim();
         var split = description.split('+');
         var dice = split[0];
         var addition = parseInt(split[1]) || 0;
         split = dice.split('D');
         var multiplier = parseInt(split[0]) || 1;
         dice = parseInt(split[1]) || 0;
         var roll = Math.floor(Math.random() * dice + 1);
         var total = roll * multiplier + addition;
         var name = $(td_elem).closest('div').prev().text();
         var skill = $(td_elem).parent().children('td').eq(0).text();
         alertify.log(name + ' rolled <b>' + total + '</b> damage on ' + skill);
      }
      function sf_info(sf_id) {
         $('#popup').width(400).height(200).html('Please wait, loading content').center();
         $('#popup').load('combat.php',
                          { stage : 'sf_note', sf_id : sf_id },
                          function(response, status, xhr) {
            if (status == 'error') {
               alertify.alert('Error loading note for kampfsonderfertigkeit');
            } else {
               $('#popup').slideDown();
            }
         });
      }
      function sf_remove(sf_id) {
         // Fetch name
         var row=$('table#sf tr#' + sf_id);
         // First td is name
         var name=$(row).children().first().text();
         alertify.confirm('Remove kampfsonderfertigfkeit ' + name + '?', function (e) {
            if (e) {
               $.ajax({
                  datatype : 'json',
                  url      : 'combat.php',
                  type     : 'post',
                  success  : do_remove_sf,
                  data     : { stage : 'remove_sf',
                               id    : sf_id },
               });
            }
         });
         return false;
      }
      function do_remove_sf(data) {
         data = extract_json(data);
         if (data.success) {
            var row = $('table#sf tr#' + data.id);
            $(row).effect('highlight', {}, 2000);
            setTimeout(function() {
               $(row).remove();
            }, 500);
         }
      }
      function add_sf(char_id) {
         $('#popup').width('auto').height('auto');
         $('#popup').text('Please wait, loading content').show();
         $('#popup').center();
         $('#popup').load('combat.php',
                          { stage : 'load_sf', char_id : char_id },
                          function(response, status, xhr) {
            if (status == 'error') {
               alertify.alert('Error loading kampfsonderfertigkeiten');
               $('#popup').toggle();
            } else {
               $('form#p_add_sf').validate({
                  rules : {
                     p_sf : { required : true, min : 1 },
                  },
                  submitHandler : function(form) {
                     $(form).ajaxSubmit({
                        url      : 'combat.php',
                        type     : 'post',
                        datatype : 'json',
                        success  : do_add_sf,
                     });
                     $('#popup').hide();
                     return false;
                  }
               });
            }
         });
         $('#popup').slideDown();
      }
      function do_add_sf(data) {
         data = extract_json(data);
         if (data.success) {
            var elem = '<tr id="' + data.id + '">' +
                       '<td>' + htmlescape(data.name) + '</td>' +
                       '<td>' + htmlescape(data.effect) + '</td>' +
                       '<td><a href="#" onclick="sf_info(' + data.sf_id + ')" class="link-info">note</a>' +
                       ' | <a href="#" onclick="sf_remove(' + data.id + ')" class="link-cancel">remove</a>' +
                       '</td></tr>';
            $('div#char_' + data.char_id + ' table#sf tbody').append(elem);
            $('table#sf tr#' + data.id).effect('highlight', {}, 2000);
         }
      }
      function reload_char(id) {
         // Unset hasData
         hasData[id] = false;
         // Hide div
         $('#main div#char_' + id).hide();
         // Toggle div
         toggle(id);
      }
      //-->
   </script>
{/block}

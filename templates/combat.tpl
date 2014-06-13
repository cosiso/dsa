<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
      "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
   {include file=part_head.tpl title='DSA - Combat'}
</head>
<body>
   {include file=head.tpl}
   {include file=character_menu.tpl selected='combat'}
   <div id="div" style="float: left">
      <div id="main">
         <div onclick="close_all_divs()" style="cursor: pointer">
            <img src="images/badge-square-direction-up-24.png" border="0" width="24" height="24" />
            Close all
         </div>
         {section name=idx loop=$chars}
            <h3 id="h3_{$chars[idx].id}" class="toggle" onclick="toggle({$chars[idx].id})">{$chars[idx].name|escape}</h3>
            <div id="char_{$chars[idx].id}" style="display: none;">Iets</div>
         {sectionelse}
            <script type="text/javascript">
               alert('No characters defined yet');
            </script>
         {/section}
      </div>
   </div>
   {include file=part_script_include.tpl}
   <script type="text/javascript">
      <!--{literal}
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
               data     : {stage : 'get_char',
                           id    : char_id},
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
      //-->{/literal}
   </script>
</body>
</html>
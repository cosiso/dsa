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
      <script type="text/javascript">
         <!--
         var traits = [
         {section name=idx loop=$traits}
               {ldelim}
                  id   : {$traits[idx].id},
                  name: "{$traits[idx].name}",
                  abbr: "{$traits[idx].abbr}"
               {rdelim}
               {if ! $smarty.section.idx.last},{/if}
         {/section}
         ]{literal}
         $().ready(function() {
            // Set classes on default tab
            $('#default-tab a').addClass('tab-inactive').addClass('tab-active');
            // Fill in selects on form
            $('#frm_talente select[id^="eigenschaft"]').append('<option value="0">-- Not selected</option>');
            traits = traits.sort(function(a, b) {
               name_a = a.name;
               name_b = b.name;
               return name_a.localeCompare(name_b);
               var w = name_a.localeCompare(name_b);
               if (w < 0) {
                  alert(a + ' comes before ' + b);
               } else if (w == 0) {
                  alert(a + ' is actually equal to ' + b);
               } else {
                  alert(a + ' should be after ' + b);
               }
               return w;
            });
            for (var key in traits) {
               $('#frm_talente select[id^="eigenschaft"]').append('<option value="' + traits[key].id + '">' + traits[key].name + '</option>');
            }
         });
         //-->{/literal}
      </script>
      {include file="head.tpl"}
      {include file="setup_menu.tpl" selected_category="Talenten"}
      <div style="float: left" id="tab-container">
         <ul class="tabs">
            <li id="default-tab"><a href="#tabs-talente">{$category_name|escape|replace:' ':'&nbsp;'}</a></li>
         </ul>
         <div id="tabs-talente">
            <br />
            <table id="talente">
               <thead>
                  <tr>
                     <th>Name</th>
                     <th>Eigenschaften</th>
                     <th>SKT</th>
                     <th>BE</th>
                     <th>Komp</th>
                     <th>&nbsp;</th>
                  </tr>
               </thead>
               <tbody>
                  {section name=idx loop=$talente}
                     <tr>
                        <td>{$talente[idx].name|escape}</td>
                        <td>{$talente[idx].eigenschaft1|escape} - {$talente[idx].eigenschaft2|escape} - {$talente[idx].eigenschaft3|escape}</td>
                        <td>{$talente[idx].skt|escape}</td>
                        <td>{$talente[idx].be|escape}</td>
                        <td>{$talente[idx].komp|escape}</td>
                        <td>
                           <a href="javascript:edit_talent({$talente[idx].id})" class="link-edit">edit</a>
                           | <a href="javascript:remove_talent({$talente[idx].id})" class="link-cancel">remove</a>
                        </td>
                     </tr>
                  {/section}
               </tbody>
            </table>
            <br />
            {carto_spacer width='200px'}
            {carto_button name='btn_add_talent' value='Add talent' onclick='add_talent()'}
         </div>
      </div>
      <div id="add_talent" class="popup" style="display: none; height: 380px">
         <form name="frm_talente" id="frm_talente" onsubmit="submit_talente()">
            {html_hidden name='talent_id' value=0}
            <label>Name:</label>
            {html_text name='name' style='width: 10em'}<br />
            <label>Eigenschaft 1</label>
            <select name="eigenschaft1" id="eigenschaft1"></select>
            <label>Eigenschaft 2</label>
            <select name="eigenschaft2" id="eigenschaft2"></select>
            <label>Eigenschaft 3</label>
            <select name="eigenschaft3" id="eigenschaft3"></select>
            <label>SKT</label>
            {html_text name='skt' style='width: 2em'}
            <label>BE</label>
            {html_text name='be' style='width 5em'}
            <label>Komp.</label>
            {html_text name='komp' style='width: 5em'}
            <div class="button_bar">
               {carto_button type='submit'}
               {carto_button type='close' onclick="$('#add_talent').slideUp()"}
            </div>
         </form>
      </div>
      <script type="text/javascript">
         <!--{literal}
         function fill_talente_form(id, name, eig1, eig2, eig3, skt, be, komp ) {
            $('#talente_id').text(id);
            $('#name').text(name);
            $('#skt').text(skt);
            $('#be').text(be);
            $('#komp').text(komp);
            $('#eigenschaft1').val(eig1);
            $('#eigenschaft2').val(eig2);
            $('#eigenschaft3').val(eig3);
         }
         function show_add_talente(aligned) {
            // Position add_talent div
            var div = $('#add_talent');
            var pos = aligned.position();
            div.css({top:  pos.top + 30,
                     left: pos.left + aligned.width() - div.width() + 15});
            // Show div and focus on first input
            $('#add_talent').slideDown();
            $('#name').focus();
         }
         function submit_talente() {
            // TODO
            alert('Submit talente');
            return false;
         }
         function add_talent() {
            fill_talente_form(0, '', 0, 0, 0, '', '', '');
            show_add_talente($('#btn_add_talent'));
         }
         function edit_talent(talent_id) {
            // TODO
            alert('Edit talent');
            return false;
         }
         function remove_talent(talent_id) {
            // TODO
            alert('Remove talent');
            return false;
         }
         //-->{/literal}
      </script>
   </body>
</html>

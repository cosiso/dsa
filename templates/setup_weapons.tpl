<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
   <head>
      <title>DSA - setup</title>
      <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
      <link href="css/dsa.css" rel="stylesheet" type="text/css" />
      <link href="css/alertify.css" rel="stylesheet" type="text/css" />
      <link href="css/selectize.default.css" rel="stylesheet" type="text/css" />
   </head>
   <body>
      {include file="head.tpl"}
      {include file="setup_menu.tpl" selected_category="Weapons"}
      <div style="float: left">
         <div id="main">
            <h3>Weapons</h3>
            <table id="table_weapons" cellspacing="0">
               <thead>
               <tr>
                  <th>Name</th>
                  <th>TP</th>
                  <th>TP/KK</th>
                  <th>Gewicht (uz)</th>
                  <th>Länge (cm)</th>
                  <th>BF</th>
                  <th>INI</th>
                  <th>Preis (Ag)</th>
                  <th>WM</th>
                  <th>DK</th>
                  <th>&nbsp;</th>
               </tr>
               </thead>
               <tbody>
                  {section name=idx loop=$weapons}
                     <tr id="row_{$weapons[idx].id}">
                        <td id="cell_name">{$weapons[idx].name|escape}</td>
                        <td id="cell_kampftechnik">{$weapons[idx].kampftechnik|escape}</td>
                        <td id="cell_tp">{$weapons[idx].tp|escape}</td>
                        <td id="cell_tpkk">{$weapons[idx].tpkk|escape}</td>
                        <td id="cell_gewicht">{$weapons[idx].gewicht|escape}</td>
                        <td id="cell_lange">{$weapons[idx].lange|escape}</td>
                        <td id="cell_bf">{$weapons[idx].bf|escape}</td>
                        <td id="cell_ini">{$weapons[idx].ini|escape}</td>
                        <td id="cell_preis">{$weapons[idx].preis|escape}</td>
                        <td id="cell_wm">{$weapons[idx].wm|escape}</td>
                        <td id="cell_dk">{$weapons[idx].dk|escape}</td>
                        <td>
                           <a id="link_info_{$weapons[idx].id}" href="#" class="link-info">info</a>
                           <a id="link_edit_{$weapons[idx].id}" href="#" class="link-edit">edit</a>
                           | <a id="link_remove_{$weapons[idx].id}" href="#" class="link-cancel">remove</a>
                        </td>
                     </tr>
                  {/section}
               </tbody>
            </table><br />
            <a id="btn_add_weapon" class="link-add" href="#">Add weapon</a>
         </div>
      </div>
      <script src="scripts/jquery.js"></script>
      <script src="tools/jquery-ui-1.10.4/ui/minified/jquery-ui.min.js"></script>
      <script type="text/javascript" src="scripts/alertify.min.js"></script>
      <script type="text/javascript" src="scripts/jquery.validate.min.js"></script>
      <script type="text/javascript" src="scripts/jquery.form.min.js"></script>
      <script type="text/javascript" src="scripts/jquery.simpletip-1.3.1.min.js"></script>
      <script type="text/javascript" src="scripts/jquery.tablesorter.min.js"></script>
      <script type="text/javascript" src="scripts/selectize.min.js"></script>
      <script type="text/javascript">
         <!--
         var kampftechniken = new Array(
            {ldelim} value: 0, text : '  Select a kampftechnik' {rdelim}
            {section name=idx loop=$kt}
               ,{ldelim} value: {$kt[idx].id}, text : '{$kt[idx].name|escape}' {rdelim}
            {/section}
         )
         {literal}
         $(document).ready(function() {
            // Make table sortable
            $('#table_weapons').tablesorter({headers : { 1: {sorter: false},
                                                         2: {sorter: false},
                                                         8: {sorter: false},
                                                         9: {sorter: false},
                                                        10: {sorter: false}}});
            // Add simpletip to button
            add_simpletip('#btn_add_weapon', 0);
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
         function add_simpletip(elem, id) {
            $(elem).simpletip({
               onBeforeShow : function() {
                  this.load('setup_weapons.php', {stage : 'show_form',
                                                  id    : id});
               },
               onContentLoad : function() {
                  // Selectize select field
                  $('#frm_weapons #kampftechnik').selectize({
                     sortField : 'text',
                     options : kampftechniken
                  });
                  $('#frm_weapons #kampftechnik')[0].selectize.setValue(0);
                  // Set focus
                  $('#frm_weapons #name').focus().select();
                  // Add validation to form
                  $('#frm_weapons').validate({
                     rules        : {
                        name         : { required : true },
                        tp           : { required : true },
                        tpkk         : { required : true },
                        gewicht      : { number   : true },
                        lange        : { number   : true },
                        bf           : { number   : true },
                        ini          : { number   : true },
                     },
                     submitHandler: function(form) {
                        $(form).ajaxSubmit({
                           success : do_update_weapon,
                           type    : 'post',
                           url     : 'setup_weapons.php',
                           datatype: 'json'
                        });
                        close_box();
                        return false;
                     }
                  });
               },
               persistent   : true,
               focus        : true
            });
         }
         function do_update_weapon(data) {
            data = extract_json(data);
         }
         function close_box() {
            var id = $('#frm_weapons #id').val();
            if (id) {
               // attached to link
            } else {
               $('#btn_add_weapon').eq(0).simpletip().hide();
            }
         }
         //-->{/literal}
      </script>
   </body>
</html>
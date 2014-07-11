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
                     <tr id="{$talente[idx].id}">
                        <td>{$talente[idx].name|escape}</td>
                        <td>{$talente[idx].eigenschaft1|escape} - {$talente[idx].eigenschaft2|escape} - {$talente[idx].eigenschaft3|escape}</td>
                        <td>{$talente[idx].skt|escape}</td>
                        <td>{$talente[idx].be|escape}</td>
                        <td>{$talente[idx].komp|escape}</td>
                        <td>
                           <a href="#" onclick="edit_talent({$talente[idx].id})" class="link-edit">edit</a>
                           | <a href="#" onclick="remove_talent({$talente[idx].id})" class="link-cancel">remove</a>
                        </td>
                     </tr>
                  {/section}
               </tbody>
            </table>
            <br />
            <a id="add_talent" class="link-add" href="#" onclick="edit_talent(0)">Add talent</a>
         </div>
      </div>
      <div id="popup" style="display: none"></div>
      {include file=part_script_include.tpl}
      <script type="text/javascript">
         <!--
         var category_id = {$cat_id|default:'0'};{literal}
         $().ready(function() {
            // Set classes on default tab
            $('#default-tab a').addClass('tab-inactive').addClass('tab-active');
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
         function edit_talent(talent_id) {
            // Get form
            $('#popup').width(400).height(380);
            $('#popup').html('Please wait, loading content');
            $('#popup').center();
            $('#popup').slideDown();
            $('#popup').load('talente.php',
                             { stage : 'show', talent_id : talent_id, category_id : category_id },
                             function(response, status, xhr) {
               if (status == 'error') {
                  alertify.alert('Error loading talent');
                  $('#popup').toggle();
               } else {
                  $('div#popup form#talente').validate({
                     rules         : {
                        name         : { required : true },
                        eigenschaft1 : { required: true },
                        eigenschaft2 : { required: true },
                        eigenschaft3 : { required: true },
                     },
                     submitHandler : function(form) {
                        $('#popup').slideUp();
                        $(form).ajaxSubmit({
                           url      : 'talente.php',
                           type     : 'post',
                           datatype : 'json',
                           success  : do_edit_talent,
                        });
                        return false;
                     }
                  });
               }
            });
         }
         function do_edit_talent(data) {
            data = extract_json(data);
            if (data.success) {
               if (data.is_new) {
                  // Add row
                  var row = '<tr id="' + data.id + '">' +
                     '<td>' + htmlescape(data.name) + '</td>' +
                     '<td>' + htmlescape(data.eig1) + ' - ' + htmlescape(data.eig2) + ' - ' + htmlescape(data.eig3) + '</td>' +
                     '<td>' + htmlescape(data.skt) + '</td>' +
                     '<td>' + htmlescape(data.be) + '</td>' +
                     '<td>' + htmlescape(data.komp) + '</td>' +
                     '<td><a href="#" class="link-edit" onclick="edit_talent(' + data.id + ')">edit</a>' +
                     ' | <a href="#" class="link-cancel" onclick="remove_talent(' + data.id + ')">remove</a></td>' +
                     '</tr>';
                  $('table#talente tbody').append(row);
               } else {
                  // Edit row
                  var row = 'table#talente tr#' + data.id;
                  $(row + ' td:nth-child(1)').text(data.name);
                  $(row + ' td:nth-child(2)').text(data.eig1 + ' - ' + data.eig2 + ' - ' + data.eig3);
                  $(row + ' td:nth-child(3)').text(data.skt);
                  $(row + ' td:nth-child(4)').text(data.be);
                  $(row + ' td:nth-child(5)').text(data.komp);
               }
               $('table#talente tr#' + data.id).effect('highlight', {}, 2000);
            }
         }
         function remove_talent(talent_id) {
            var name = $('table#talente tr#' + talent_id + ' td:nth-child(1)').text();
            console.log('Name: ' + name);
            alertify.confirm('Remove talent ' + name + '?', function(e) {
               if (e) {
                  $.ajax({
                     datatype : 'json',
                     url      : 'talente.php',
                     data     : { id : talent_id, stage : 'remove' },
                     type     : 'post',
                     success  : do_remove_talent,
                  });
               }
            });
            return false;
         }
         //-->{/literal}
      </script>
   </body>
</html>

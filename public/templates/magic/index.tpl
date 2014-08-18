{extends file='base.tpl'}
{block name='title'}DSA - Magic{/block}
{block name="menu_left"}{include file="magic/divs/menu-left.tpl"}{/block}
{block name='main'}
   {foreach $chars as $id=>$name}
      <h3 onclick="toggle({$id})">{$name|escape}</h3>
      <div id="char-{$id}" style="display: none; padding-left: 20px"></div>
   {/foreach}
{/block}
{block name="javascript"}
   <script type="text/javascript">
      <!--
      $(document).ready(function() {
         $.validator.addMethod('notempty', function(value, element, parameter) {
            var v = parseInt(value) || 0;
            return this.optional(element) || v > 0;
         }, 'Select an option');
         $.validator.addMethod('skt', function(value, element, parameter) {
            var v = value.toUpperCase();
            if (v != 'A' && v != 'B' && v != 'C' && v != 'D' && v != 'E' && v != 'F' && v != 'G' && v != 'H' && v != '') {
               v = false;
            } else {
               v = true;
            }
            return this.optional(element) || v;
         }, 'Invalid SKT');
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
      function toggle(id) {
         var div = '#char-' + id;
         if ($(div).is(':visible')) {
            $(div).hide();
            return;
         }
         if ($(div).html()) {
            $(div).show();
            return;
         }
         $(div).load('magic.php',
                     { stage : 'show-char', id : id },
                     function(response, status, xhr) {
            if (status != 'success') {
               alertify.alert('An unknown error occurred');
               return;
            }
            $(div).show();
         });
      }
      function edit_cm(span) {

      }
      function add_cm(span) {
         // Fetch character id from parent span > td > tr > tbody > table
         var id = $(span).parent().parent().parent().parent().prop('id').split('-')[1];
         cont_cm(id, 0);
      }
      function cont_cm(char_id, cm_id) {
         $('#popup').width('auto').height('auto').css('max-width', '').text('Retrieving form').show().center();
         $('#popup').load('magic.php',
                          { stage : 'frm-cm', id : char_id, edit : 0 },
                          function(response, status, xhr) {
            if (status != 'success') {
               alertify.alert('An unknown error occurred');
               return;
            }
            $('#popup').center();
            $('#popup #frm-edit-cm').validate({
               rules : {
                  quelle : { required : true, notempty : true },
                  skt    : { required : true, skt : true },
               },
               submitHandler : function(form) {
                  $(form).ajaxSubmit({
                     datatype : 'json',
                     type     : 'post',
                     url      : 'magic.php',
                     success  : do_edit_cm,
                  })
                  $('#popup').hide();
               },
            });
         });
      }
      function do_edit_cm(data) {
         data = extract_json(data);
      }
      //-->
   </script>
{/block}

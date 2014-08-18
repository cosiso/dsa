{if $error}
   <script type="text/javascript">
      alertify.alert('{$error}');
      $('#popup').hide();
   </script>
{else}
{custom_form name='frm_note'}
   {custom_hidden name='id' value=$ct_id}
   {custom_hidden name='stage' value='edit-note'}
   {custom_textarea name='note' value=$note|escape style='width: 350px; height: 250px'}
   <br>
   <div class="button_bar">
      {custom_button type='submit'}
      {custom_button type='reset' onclick="$('#popup').hide()"}
   </div>
{/custom_form}
{/if}
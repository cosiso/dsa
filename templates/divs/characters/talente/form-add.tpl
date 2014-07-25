{if $error}
   <script type="text/javascript">
      alertify.alert('{$error}');
      $('#popup').hide();
   </script>
{else}
   {custom_form name="frm_add"}
      {custom_hidden name='stage' value='add'}
      {custom_hidden name='talent_id' value=$id}
      <label for='character_id'>Character:</label>
      {html_options name='character_id' id='character_id' options=$characters}<br>
      {custom_text name='value' style='width: 4em' label='Value:'}<br>
      {custom_textarea name='note' style='width: 400px; height: 150px' label='Note:'}<br>
      <div class="button_bar">
         {custom_button type='submit'}
         {custom_button type='reset' onclick="$('#popup').hide()"}
      </div>
   {/custom_form}
{/if}

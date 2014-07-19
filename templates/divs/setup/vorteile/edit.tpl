{if $error}
<script type="text/javascript">
   alertify.alert('{$error}');
   $('#popup').hide();
</script>
{else}
{custom_form name='edit_vorteil'}
   {custom_hidden name='stage' value='edit'}
   {custom_hidden name='id' value=$id}
   {custom_hidden name='is_vorteil' value=$is_vorteil}
   {custom_text name='name' style='width: 20em' value=$name|escape label='Name'}<br>
   {custom_text name='gp' style='width: 3em' value=$gp label='GP'}<br>
   {custom_text name='ap' style='width: 3em' value=$ap label='AP'}<br>
   {custom_textarea name='effect' style='width: 90%; height: 4em' value=$effect|escape label='Effect'}<br>
   {custom_textarea name='description' style='width: 90%; height: 16em' value=$description|escape label='Description'}<br>
   <div class="button_bar">
      {custom_button type='submit'}
      {custom_button type='reset' onclick="$('#popup').hide()"}
   </div>
{/custom_form}
{/if}
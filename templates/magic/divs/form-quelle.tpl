{if $error}
   <script type="text/javascript">
      alertify.alert('{$error}');
      $('#popup').hide();
   </script>
{else}
{custom_form name='form-quelle'}
   {custom_hidden name='stage' value='edit-quelle'}
   {custom_hidden name='id' value=$id}
   {custom_text name='name' value=$name|escape style='width: 25em' label='Name'}<br>
   {custom_textarea name='desc' value=$description|escape|nl2br style='width: 400px; height: 250px' label='Description'}<br>
   <div class="button_bar">
      {custom_button type='submit'}
      {custom_button type='close' onclick="$('#popup').hide()"}
   </div>
{/custom_form}
{/if}
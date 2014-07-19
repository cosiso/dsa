{if $error}
   <script type="text/javascript">
      alertify.alert('{$error}');
      $('#popup').hide();
   </script>
{else}
   <h4>{$name|escape}</h4>
   <b>Effect:</b>
   {$effect|escape|nl2br}<br>
   <b>Description:</b>
   {$description|escape|nl2br}<br>
   <br>
   {custom_form name='edit_vorteil'}
      {custom_hidden name='stage' value='edit'}
      {custom_hidden name='char_id' value=$char_id}
      {custom_hidden name='vorteil_id' value=$vorteil_id}
      {custom_hidden name='cv_id' value=$id}
      <b>Value: </b>{custom_text name='value' value=$value style='width: 50px'}<br>
      <b>Note:</b><br>
      {custom_textarea name='note' value=$note|escape style='width: 400px; height: 100px'}
      <div class="button_bar">
         {custom_button type="submit"}
         {custom_button type="reset" onclick="$('#popup').hide()" value="close"}
         | <a href="#" class="link-cancel" onclick="remove_vorteil({$id})">remove</a>
      </div>
   {/custom_form}
{/if}

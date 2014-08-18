{if $error}
   <script type="text/javascript">
      alertify.alert('{$error}');
      $('#popup').hide();
   </script>
{else}
<h4>{$eigenschaft|escape} for {$name|escape}</h4>
{custom_form name='eigenschaft'}
   {custom_hidden name='stage' value='edit_real_eigenschaft'}
   {custom_hidden name='trait_id' value=$trait_id}
   {custom_hidden name='char_id' value=$char_id}
   <table border="0">
      <tr>
         <td colspan="2">
            {custom_text name='base' value=$base label='Base' style='width: 50px'}
         </td>
      </tr>
      <tr>
         <td>
            {custom_text name='modifier' value=$modifier label='Modifier' style='width: 50px'}
         </td>
         <td>
            {custom_text name='zugekauft' value=$zugekauft label='Raised' style='width: 50px'}
         </td>
      </tr>
      <tr>
         <td colspan="2">
            {custom_textarea name='note' value=$note|escape label='Note' style='width: 250px; height: 50px'}
         </td>
      </tr>
   </table>
   <div class="button_bar">
      {custom_button type="submit"}
      {custom_button type="reset" onclick="$('#popup').hide()"}
   </div>
{/custom_form}
{/if}

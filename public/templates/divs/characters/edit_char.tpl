<h2>{$name|escape}</h2>
{custom_form name='edit_char'}
   {custom_hidden name='id' value=$id}
   {custom_hidden name='stage' value='edit_char'}
   <legend>General values</legend>
   {custom_text name='rasse' value=$rasse|escape label='Race'}<br>
   {custom_text name='kultur' value=$kultur|escape label='Culture'}<br>
   {custom_text name='profession' value=$profession|escape label='Profession'}<br>
   <legend>Appearance</legend>
   <table border="0" style="width: 100%">
      <tr>
         <td>
            {custom_text name='grosse' value=$grosse|escape label='Height' style='width: 50px'}
         </td>
         <td>
            {custom_text name='gewicht' value=$gewicht|escape label='Weight' style='width: 50px'}
         </td>
      </tr>
      <tr>
         <td>
            {custom_text name='alter' value=$alter|escape label='Age' style='width: 50px'}
         </td>
         <td>
            {custom_text name='geschlecht' value=$geschlecht|escape label='Sex' style='width: 100px'}
         </td>
      </tr>
      <tr>
         <td>
            {custom_text name='augenfarbe' value=$augenfarbe|escape label='Eye color' style='width: 100px'}
         </td>
         <td>
            {custom_text name='haarfarbe' value=$haarfarbe|escape label='Hair color' style='width: 100px'}
         </td>
      </tr>
   </table>
   {custom_textarea name='aussehen' style="width: 250px; height: 100px" value=$aussehen|escape label='Aussehen'}
   <div class="button_bar">
      {custom_button type='submit'}
      {custom_button type='reset' onclick="$('#popup').hide()"}
   </div>
{/custom_form}

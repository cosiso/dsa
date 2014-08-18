<form id="frm_kampf_sf">
   {custom_hidden name=stage value='update_sf'}
   {custom_hidden name=id value=$id}
   {custom_text name='name' style='width: 20em' value=$name|escape label='Name'}<br>
   {custom_text name='gp' style='width: 3em' value=$gp|escape label='GP'}<br>
   {custom_text name='ap' style='width: 3em' value=$ap|escape label='AP'}<br>
   {custom_textarea name="effect" style="width: 90%; height: 4em" value=$effect|escape label='Effect'}<br>
   {custom_textarea name="description" style="width: 90%; height: 16em" value=$description|escape label='Desription'}<br>
   <div class="button_bar">
      {custom_button type='submit'}
      {custom_button type='close' onclick="$('#popup').hide()"}
   </div>
</form>
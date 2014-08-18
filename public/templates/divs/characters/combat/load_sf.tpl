<h4>Add a kampfsonderfertigkeit for <em>{$name|escape}</em></h4>
<form id="p_add_sf">
   {custom_hidden name='stage' value='add_sf'}
   {custom_hidden name='char_id' value=$char_id}
   {html_options name='p_sf' id='p_sf' options=$sf}<br />
   <div class="button_bar">
      {custom_button type='submit'}
      {custom_button type='close' onclick="$('#popup').slideUp()"}
   </div>
</form>

<h4>Add a kampfsonderfertigkeit for <em>{$name|escape}</em></h4>
<form id="p_add_sf">
   {html_hidden name='stage' value='add_sf'}
   {html_hidden name='char_id' value=$char_id}
   {html_options name='p_sf' options=$sf}<br />
   <div class="button_bar">
      {carto_button type='submit'}
      {carto_button type='close' onclick="$('#popup').slideUp()"}
   </div>
</form>

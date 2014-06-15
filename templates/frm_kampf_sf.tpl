<form id="frm_kampf_sf">
   {html_hidden name=stage value='update_sf'}
   {html_hidden name=id value=$id}
   <label for="name">Name</label>
   {html_text name='name' style='width: 20em' required=true value=$name|escape}<br />
   <label for="gp">GP</label>
   {html_text name='gp' style='width: 3em' value=$gp|escape}
   <label for="gp">AP</label>
   {html_text name='ap' style='width: 3em' value=$ap|escape}
   <label for="effect">Effect</label>
   <textarea name="effect" id="effect" style="width: 90%; height: 4em" required>{$effect|escape}</textarea>
   <label for="description">Description</label>
   <textarea name="description" id="description" style="width: 90%; height: 16em">{$description|escape}</textarea>
   <div class="button_bar">
      {carto_button type='submit'}
      {carto_button type='close' onclick="close_frm_kampf_sf()"}
   </div>
</form>
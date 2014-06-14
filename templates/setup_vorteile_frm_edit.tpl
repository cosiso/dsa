<form name="frm_vorteil" id="frm_vorteil">
   {html_hidden name="stage" value="new"}
   {html_hidden name='id' value=$id}
   {html_hidden name="is_vorteil" value=$is_vorteil}
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
      {carto_button type='close' onclick="close_edit_box()"}
   </div>
   VORTEIL: {$tst}
</form>

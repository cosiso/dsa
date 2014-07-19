<h4>Add {$vorteil}</h4>
{custom_form name="add_vorteil"}
   {custom_hidden name='stage' value='add_vorteil'}
   <label for="char">Character</label>
   {html_options name='char' id='char' options=$chars}<br>
   <br>
   <label for="vorteil">{$vorteil|capitalize}</label>
   {html_options name='vorteil' id='vorteil' options=$vorteile}<br>
   <br>
   <div class="button_bar">
      {custom_button type='submit'}
      {custom_button type='reset' onclick="$('#popup').hide()"}
   </div>
{/custom_form}

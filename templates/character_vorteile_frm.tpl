<form name="frm_vorteil" id="frm_vorteil">
   {html_hidden name='stage' value='edit_vorteil'}
   {html_hidden name='character_id'}
   {html_hidden name='id' value=$id}
   {html_hidden name='vorteil' value=$vorteil}
   <label for="list_vorteile">Vorteile</label>
   <select id="list_vorteile" style="width: 20em">
      {section name=idx loop=$vorteile}
         <option value="{$vorteile[idx].id}"{if $id == $vorteile[idx].id} selected{/if} data-is_vorteil="{$vorteile[idx].vorteil}">{$vorteile[idx].name|escape}</option>
      {/section}
   </select><br />
   <label for="vorteil_value">Value</label>
   {html_text name="vorteil_value" value=$value|escape}
   <label for="vorteil_note">Note</label>
   <textarea id="vorteil_note" name="vorteil_note" style="width: 40em; height: 4em">{$note|escape}</textarea><br />
   <div class="button_bar">
      {carto_button type="submit"}
      {carto_button type='close' onclick="close_edit_vorteile_box()"}
   </div>
</form>

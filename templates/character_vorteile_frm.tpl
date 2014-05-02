<select id="list_vorteile" style="margin: 20px" data-placeholder="Please select a vorteil">
   {section name=idx loop=$vorteile}
      <option value="{$vorteile[idx].id}">{$vorteile[idx].name|escape}</option>
   {/section}
</select>
{carto_button type="submit" onclick="vorteil_selected()"}
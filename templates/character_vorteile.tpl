<table id="table_vorteile" class="sortable">
   <thead>
      <tr>
         <th>&nbsp;</th>
         <th>Vor- / Nachteil</th>
         <th>Value</th>
         <th>Effect</th>
         <th>Note</th>
         <th>&nbsp;</th>
      </tr>
   </thead>
   <tbody class="hover">
      {section name=idx loop=$vorteile}
         <tr id="vorteil_{$vorteile[idx].id}">
            <td id="cell_img"><img src="images/{if $vorteile[idx].vorteil}plus-16.png{else}minus-16.png{/if}" border="0" /></td>
            <td id="cell_name">{$vorteile[idx].name|escape}</td>
            <td id="cell_value">{$vorteile[idx].value|escape}</td>
            <td id="cell_effect">{$vorteile[idx].effect|escape}</td>
            <td id="cell_note">{$vorteile[idx].note|escape}</td>
            <td>
               <a id="vorteile_link_desc" href="#" class="link-info">description</a>
               | <a id="vorteile_link_edit" href="#" class="link-edit">edit</a>
               | <a id="cell_remove" href="#" class="link-cancel" onclick="remove_vorteil({$vorteile[idx].id}, '{$vorteile[idx].name|escape}')">remove</a>
            </td>
         </tr>
      {/section}
   </tbody>
</table><br />
<a id="btn_add_vorteil" href="#" class="link-add">Add vor-/nachteil</a>
<br />{carto_spacer height=16}
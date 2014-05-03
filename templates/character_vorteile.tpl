<table id="table_vorteile" class="sortable">
   <thead>
      <tr>
         <th>Vorteil</th>
         <th>Value</th>
         <th>Effect</th>
         <th>Note</th>
         <th>&nbsp;</th>
      </tr>
   </thead>
   <tbody class="hover">
      {section name=idx loop=$vorteile}
         <tr id="vorteil_{$vorteile[idx].id}">
            <td>{$vorteile[idx].name|escape}</td>
            <td>{$vorteile[idx].value|escape}</td>
            <td>{$vorteile[idx].effect|escape}</td>
            <td>{$vorteile[idx].note|escape}</td>
            <td>
               <a id="vorteile_link_desc" href="#" class="link-info" onclick="vorteile_description(this, {$vorteile[idx].vorteil_id})">description</a>
               | <a id="vorteile_link_edit" href="#" class="link-edit">edit</a>
               | <a href="#" class="link-cancel" onclick="remove_vorteil({$vorteile[idx].id}, '{$vorteile[idx].name|escape}')">remove</a>
            </td>
         </tr>
      {/section}
   </tbody>
</table><br />
<a id="btn_add_vorteil" href="#" class="link-add">Add vor-/nachteil</a>
<br />{carto_spacer height=16}
<table id="kampf_sf">
   <thead>
      <tr>
         <th>Name</th>
         <th>GP</th>
         <th>AP</th>
         <th>Effect</th>
         <th>&nbsp;</th>
      </tr>
   </thead>
   <tbody class="hover">
      {section name=idx loop=$sf}
         <tr id="{$sf[idx].id}">
            <td id="name">{$sf[idx].name|escape}</td>
            <td id="gp">{$sf[idx].gp}</td>
            <td id="ap">{$sf[idx].ap}</td>
            <td id="effect">{$sf[idx].effect|escape}</td>
            <td>
               <a href="#" id="note" class="link-info">note</a>
               | <a href="#" id="edit" class="link-edit">edit</a>
               | <a href="#" id="remove" class="link-cancel" onclick="remove_kampf_sf({$sf[idx].id})">remove</a>
            </td>
         </tr>
      {/section}
   </tbody>
</table><br />
<a id="btn_add_sf" class="link-add" href="#">Add sonderfertigkeit</a>

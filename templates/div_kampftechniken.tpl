<table id="table_kampftechniken" cellspacing="0">
   <thead>
   <tr>
      <th>Name</th>
      <th>SKT</th>
      <th>BE</th>
      <th>&nbsp;</th>
   </tr>
   </thead>
   <tbody>
      {section name=idx loop=$kampftechniken}
         <tr id="row_{$kampftechniken[idx].id}">
            <td id="cell_name">{$kampftechniken[idx].name|escape}</td>
            <td id="cell_skt">{$kampftechniken[idx].skt|escape}</td>
            <td id="cell_be">{$kampftechniken[idx].be|escape}</td>
            <td>
               <a href="#" onclick="edit_kampftechniken({$kampftechniken[idx].id})" class="link-edit">edit</a>
               | <a href="#" onclick="remove_kampftechniken({$kampftechniken[idx].id})" class="link-cancel">remove</a>
            </td>
         </tr>
      {/section}
   </tbody>
</table><br />
<a id="btn_add_kampftechnik" class="link-add" href="#">Add kampftechnik</a>


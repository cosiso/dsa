<table id="table_kampftechniken" cellspacing="0">
   <thead>
   <tr>
      <th>Name</th>
      <th>SKT</th>
      <th>BE</th>
      <th>Unarmed</th>
      <th>&nbsp;</th>
   </tr>
   </thead>
   <tbody class="hover">
      {section name=idx loop=$kampftechniken}
         <tr id="row_{$kampftechniken[idx].id}">
            <td id="cell_name">{$kampftechniken[idx].name|escape}</td>
            <td id="cell_skt">{$kampftechniken[idx].skt|escape}</td>
            <td id="cell_be">{$kampftechniken[idx].be|escape}</td>
            <td id="cell_ua" style="text-align: center">
               {if $kampftechniken[idx].unarmed == 't'}
                  <img src="images/bullet_orange.png" border="0" width="16" height="16" />
               {else}
                  &nbsp;
               {/if}
            </td>
            <td>
               <span id="link_edit_{$kampftechniken[idx].id}" class="link-edit">edit</span>
               | <span id="link_remove_{$kampftechniken[idx].id}" class="link-cancel">remove</span>
            </td>
         </tr>
      {/section}
   </tbody>
</table><br />
<span id="btn_add_kampftechnik" class="link-add">Add kampftechnik</span>

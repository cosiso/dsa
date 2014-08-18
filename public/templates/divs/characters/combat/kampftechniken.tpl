{section name='idx' loop=$chars}
   <div>
      <h4>{$chars[idx].name|escape}</h4>
      <table>
         <thead>
            <tr>
               <th>Name</th>
               <th>AT</th>
               <th>PA</th>
               <th></th>
            </tr>
         </thead>
         <tbody class="hover">
            {section name='idx2' loop=$chars[idx].techniken}
               <tr id="{$chars[idx].techniken[idx2].id}">
                  <td>{if $chars[idx].techniken[idx2].unarmed}<img src="images/bullet_orange.png" alt="yes" border="0">{/if}{$chars[idx].techniken[idx2].name|escape}</td>
                  <td style="text-align: right">
                     <span id="at">{$chars[idx].techniken[idx2].at|escape}</span>
                     <img src="images/plus-16.png" alt="plus" border="0" style="cursor: pointer" onclick="raise_kt(this, 'at', 1)">
                     <img src="images/minus-16.png" alt="minus" border="0" style="cursor: pointer" onclick="raise_kt(this, 'at', -1)">
                  </td>
                  <td style="text-align: right">
                     <span id="pa">{$chars[idx].techniken[idx2].pa|escape}</span>
                     <img src="images/plus-16.png" alt="plus" border="0" style="cursor: pointer" onclick="raise_kt(this, 'pa', 1)">
                     <img src="images/minus-16.png" alt="minus" border="0" style="cursor: pointer" onclick="raise_kt(this, 'pa', -1)">
                  </td>
                  <td><span class="link-cancel" onclick="remove_kt(this)">remove</span></td>
               </tr>
            {/section}
            <tr id="kt_add_{$chars[idx].id}">
               <td colspan="4" style="text-align: right; height: 30px">
                  <span class="link-add" onclick="kt_add({$chars[idx].id})">Add Kampftechnik</span>
               </td>
            </tr>
         </tbody>
      </table>
   </div>
{sectionelse}
<b>No characters defined</b>
{/section}
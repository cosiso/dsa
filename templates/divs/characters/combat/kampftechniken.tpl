{section name='idx' loop=$chars}
   <div id="kt_{$chars[idx].id}">
      <h4>{$chars[idx].name|escape}</h4>
      <table>
         <thead>
            <tr>
               <th>Name</th>
               <th>AT</th>
               <th>PA</th>
               <th>llll</th>
            </tr>
         </thead>
         <tbody class="hover">
            {section name='idx2' loop=$chars[idx].techniken}
               <tr id="{$chars[idx].techniken[idx2].id}">
                  <td>{if $chars[idx].techniken[idx2].unarmed}<img src="images/bullet_orange.png" alt="yes" border="0">{/if}{$chars[idx].techniken[idx2].name|escape}</td>
                  <td style="text-align: right">
                     {$chars[idx].techniken[idx2].at|escape}
                     <img src="images/plus-16.png" alt="plus" border="0" style="cursor: pointer" onclick="raise_kt(this, 'at', 1)">
                     <img src="images/minus-16.png" alt="minus" border="0" style="cursor: pointer" onclick="raise_kt(this, 'at', -1)">
                  </td>
                  <td style="text-align: right">
                     {$chars[idx].techniken[idx2].pa|escape}
                     <img src="images/plus-16.png" alt="plus" border="0" style="cursor: pointer" onclick="raise_kt(this, 'pa', 1)">
                     <img src="images/minus-16.png" alt="minus" border="0" style="cursor: pointer" onclick="raise_kt(this, 'pa', -1)">
                  </td>
                  <td><span class="link-cancel" onclick="remove_kt(this)">remove</span></td>
               </tr>
            {/section}
         </tbody>
      </table>
   </div>
{sectionelse}
<b>No characters defined</b>
{/section}
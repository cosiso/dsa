<table id="kampftechniken">
   <thead>
      <tr>
         <th>&nbsp;</th>
         <th>Kampfechnik</th>
         <th>SKT</th>
         <th>BE</th>
         <th colspan="2">AT</th>
         <th colspan="2">PA</th>
         <th>TaW</th>
         <th>&nbsp;</th>
      </tr>
   </thead>
   <tbody class="hover">
      {section name=idx loop=$kt}
      <tr id="{$kt[idx].id}">
         <td id="star">
            <img src="images/star{if ! $kt[idx].character_id}-inactive{/if}-16.png" border="0" width="16" height="16" />
         </td>
         <td>{$kt[idx].name|escape}</td>
         <td>{$kt[idx].skt|escape}</td>
         <td>{$kt[idx].be|escape}</td>
         <td id="at_{$kt[idx].id}">{$kt[idx].at}</td>
         <td>
            <span style="display: {if $kt[idx].character_id}inline{else}none{/if}" onclick="raise_at({$kt[idx].id})">
               <img src="images/plus-16.png" border="0" width="16" height="16" />
            </span>
            <span style="display: {if $kt[idx].character_id}inline{else}none{/if}" onclick="lower_at({$kt[idx].id})">
               <img src="images/minus-16.png" border="0" width="16" height="16" />
            </span>
         </td>
         <td id="pa_{$kt[idx].id}">{$kt[idx].pa}</td>
         <td>
            <span style="display: {if $kt[idx].character_id}inline{else}none{/if}" onclick="raise_pa({$kt[idx].id})">
               <img src="images/plus-16.png" border="0" width="16" height="16" />
            </span>
            <span style="display: {if $kt[idx].character_id}inline{else}none{/if}" onclick="lower_pa({$kt[idx].id})">
               <img src="images/minus-16.png" border="0" width="16" height="16" />
            </span>
         </td>
         <td id="taw_{$kt[idx].id}">{$kt[idx].taw}</td>
         <td id="lnk_{$kt[idx].id}">
            {if $kt[idx].character_id}
               <a href="#" onclick="unlearn_kampftechnik({$kt[idx].character_id}, {$kt[idx].id})">
                  <img src="images/person-minus-16.png" border="0" width="16" height="16" />unlearn
               </a>
            {else}
               <a href="#" onclick="learn_kampftechnik({$kt[idx].id})">
                  <img src="images/person-plus-16.png" border="0" width="16" height="16" />learn
               </a>
            {/if}
         </td>
      </tr>
      {sectionelse}
         <tr><td colspan="8">No kampftechniken defined</td></tr>
      {/section}
   </tbody>
</table>
<h4>Unarmed</h4>
<table id="table_unarmed">
   <thead>
      <th>Kampftechnik</th>
      <th>TP/KK</th>
      <th>INI</th>
      <th>AT</th>
      <th>PA</th>
      <th>TP (A)</th>
      <tbody class="hover">
         {section name=idx loop=$unarmed}
            <tr>
               <td>{$unarmed[idx].kampftechnik|escape}</td>
               <td>{$unarmed[idx].tpkk}</td>
               <td>{$unarmed[idx].ini}</td>
               <td>{$unarmed[idx].at}</td>
               <td>{$unarmed[idx].pa}</td>
               <td>{$unarmed[idx].tp}</td>
            </tr>
         {sectionelse}
            <tr><td colspan="6">No unarmed kampftechnik defined</td></tr>
         {/section}
      </tbody>
   </thead>
</table>
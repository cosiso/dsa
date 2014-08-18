{if $error}
   <script type="text/javascript">
      alertify.alert('{$error}');
   </script>
{else}
   <table id="quelle-{$id}" cellpadding="0" cellspacing="0">
      <thead>
         <tr>
            <th>Quelle</th>
            <th>Tradition</th>
            <th>Beschwörung</th>
            <th>Type</th>
            <th>Value</th>
            <th></th>
         </tr>
      </thead>
      <tbody class="hover">
         {section name='idx' loop=$cm}
            <tr>
               <td>{$cm[idx].name|escape}</td>
               <td>{$cm[idx].tradition|escape}</td>
               <td>{$cm[idx].beschworung|escape}</td>
               <td>{$cm[idx].wesen|escape}</td>
               <td style="text-align: right">
                  <span>{$cm[idx].value|default:0}</span>
                  <span>+</span>
                  <span>-</span>
               </td>
               <td>
                  <span>info</span>
                  <span>edit</span>
                  <span>remove</span>
               </td>
            </tr>
         {/section}
         <tr>
            <td colspan="6" style="text-align: right">
               <span class='link-add-small' onclick="add_cm(this)">Add</span>
            </td>
         </tr>
      </tbody>
   </table>
{/if}
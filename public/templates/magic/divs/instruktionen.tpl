{if $error}
   <script type="text/javascript">
      alertify.alert('{$error}');
   </script>
{else}
   <table id="tbl_instruktionen" border="0" cellpadding="0" cellspacing="0">
      <thead>
         <tr>
            <th>Name</th>
            <th></th>
         </tr>
      </thead>
      <tbody class="hover">
         {section name=idx loop=$instruktionen}
            <tr id="instruktion-{$instruktionen[idx].id}">
               <td>{$instruktionen[idx].name|escape}</td>
               <td>
                  <span class="link-info" onclick="note_instruktion(this)">description</span>
                  | <span class="link-edit" onclick="show_instruktion(this)">edit</span>
                  | <span class="link-cancel" onclick="remove_instruktion(this)">remove</span>
               </td>
            </tr>
         {/section}
         <tr>
            <td colspan="2" style="padding-top: 10px; text-align: right">
               <span class="link-add" onclick="add_instruktion()">Add instruktion</span>
            </td>
         </tr>
      </tbody>
   </table>
{/if}

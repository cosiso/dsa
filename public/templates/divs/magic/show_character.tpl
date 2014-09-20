{if $error != ''}
   <script type="text/javascript">
      alertify.alert("{$error}");
   </script>
{else}
<img src="/images/bullet_orange.png"><b>Quellen: </b>
<table>
   <thead>
      <tr>
         <th>Quelle</th>
         <th>Value</th>
         <th>Tradition</th>
         <th>Essenz/Wesen</th>
         <th>Inspiration/Invokation</th>
         <th>SKT</th>
         <th></th>
      </tr>
   </thead>
   <tbody class="hover">
      {section i $cm}
         <tr id="cm-{$cm[i].id}">
            <td>{$cm[i].name|escape}</td>
            <td>{$cm[i].value|escape}</td>
            <td>{$cm[i].tradition|escape}</td>
            <td>{$cm[i].beschworung|escape}</td>
            <td>{$cm[i].wesen|escape}</td>
            <td>{$cm[i].skt|escape}</td>
            <td>
               <span class="link-edit" onclick="edit_source(this)">edit</span>
               | <span class="link-cancel" onclick="remove_source(this)">remove</span>
            </td>
         </tr>
      {/section}
      <tr>
         <td colspan="7" style="padding: 10px; text-align: right">
            <span class="link-add" onclick="add_source(this)">Add quelle</span>
         </td>
      </tr>
   </tbody>
</table><br>
<div style="padding-top: 8px">
   <img src="/images/bullet_orange.png"><b>Instruktionen: </b>
   <ul class="single-line">
      {section i $ci}
         <li id="{$ci[i].id }}" onclick="remove_instruktion(this)">{$ci[i].name}</li>
      {/section}
   </ul><br style="float: none"><br>
   <span class="link-add" onclick="add_instruktion(this)">Add instruktion</span><br>
   <br>
</div>
<hr>
{/if}
{if $error}
   <script type="text/javascript">
      alertify.alert('{$error}');
   </script>
{else}
{section name='idx' loop=$talente}
   <div id="talent-{$talente[idx].id}" onclick="$('#chars-{$talente[idx].id}').toggle()" style="cursor: pointer">
      <h4>
         {$talente[idx].name|escape}
         <span style="font-size: 9px; color: #215452">
            ({$talente[idx].eig1|escape} - {$talente[idx].eig2|escape} - {$talente[idx].eig3|escape})
         </span>
      </h4>
   </div>
   <table id="chars-{$talente[idx].id}" style="display: none">
      <thead>
         <tr>
            <th>Name</th>
            <th>Attributes</th>
            <th colspan="2">Value</th>
            <th>Roll</th>
            <th>Note</th>
            <th></th>
         </tr>
      </thead>
      <tbody class="hover">
         {section name='idx2' loop=$talente[idx].chars}
            <tr id="ct-{$talente[idx].chars[idx2].id}">
               <td>{$talente[idx].chars[idx2].name|escape}</td>
               <td id="values">
                  {$talente[idx].chars[idx2].e1} - {$talente[idx].chars[idx2].e2} - {$talente[idx].chars[idx2].e3}
               </td>
               <td style="text-align: right">{$talente[idx].chars[idx2].value}</td>
               <td>
                  <img src="images/plus-16.png" border="0" alt="plus" style="cursor: pointer" onclick="ct_change(this, 1)">
                  <img src="images/minus-16.png" border="0" alt="minus" style="cursor: pointer" onclick="ct_change(this, -1)">
               </td>
               <td onclick="roll_talent(this)"><img src="images/dice-red-16.png" border="0" alt="roll"></td>
               <td id="note">{$talente[idx].chars[idx2].note|escape|nl2br}</td>
               <td>
                  <span class="link-edit" onclick="edit_note(this)">edit note</span>
                  | <span class="link-cancel" onclick="remove_char(this)">remove</span>
               </td>
            </tr>
         {/section}
         <tr>
            <td colspan="7" style="text-align: right">
               <span class="link-accept" onclick="add_char(this)">add talent to character</span>
            </td>
         </tr>
      </tbody>
   </table>
{sectionelse}
   <b>No talente in this category defined.</b>
{/section}
{/if}
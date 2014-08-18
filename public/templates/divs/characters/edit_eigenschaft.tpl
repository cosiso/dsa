{if $error}
   <script type="text/javascript">
      alertify.alert('{$error}');
      $('#popup').hide();
   </script>
{else}
<h4>{$eigenschaft|escape}</h4>
<form id="edit_eigenschaft">
   <input type="hidden" name="id" id="id" value="{$id}">
   <input type="hidden" name="eigenschaft" id="eigenschaft" value={$eigenschaft|escape}>
   <input type="hidden" name="stage" id="stage" value="edit_eigenschaft">
   <table cellspacing="3" cellpadding="0" border="0">
      <tr>
         <td><b>Base</b></td>
         <td>
            <input type="text" disabled value="{$base}" style="width: 25px">
         </td>
      </tr>
      <tr>
         <td><b>Modifier</b><br></td>
         <td>
            <input type="text" name="modifier" id="modifier" value="{$mod}" style="width: 25px">
         </td>
      </tr>
      <tr>
         <td><b>Bought</b></td>
         <td>
            <input type="text" name="bought" id="bought" value="{$bought}" style="width: 25px"{if $bought == '--'} disabled{/if}>
         </td>
      </tr>
   </table>
   <div style="padding-top: 5px">
      <input type="submit" class="menu-button-submit" value="Save">
      <input type="button" class="menu-button-reset" value="Cancel" onclick="$('#popup').hide()">
   </div>
</form>
{/if}

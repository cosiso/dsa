{if $error}
<script type="text/javascript">alertify.alert('Error: {$error}')</script>
{else}
<form name="frm_weapons" id="frm_weapons">
   {html_hidden name='stage' value='update_weapon'}
   {html_hidden name='id' value=$id}
   <label for="name">Name</label>
   {if $id}
      {html_text name='name' value=$name|escape style='width: 20em' disabled=true}
   {else}
   {/if}
   <table cellpadding="0" cellspacing="5" border="0">
      <tr>
         <td>
            <label for="tp">TP</label>
            {html_text name='tp' value=$tp|escape style='width: 5em'} (f.e. 1d6+2)
         </td>
         <td>
            <label for="tpkk">TP/KK</label>
            {html_text name='tpkk' value=$tpkk|escape style='width: 5em'}
         </td>
      </tr>
      <tr>
         <td>
            <label for="ini">INI</label>
            {html_text name='ini' value=$ini style='width: 5em'}
         </td>
         <td>
            <label for="wm">WM</label>
            {html_text name='wm' value=$wm|escape style='width: 5em'}
         </td>
      </tr>
      <tr>
         <td>
            <label for="at">AT</label>
            {html_text name='at' value=$at style='width: 5em'}
         </td>
         <td>
            <label for="wm">PA</label>
            {html_text name='pa' value=$pa style='width: 5em'}
         </td>
      </tr>
         </td>
      </tr>
      <tr>
         <td>
            <label for="bf">BF</label>
            {html_text name='bf' value=$bf|escape style='width: 5em'}
         </td>
         <td>&nbsp;</td>
      </tr>
   </table>
   <label for="note">Note</label>
   {html_textarea name="note" value=$note style="width: 40em; height: 8em"}
   <div class="button_bar">
      {carto_button type="submit"}
      {carto_button type='close' onclick="close_box()"}
   </div>
</form>
{/if}
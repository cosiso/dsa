<form name="frm_weapons" id="frm_weapons">
   {html_hidden name='stage' value='update'}
   {html_hidden name='id' value=$id}
   <label for="name">Name</label>
   {html_text name='name' value=$name|escape style='width: 35em'}
   <label for='kampftechnik'>Kamftechnik</label>
   <select name="kampftechnik" id="kampftechnik" style="width: 40em"></select>
   <table cellpadding="0" cellspacing="5" border="0">
      <tr>
         <td>
            <label for="tp">TP</label>
            {html_text name='tp' value=$tp|escape style='width: 5em'}
         </td>
         <td>
            <label for="tpkk">TP/KK</label>
            {html_text name='tpkk' value=$tpkk|escape style='width: 5em'}
         </td>
      </tr>
      <tr>
         <td>
            <label for="gewicht">Gewicht</label>
            {html_text name='gewicht' value=$gewicht style='width: 5em'} Unzia
         </td>
         <td>
            <label for="lange">Länge</label>
            {html_text name='lange' value=$lange style='width: 5em'} centimeter<br />
         </td>
      </tr>
      <tr>
         <td>
            <label for="ini">INI</label>
            {html_text name='ini' value=$ini style='width: 5em'}
         </td>
         <td>
            <label for="preis">Preis</label>
            {html_text name='preis' value=$preis style='width: 5em'} Argentaler
         </td>
      </tr>
      <tr>
         <td>
            <label for="wm">WM</label>
            {html_text name='wm' value=$wm|escape style='width: 5em'}
         </td>
         <td>
            <label for="dk">DK</label>
            {html_text name='dk' value=$dk|escape style='width: 5em'}
         </td>
      </tr>
   </table>
   <label for="note">Note</label>
   {html_textarea name="note" value=$note style="width: 40em; height: 8em"}
   <div class="button_bar">
      {carto_button type="submit"}
      {carto_button type='close' onclick="close_box()"}
   </div>
</form>
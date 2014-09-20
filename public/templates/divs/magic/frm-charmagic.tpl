{if $error}
   <script type="text/javascript">
      alertify.alert("{$error}");
      $('#popup').hide();
   </script>
{else}
{custom_form name='frm-charmagic'}
   {custom_hidden name='id' value=$id}
   {custom_hidden name='character_id' value=$character_id}
   {custom_text name='name' value=$name style='width: 200px' label=true disabled=true}<br>
   <label for='quelle'>Quelle</label>
   {html_options name='quelle' options=$quellen selected=$quelle_id style='width: 200px'}<br>
   <label for="tradition">Tradition</label>
   {html_options name='tradition' options=$traditions selected=$tradition style='width: 200px'}<br>
   <label for="beschworung">Spell/Summon</label>
   {html_options name='beschworung' options=$beschworungs selected=$beschworung style='width: 200px'}<br>
   <label for="wesen">Type of summoning</label>
   {html_options name='wesen' options=$wesens selected=$wesen style='width: 200px'}<br>
   {custom_text name='skt' value=$skt style='width: 45px' label='SKT'}<br>
   {custom_text name='value' value=$value style='width: 45px' label=true}<br>
   <div class="button_bar">
      {custom_button type='submit'}
      {custom_button type='close-popup'}
   </div>
{/custom_form}
{/if}
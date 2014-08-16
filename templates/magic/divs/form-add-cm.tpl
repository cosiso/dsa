{if $error}
   <script type="text/javascript">
      alertify.alert('{$error}');
      $('#popup').hide();
   </script>
{else}
{custom_form name='frm-edit-cm'}
   {custom_hidden name='stage' value='edit-cm'}
   {custom_hidden name='id' value=$id}
   {custom_hidden name='cm_id' value=$cm_id|default:0}
   <label for="quelle">Quelle</label>
   {html_options name='quelle' id='quelle' options=$quellen style='width: 200px'}<br>
   <label>Tradition</label>
   {html_radios name='tradition' id='tradition' options=$traditions selected=$tradition|default:0 labels=false}<br>
   <label>Beschwörung</label>
   {html_radios name='beschworung' id='beschworung' options=$beschworungen selected=$beschworing|default:0 labels=false}<br>
   <label>Type</label>
   {html_radios name='type' id='type' options=$wesens selected=$wesen|default:2 labels=false}<br>
   {custom_text name='skt' value=$skt style='width: 40px' label='SKT'}<br>
   <br>
   <div class="button_var">
      {custom_button type='submit'}
      {custom_button type='close' onclick="$('#popup').hide()"}
   </div>
{/custom_form}
{/if}
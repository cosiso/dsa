{if $error}
   <script type="text/javascript">
      alertify.alert('{$error}');
      $('#popup').hide();
   </script>
{else}
<form name="talente" id="talente">
   {html_hidden name='stage' value='edit'}
   {html_hidden name='talent_id' value=$talent_id}
   {html_hidden name='category_id' value=$category_id}
   <label>Name:</label>
   {html_text name='name' style='width: 10em' value=$name}<br />
   <label>Eigenschaft 1</label>
   {html_options name='eigenschaft1' options=$traits selected=$eigenschaft1}
   <label>Eigenschaft 2</label>
   {html_options name='eigenschaft2' options=$traits selected=$eigenschaft2}
   <label>Eigenschaft 3</label>
   {html_options name='eigenschaft3' options=$traits selected=$eigenschaft3}
   <label>SKT</label>
   {html_text name='skt' style='width: 2em' value=$skt}
   <label>BE</label>
   {html_text name='be' style='width 5em' value=$be}
   <label>Komp.</label>
   {html_text name='komp' style='width: 5em' value=$komp}
   <div class="button_bar">
      {carto_button type='submit'}
      {carto_button type='close' onclick="$('#popup').slideUp()"}
   </div>
</form>
{/if}
{if $error}
<script type="text/javascript">
   alertify.alert('{$error}');
   $('#popup').hide();
</script>
{else}
   {custom_form name="frm_kt_add"}
      {custom_hidden name='stage' value='add'}
      {custom_hidden name='char_id' value=$char_id}
      <label for="technik">Kampftechnik:</label>
      {html_options name='technik' options=$techniken}<br>
      <div class="button_bar">
         {custom_button type='submit'}
         {custom_button type='reset' onclick="$('#popup').hide()"}
      </div>
   {/custom_form}
{/if}
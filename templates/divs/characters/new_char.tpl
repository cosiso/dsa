{if $error}
<script type="text/javascript">
   alertify.alert($error);
</script>
{else}
<h4>Add character</h4>
<form id="new_char">
   <input type="hidden" name="stage" value="new_char">
   <label for="name">Name</label>
   <input type="text" name="name" id="name" style="width: 15em" value="New...">
   <div style="padding-top: 5px">
      <input type="submit" class="menu-button-submit" value="save">
      <input type="button" class="menu-button-reset" value="Cancel" onclick="$('#popup').hide()">
   </div>
</form>
{/if}
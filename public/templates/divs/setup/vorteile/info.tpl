{if $error}
<script type="text/javascript">
   alertify.alert('{$error}');
   $('#popup').hide();
</script>
{else}
{$info|escape|nl2br}<br><br>
<div class="button-bar">
   {custom_button type='reset' onclick="$('#popup').hide()"}
</div>
{/if}
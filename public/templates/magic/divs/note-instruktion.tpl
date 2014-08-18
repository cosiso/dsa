{if $error}
   <script type="text/javascript">
      alertify.alert('{$error}');
      $('#popup').hide();
   </script>
{else}
<h4>Quelle {$name|escape}:</h4>
{$desc|escape|nl2br|default:'No description given'}
<div class="button_bar">
   {custom_button type='close' onclick="$('#popup').hide()"}
</div>
{/if}
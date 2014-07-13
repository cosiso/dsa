{if $error}
   <script type="text/javascript">
      alertify.alert('{$error}');
      $('#popup').hide();
   </script>
{else}
   character values and so
   BASE: {$base}
   MOD: {$mod}
   BOUGHT: {$bought}
{/if}

{if $error}
   <script type="text/javascript">
      alertify.alert('{$error}');
      $('#popup').close();
   </script>
{else}
<div id="close" style="border-bottom: 1px dotted #2a6464">
   <span onclick="$('#popup').hide()">
      close <img src="images/action_delete.png" alt="close" />
   </span>
</div>
<div id="text">{$description|escape|nl2br}</div>
<div id="close" style="border-top: 1px dotted #2a6464">
   <span onclick="$('#popup').hide()">
      close <img src="images/action_delete.png" alt="close" />
   </span>
</div>
{/if}
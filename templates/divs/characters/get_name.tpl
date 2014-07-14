<form id="rename">
   <input type="hidden" id="id" value="{$id}">
   <input type="text" id="name" value="{$name|escape}" style="width: 16em"><br>
   <div style="padding-top: 5px">
      <input type="submit" class="menu-button-submit" value="OK">
      <input type="button" class="menu-button-reset" value="Cancel" onclick="$('#popup').hide()">
   </div>
</form>
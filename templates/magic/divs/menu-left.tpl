<div id="div_menu_left" class="caption_left" style="width: 200px; float: left; height: 100%">
   {if $selected == 'characters' or $selected == ''}
      <div class="selected_menu">Characters</div>
   {else}
      <div><a href="magic.php">Characters</a></div>
   {/if}
   Stuff to do
   <hr>
   {if $selected == 'setup'}
      <div class="selected_menu">Setup</div>
   {else}
      <div><a href="magic_setup.php">Setup</a></div>
   {/if}
</div>

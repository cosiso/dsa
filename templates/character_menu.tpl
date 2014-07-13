<div id="div_menu_left" class="caption_left" style="width: 200px; float: left; height: 100%">
   {if $selected == 'main'}
      <div class="selected_menu">Heldendokument</div>
   {else}
      <div><a href="characters.php">Heldendokument</a></div>
   {/if}
   {if $selected == 'combat'}
     <div class="selected_menu">Combat</div>
   {else}
      <div><a href="combat.php">Combat</a></div>
   {/if}
   {if $selected == 'inventory'}
      <div class="selected_menu">Inventory</div>
   {else}
      <div><a href="inventory.php">Inventory</a></div>
   {/if}
</div>

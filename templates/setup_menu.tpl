<div id="div_menu_left" class="caption_left" style="width: 200px; float: left">
   {if $selected_category eq 'Eigenschaften'}
      <div class="selected_menu">Eigenschaften</div>
   {else}
      <div><a href="setup.php">Eigenschaften</a></div>
   {/if}
   {if $selected_category == 'Talenten'}
      <div class="selected_menu">Talente</div>
      <ol class="sub-menu" id="sub-menu-talenten">
         {if $cat_id}
            <li><a href="setup_talenten.php">Categories</a></li>
         {/if}
         {section name=idx loop=$categories}
            <li><a href="setup_category.php?cat_id={$categories[idx].id}">{$categories[idx].name|escape}</a></li>
         {/section}
      </ol>
   {else}
      <div><a href="setup_talenten.php">Talente</a></div>
   {/if}
   {if $selected_category eq 'Vorteile'}
      <div class="selected_menu">Vor- &amp; Nachteile</div>
   {else}
      <div><a href="setup_vorteile.php">Vor- &amp; Nachteile</a></div>
   {/if}
   {if $selected_category == 'Kampftechniken'}
      <div class="selected_menu">Kampftechniken</div>
   {else}
      <div><a href="setup_kampftechniken.php">Kampftechniken</a></div>
   {/if}
   {if $selected_category == 'Weapons'}
      <div class="selected_menu">Weapons</div>
   {else}
      <div><a href="setup_weapons.php">Weapons</a></div>
   {/if}
   {if $selected_category == 'Snderfertigkeiten'}
      <div class="selected_menu">Sonderfertigkeiten</div>
   {else}
      <div><a href="sonderfertigkeiten.php">Sonderfertigkeiten</a></div>
   {/if}
</div>

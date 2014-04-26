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
</div>

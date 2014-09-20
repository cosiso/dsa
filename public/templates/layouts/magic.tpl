{extends file="base.tpl"}
{block name='title'}DSA - Magic{/block}
{block name="menu_left"}
   {if $selected == 'characters' or $selected == ''}
      <div class="selected_menu">Characters</div>
   {else}
      <div><a href="magic.php">Characters</a></div>
   {/if}
   {if $selected == 'spells'}
      <div class="selected_menu">Spells</div>
   {else}
      <div><a href="#" onclick="alert('ToDo')">Spells</a></div>
   {/if}
   {if $selected == 'creatures'}
      <div class="selected_menu">Creatures</div>
   {else}
      <div><a href="creatures">Creatures</a></div>
   {/if}
   <hr>
   {if $selected == 'setup'}
      <div class="selected_menu">Setup</div>
   {else}
      <div><a href="/magic/setup">Setup</a></div>
   {/if}
{/block}
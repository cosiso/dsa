<div id="div_menu_left" class="caption_left" style="width: 200px; float: left; height: 100%">
   {if $selected == 'main'}
      <div class="selected_menu">Heldendokument</div>
      <ol class="sub-menu" id="sub-menu-helden">
         {section name="idx" loop=$characters}
            <li id="li-char-{$characters[idx].id}" onclick="select_char({$characters[idx].id})"><a href="#">{$characters[idx].name|escape}</a></li>
         {/section}
      </ol>
      <br />
      <a id="btn_add_character" class="link-add" href="#" onclick="ask_new_character()">Add character</a><br />
      <br />
   {else}
      <div><a href="characters.php">Heldendokument</a></div>
   {/if}
   {if $selected == 'combat'}
     <div class="selected_menu">Combat</div>
   {else}
      <div><a href="combat.php">Combat</a></div>
   {/if}
</div>

<div style="float: left; padding-right: 10px; max-width: 325px">
   <h4>Vorteile</h4>
   {section name='idx' loop=$chars}
      <b>{$chars[idx].name|escape}</b><br>
      <span id="vorteile-{$chars[idx].id}">
         {foreach $chars[idx].vorteile as $key=>$item}
            <span id="{$key}" class="vorteil" onclick="show_vorteil(this)">
               {if ! $item@first} - {/if}
               {$item|escape}
            </span>
         {/foreach}
      </span>
      <br><br>
   {/section}
   <br>
   <a href="#" class="link-add" onclick="fn_add_vorteil()">Add vorteil</a><br>
</div>
<div style="float: left; max-width: 325px">
   <h4>Nachteile</h4>
   {section name='idx' loop=$chars}
      <b>{$chars[idx].name|escape}</b><br>
      <span id="nachteile-{$chars[idx].id}">
         {foreach $chars[idx].nachteile as $key=>$item}
            <span id="{$key}" class="vorteil" onclick="show_vorteil(this)">
               {if ! $item@first} - {/if}
               {$item|escape}
            </span>
         {/foreach}
      </span>
      <br><br>
   {/section}
   <br>
   <a href="#" class="link-add" onclick="fn_add_nachteil()">Add nachteil</a><br>
</div>
<br clear="all">
<br>
<hr>
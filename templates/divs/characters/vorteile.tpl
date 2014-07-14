<div style="float: left; padding-right: 10px;">
   <h4>Vorteile</h4>
   {section name='idx' loop=$chars}
      <b>{$chars[idx].name|escape}</b><br>
      <span id="vorteile-{$chars[idx].id}">
         {foreach $chars[idx].vorteile as $key=>$item}
            <span id="{$key}" class="vorteil" onclick="show_vorteil(this)">
               {$item|escape}
            </span>
            {if ! $item@last} - {/if}
         {/foreach}
      </span>
      <br><br>
   {/section}
</div>
<div style="float: left">
   <h4>Nachteile</h4>
   {section name='idx' loop=$chars}
      <b>{$chars[idx].name|escape}</b><br>
      <span id="nachteile-{$chars[idx].id}">
         {foreach $chars[idx].nachteile as $key=>$item}
            <span id="{$key}" class="vorteil" onclick="show_vorteil(this)">
               {$item|escape}
            </span>
            {if ! $item@last} - {/if}
         {/foreach}
      </span>
      <br><br>
   {/section}
</div>
<br clear="all">
<hr>
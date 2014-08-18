<h4>Weapons</h4>
<table id="weapons_{$char_id}">
   <thead>
      <tr>
         <th>Weapon</th>
         <th>TP</th>
         <th>TP/KK</th>
         <th>INI</th>
         <th>WM</th>
         <th>BF</th>
         <th>&nbsp;</th>
      </tr>
   </thead>
   <tbody>
      {section name=idx loop=$weapons}
         <tr id="{$weapons[idx].id}">
            <td id="name">{$weapons[idx].name|escape}</td>
            <td id="tp">{$weapons[idx].tp}</td>
            <td id="tpkk">{$weapons[idx].tpkk|escape}</td>
            <td id="ini">{$weapons[idx].ini}</td>
            <td id="wm">{$weapons[idx].at|default:'0'}/{$weapons[idx].pa|default:'0'}</td>
            <td id="bf">{$weapons[idx].bf}</td>
            <td>
               <span id="note" class="link-info">note</span>
               | <span id="edit" class="link-edit">edit</span>
               | <span id="remove" class="link-cancel" onclick="remove_weapon({$weapons[idx].id})">remove</span>
            </td>
         </tr>
      {/section}
   </tbody>
</table><br />
<span id="btn_add_weapon_{$char_id}" class="link-add" href="#">Add weapon</span><br />

<h4>Kleidung</h4>

<h4>Ausrüstung</h4>

<h4>Proviant/Tränke</h4>

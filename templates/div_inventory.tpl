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
               <a id="note" href="#" class="link-info">note</a>
               | <a id="edit" href="#" class="link-edit">edit</a>
               | <a id="remove" href="#" class="link-cancel" onclick="remove_weapon({$weapons[idx].id})">remove</a>
            </td>
         </tr>
      {/section}
   </tbody>
</table><br />
<a id="btn_add_weapon_{$char_id}" class="link-add" href="#">Add weapon</a><br />

<h4>Kleidung</h4>

<h4>Ausrüstung</h4>

<h4>Proviant/Tränke</h4>
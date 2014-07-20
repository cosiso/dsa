<div id="value-bar" class="value-bar"></div>
<h4>Armed</h4>
<table id="armed">
   <thead>
      <tr>
         <th>Weapon</th>
         <th>Kampftechnik</th>
         <th>TP/KK</th>
         <th>DK</th>
         <th>INI</th>
         <th>AT</th>
         <th>PA</th>
         <th>TP</th>
         <th>BF</th>
      </tr>
   </thead>
   <tbody class="hover">
      {section name=idx loop=$armed}
         <tr>
            <td>{$armed[idx].name|escape}</td>
            <td>{$armed[idx].technik|escape}</td>
            <td>{$armed[idx].tpkk|escape}</td>
            <td>{$armed[idx].dk|escape}</td>
            <td onclick="rollIni(this)">
               {$armed[idx].ini}
               <img src="images/dice-red-16.png" border="0" />
            </td>
            <td onclick="rollATorPA(this, true)">
               {$armed[idx].at}
               <img src="images/dice-red-16.png" border="0" />
            </td>
            <td onclick="rollATorPA(this, false)">
               {$armed[idx].pa}
               <img src="images/dice-red-16.png" border="0" />
            </td>
            <td onclick="rollTP(this)">
               {$armed[idx].tp|escape}
               <img src="images/dice-red-16.png" border="0" />
            </td>
            <td>{$armed[idx].bf}</td>
         </tr>
      {sectionelse}
         <tr><td colspan="9">Character has no usable weapons</td></tr>
      {/section}
   </tbody>
</table>
<h4>Unarmed</h4>
<table id="table_unarmed">
   <thead>
      <th>Kampftechnik</th>
      <th>TP/KK</th>
      <th>INI</th>
      <th>AT</th>
      <th>PA</th>
      <th>TP (A)</th>
      <tbody class="hover">
         {section name=idx loop=$unarmed}
            <tr>
               <td>{$unarmed[idx].kampftechnik|escape}</td>
               <td>{$unarmed[idx].tpkk}</td>
               <td onclick="rollIni(this)">
                  {$unarmed[idx].ini}
                  <img src="images/dice-red-16.png" border="0" />
               </td>
               <td onclick="rollATorPA(this, true)">
                  {$unarmed[idx].at}
                  <img src="images/dice-red-16.png" border="0" />
               </td>
               <td onclick="rollATorPA(this, false)">
                  {$unarmed[idx].pa}
                  <img src="images/dice-red-16.png" border="0" />
               </td>
               <td onclick="rollTP(this)">
                  {$unarmed[idx].tp}
                  <img src="images/dice-red-16.png" border="0" />
               </td>
            </tr>
         {sectionelse}
            <tr><td colspan="6">No unarmed kampftechnik defined</td></tr>
         {/section}
      </tbody>
   </thead>
</table>
<h4>Sonderfertigkeiten</h4>
<table id="sf">
   <thead>
      <tr>
         <th>Name</th>
         <th>Effect</th>
         <th>&nbsp;</th>
      </tr>
   </thead>
   <tbody>
      {section name=idx loop=$sf}
         <tr id="{$sf[idx].id}">
            <td>{$sf[idx].name|escape}</td>
            <td>{$sf[idx].effect|escape}</td>
            <td>
               <a href="#" onclick="sf_info({$sf[idx].kampf_sf_id})" class="link-info">note</a>
               | <a href="#" onclick="sf_remove({$sf[idx].id})" class="link-cancel">remove</a>
            </td>
         </tr>
      {/section}
   </tbody>
</table>
<br />
<a id="btn_add_sf" href="#" class="link-add" onclick="add_sf({$char_id})">Add kampfsonderfertigkeit</a>
<a href="#" class="link-reload" onclick="reload_char({$char_id})">Reload</a>

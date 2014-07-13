<h4>Basiswerte</h4>
<table id="basiswerte">
   <thead>
      <tr>
         <th style="background-color: transparent"></th>
         <th>LE</th>
         <th>AU</th>
         <th>AE</th>
         <th>MR</th>
         <th>INI</th>
         <th>AT</th>
         <th>PA</th>
         <th>FK</th>
         <th></th>
      </tr>
   </thead>
   <tbody class="hover">
      {section name='idx' loop=$chars}
         <tr id="{$chars[idx].char_id}" style="text-align: right">
            <th style="text-align: left">
               <span onclick="rename(this)" style="cursor: pointer">
                  <img src="images/page_white_paint.png" border="0" alt="rename">
               </span>
               <span id="name-{$chars[idx].char_id}">{$chars[idx].name|escape}</span>
            </th>
            <td>
               <span id="le-{$chars[idx].char_id}">{$chars[idx].tot_le}</span>
               <span onclick="edit_eigenschaft(this, 'Lebenspunkte')" style="cursor: pointer">
                  <img src="images/page_white_paint.png" border="0" alt="edit">
               </span>
            </td>
            <td>
               <span id="au-{$chars[idx].char_id}">{$chars[idx].tot_au}</span>
               <span onclick="edit_eigenschaft(this, 'Ausdauer')" style="cursor: pointer">
                  <img src="images/page_white_paint.png" border="0" alt="edit">
               </span>
            </td>
            <td>
               <span id="ae-{$chars[idx].char_id}">{$chars[idx].tot_ae}</span>
               <span onclick="edit_eigenschaft(this, 'Astralenergie')" style="cursor: pointer">
                  <img src="images/page_white_paint.png" border="0" alt="edit">
               </span>
            </td>
            <td>
               <span id="mr-{$chars[idx].char_id}">{$chars[idx].tot_mr}</span>
               <span onclick="edit_eigenschaft(this, 'Magieresistenz')" style="cursor: pointer">
                  <img src="images/page_white_paint.png" border="0" alt="edit">
               </span>
            </td>
            <td>
               <span id="ini-{$chars[idx].char_id}">{$chars[idx].tot_ini}</span>
               <span onclick="edit_eigenschaft(this, 'Initiativ')" style="cursor: pointer">
                  <img src="images/page_white_paint.png" border="0" alt="edit">
               </span>
            </td>
            <td>
               <span id="at-{$chars[idx].char_id}">{$chars[idx].tot_at}</span>
               <span onclick="edit_eigenschaft(this, 'Attack')" style="cursor: pointer">
                  <img src="images/page_white_paint.png" border="0" alt="edit">
               </span>
            </td>
            <td>
               <span id="pa-{$chars[idx].char_id}">{$chars[idx].tot_pa}</span>
               <span onclick="edit_eigenschaft(this, 'Parry')" style="cursor: pointer">
                  <img src="images/page_white_paint.png" border="0" alt="edit">
               </span>
            </td>
            <td>
               <span id="fk-{$chars[idx].char_id}">{$chars[idx].tot_fk}</span>
               <span onclick="edit_eigenschaft(this, 'Fernkampf')" style="cursor: pointer">
                  <img src="images/page_white_paint.png" border="0" alt="edit">
               </span>
            </td>
            <td>
               <a href="#" class="link-cancel" onclick="remove_char(this)">remove</a>
            </td>
         </tr>
      {/section}
   </tbody>
</table>
<br>
<h4>Eigenschafte</h4>
<table id="eigenschafte">
   <thead>
      <tr>
         <th style="background-color: transparent"></th>
         <th>MU</th>
         <th>KL</th>
         <th>IN</th>
         <th>CH</th>
         <th>FF</th>
         <th>GE</th>
         <th>KO</th>
         <th>KK</th>
         <th>GS</th>
      </tr>
   </thead>
   <tbody class="hover">
      {section name='idx' loop=$traits}
         <tr id="$traits[idx].id}" style="text-align: right">
            <th style="text-align: left">{$traits[idx].name|escape}</th>
            <td>
               {$traits[idx].mu}
               <span onclick="roll(this, 'Mut')" style="cursor: pointer">
                  <img src="images/dice-red-16.png" border="0" alt="roll">
               </span>
            </td>
            <td>
               {$traits[idx].kl}
               <span onclick="roll(this, 'Klugheit')" style="cursor: pointer">
                  <img src="images/dice-red-16.png" border="0" alt="roll">
               </span>
            </td>
            <td>
               {$traits[idx].in}
               <span onclick="roll(this, 'Intuition')" style="cursor: pointer">
                  <img src="images/dice-red-16.png" border="0" alt="roll">
               </span>
            </td>
            <td>
               {$traits[idx].ch}
               <span onclick="roll(this, 'Charisma')" style="cursor: pointer">
                  <img src="images/dice-red-16.png" border="0" alt="roll">
               </span>
            </td>
            <td>
               {$traits[idx].ff}
               <span onclick="roll(this, 'Fingerfertigkeit')" style="cursor: pointer">
                  <img src="images/dice-red-16.png" border="0" alt="roll">
               </span>
            </td>
            <td>
               {$traits[idx].ge}
               <span onclick="roll(this, 'Gewandheit')" style="cursor: pointer">
                  <img src="images/dice-red-16.png" border="0" alt="roll">
               </span>
            </td>
            <td>
               {$traits[idx].ko}
               <span onclick="roll(this, 'Konstitution')" style="cursor: pointer">
                  <img src="images/dice-red-16.png" border="0" alt="roll">
               </span>
            </td>
            <td>
               {$traits[idx].kk}
               <span onclick="roll(this, 'Körperkraft')" style="cursor: pointer">
                  <img src="images/dice-red-16.png" border="0" alt="roll">
               </span>
            </td>
            <td>--</td>
         </tr>
      {/section}
   </tbody>
</table>
<br>
<a class="link-add" href="#" onclick="ask_new_character()">Add character</a><br>
<br>
<hr>
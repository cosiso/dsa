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
         <tr id="{$traits[idx].id}" style="text-align: right">
            <th style="text-align: left">{$traits[idx].name|escape}</th>
            <td>
               <span id="mu-{$traits[idx].id}">{$traits[idx].mu}</span>
               <span onclick="roll(this, 'Mut')" style="cursor: pointer">
                  <img src="images/dice-red-16.png" border="0" alt="roll">
               </span>
               <span onclick="edit_eigenschaft(this)" style="cursor: pointer">
                  <img src="images/page_white_paint.png" border="0" alt="edit">
               </span>
            </td>
            <td>
               <span id="kl-{$traits[idx].id}">{$traits[idx].kl}</span>
               <span onclick="roll(this, 'Klugheit')" style="cursor: pointer">
                  <img src="images/dice-red-16.png" border="0" alt="roll">
               </span>
               <span onclick="edit_eigenschaft(this)" style="cursor: pointer">
                  <img src="images/page_white_paint.png" border="0" alt="edit">
               </span>
            </td>
            <td>
               <span id="in-{$traits[idx].id}">{$traits[idx].in}</span>
               <span onclick="roll(this, 'Intuition')" style="cursor: pointer">
                  <img src="images/dice-red-16.png" border="0" alt="roll">
               </span>
               <span onclick="edit_eigenschaft(this)" style="cursor: pointer">
                  <img src="images/page_white_paint.png" border="0" alt="edit">
               </span>
            </td>
            <td>
               <span id="ch-{$traits[idx].id}">{$traits[idx].ch}</span>
               <span onclick="roll(this, 'Charisma')" style="cursor: pointer">
                  <img src="images/dice-red-16.png" border="0" alt="roll">
               </span>
               <span onclick="edit_eigenschaft(this)" style="cursor: pointer">
                  <img src="images/page_white_paint.png" border="0" alt="edit">
               </span>
            </td>
            <td>
               <span id="ff-{$traits[idx].id}">{$traits[idx].ff}</span>
               <span onclick="roll(this, 'Fingerfertigkeit')" style="cursor: pointer">
                  <img src="images/dice-red-16.png" border="0" alt="roll">
               </span>
               <span onclick="edit_eigenschaft(this)" style="cursor: pointer">
                  <img src="images/page_white_paint.png" border="0" alt="edit">
               </span>
            </td>
            <td>
               <span id="ge-{$traits[idx].id}">{$traits[idx].ge}</span>
               <span onclick="roll(this, 'Gewandheit')" style="cursor: pointer">
                  <img src="images/dice-red-16.png" border="0" alt="roll">
               </span>
               <span onclick="edit_eigenschaft(this)" style="cursor: pointer">
                  <img src="images/page_white_paint.png" border="0" alt="edit">
               </span>
            </td>
            <td>
               <span id="ko-{$traits[idx].id}">{$traits[idx].ko}</span>
               <span onclick="roll(this, 'Konstitution')" style="cursor: pointer">
                  <img src="images/dice-red-16.png" border="0" alt="roll">
               </span>
               <span onclick="edit_eigenschaft(this)" style="cursor: pointer">
                  <img src="images/page_white_paint.png" border="0" alt="edit">
               </span>
            </td>
            <td>
               <span id="kk-{$traits[idx].id}">{$traits[idx].kk}</span>
               <span onclick="roll(this, 'Körperkraft')" style="cursor: pointer">
                  <img src="images/dice-red-16.png" border="0" alt="roll">
               </span>
               <span onclick="edit_eigenschaft(this)" style="cursor: pointer">
                  <img src="images/page_white_paint.png" border="0" alt="edit">
               </span>
            </td>
            <td>--</td>
         </tr>
      {/section}
   </tbody>
</table>
<br>
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
                  <img src="images/rename.png" border="0" alt="rename">
               </span>
               <span onclick="char_edit(this)" style="cursor: pointer">
                  <img src="images/page_white_paint.png" border="0" alt="edit char">
               </span>
               <span id="name-{$chars[idx].char_id}">{$chars[idx].name|escape}</span>
            </th>
            <td>
               <span id="le-{$chars[idx].char_id}">{$chars[idx].tot_le}</span>
               <span onclick="edit_basiswert(this, 'Lebenspunkte')" style="cursor: pointer">
                  <img src="images/page_white_paint.png" border="0" alt="edit">
               </span>
            </td>
            <td>
               <span id="au-{$chars[idx].char_id}">{$chars[idx].tot_au}</span>
               <span onclick="edit_basiswert(this, 'Ausdauer')" style="cursor: pointer">
                  <img src="images/page_white_paint.png" border="0" alt="edit">
               </span>
            </td>
            <td>
               <span id="ae-{$chars[idx].char_id}">{$chars[idx].tot_ae}</span>
               <span onclick="edit_basiswert(this, 'Astralenergie')" style="cursor: pointer">
                  <img src="images/page_white_paint.png" border="0" alt="edit">
               </span>
            </td>
            <td>
               <span id="mr-{$chars[idx].char_id}">{$chars[idx].tot_mr}</span>
               <span onclick="edit_basiswert(this, 'Magieresistenz')" style="cursor: pointer">
                  <img src="images/page_white_paint.png" border="0" alt="edit">
               </span>
            </td>
            <td>
               <span id="ini-{$chars[idx].char_id}">{$chars[idx].tot_ini}</span>
               <span onclick="edit_basiswert(this, 'Initiativ')" style="cursor: pointer">
                  <img src="images/page_white_paint.png" border="0" alt="edit">
               </span>
            </td>
            <td>
               <span id="at-{$chars[idx].char_id}">{$chars[idx].tot_at}</span>
               <span onclick="edit_basiswert(this, 'Attack')" style="cursor: pointer">
                  <img src="images/page_white_paint.png" border="0" alt="edit">
               </span>
            </td>
            <td>
               <span id="pa-{$chars[idx].char_id}">{$chars[idx].tot_pa}</span>
               <span onclick="edit_basiswert(this, 'Parry')" style="cursor: pointer">
                  <img src="images/page_white_paint.png" border="0" alt="edit">
               </span>
            </td>
            <td>
               <span id="fk-{$chars[idx].char_id}">{$chars[idx].tot_fk}</span>
               <span onclick="edit_basiswert(this, 'Fernkampf')" style="cursor: pointer">
                  <img src="images/page_white_paint.png" border="0" alt="edit">
               </span>
            </td>
            <td>
               <span class="link-cancel" onclick="remove_char(this)">remove</span>
            </td>
         </tr>
      {/section}
   </tbody>
</table>
<br>
<span class="link-add" onclick="ask_new_character()">Add character</span><br>
<br>
<hr>

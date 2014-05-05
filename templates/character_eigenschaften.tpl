<div id='div_eigenschaften' style="margin-left: 0px">
   {section name=idx loop=$eigenschaften}
      {assign var=name value=$eigenschaften[idx].name}
      <label>{$name|capitalize|escape}</label>
      {assign var=lname value=$name|lower}
      {assign var=total value=`$values[$name].base+$values[$name].zugekauft+$values[$name].modifier`}
      <b>Current</b> {html_text name=$lname class='show_disabled' style='width: 40px' disabled=true value=$total}
      <b>Base</b> {html_text name=$lname|cat:'_base' style='width: 25px' value=`$values[$name].base`}
      <b>Bought</b> {html_text name=$lname|cat:'_zugekauft' style='width: 25px' value=$values[$name].zugekauft}
      <b>Modifier</b> {html_text name=$lname|cat:'_modifier' style='width: 25px' value=$values[$name].modifier}
      {carto_spacer width=20}
      <span class="round-button" onclick="roll('{$lname}')">
         <img src="images/dice-red-16.png" border="0" alt="roll" />
         <img src="images/dice-red-16.png" border="0" alt="roll" />
         <img src="images/dice-red-16.png" border="0" alt="roll" />
      </span>
   {/section}
</div>
<hr>
<div id='div_basevalues'>
   <label>Lebenspunkte</label>
   <b>Current</b> {html_text name='lebenspunkte' style='width: 45px' class='show_disabled' disabled=true}
   <b>Lost</b> {html_text name='le_used' value=$le_used style='width: 25px'}
   <b>Base</b> {html_text name='le_base' class='show_disabled' style='width: 25px' disabled=true}
   <b>Modifier</b> {html_text name='le_mod' value=$le_mod style='width: 25px'}
   <b>Bought</b> {html_text name='le_bought' value=$le_bought style='width: 25px'}

   <label>Ausdauer</label>
   <b>Current</b> {html_text name='ausdauer' style='width: 45px' class='show_disabled' disabled=true}
   <b>Lost</b> {html_text name='au_used' value=$au_used style='width: 25px'}
   <b>Base</b> {html_text name='au_base' class='show_disabled' style='width: 25px' disabled=true}
   <b>Modifier</b> {html_text name='au_mod' value=$au_mod style='width: 25px'}
   <b>Bought</b> {html_text name='au_bought' value=$au_bought style='width: 25px'}

   <label>Astralenergie</label>
   <b>Current</b> {html_text name='astralenergie' style='width: 45px' class='show_disabled' disabled=true}
   <b>Lost</b> {html_text name='ae_used' value=$ae_used style='width: 25px'}
   <b>Base</b> {html_text name='ae_base' class='show_disabled' style='width: 25px' disabled=true}
   <b>Modifier</b> {html_text name='ae_mod' value=$ae_mod style='width: 25px'}
   <b>Bought</b> {html_text name='ae_bought' value=$ae_bought style='width: 25px'}
   {if $gefass}<span class="smallnote">Gefäß der Sterne</span>{/if}
   {html_hidden name='gefass' value=$gefass}

   <label>Magieresistenz</label>
   <b>Current</b> {html_text name='magieresistenz' style='width: 45px' class='show_disabled' disabled=true}
   <b>Lost</b> {html_text name='mr_used' value=$mr_used style='width: 25px'}
   <b>Base</b> {html_text name='mr_base' class='show_disabled' style='width: 25px' disabled=true}
   <b>Modifier</b> {html_text name='mr_mod' value=$mr_mod style='width: 25px'}
   <b>Bought</b> {html_text name='mr_bought' value=$mr_bought style='width: 25px'}

   <label>Initiativ</label>
   <b>Current</b> {html_text name='initiativ' style='width: 45px' class='show_disabled' disabled=true}
   <b>Base</b> {html_text name='ini_base' style='width: 25px' class='show_disabled' disabled=true}
   <b>Modifier</b> {html_text name='ini_mod' value=$ini_mod style='width: 25px'}
   {if $kampfgespur}<span class="smallnote">Kampfgespür</span>{/if}
   {if $kampfreflexe}<span class="smallnote">Kampfreflexe</span>{/if}
   {html_hidden name='kampfgespur' value=$kampfgespur}
   {html_hidden name='kampfreflexe' value=$kampfreflexe}
   <span class="round-button" onclick="roll('ini')">
      <img src="images/dice-red-16.png" border="0" alt="roll" />
      <img src="images/dice-red-16.png" border="0" alt="roll" />
      <img src="images/dice-red-16.png" border="0" alt="roll" />
   </span>

   <label>Attack</label>
   <b>Current</b> {html_text name='attack' style='width: 45px' class='show_disabled' disabled=true}
   <b>Base</b> {html_text name='at_base' style='width: 25px' class='show_disabled' disabled=true}
   <b>Modifier</b> {html_text name='at_mod' value=$at_mod style='width: 25px'}
</div>

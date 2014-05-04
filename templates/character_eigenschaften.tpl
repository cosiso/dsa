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
      <span style="cursor: pointer" onclick="roll('{$lname}')">
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
</div>

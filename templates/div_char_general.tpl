{carto_button value='General' onclick='display_general()' disabled=true class='menu-button-selected'}
{carto_button value='Talents' onclick='display_talents()'}
{carto_button value='Combat' onclick='display_combat()'}
{carto_button value='Gear' onclick='display_gear()'}
<hr style="color: #4682b4" />
{carto_form name='frm_char_general' style='width: 800px' onsubmit='return submit_general()'}
   {html_hidden name='id' value=$id}
   <legend>General values</legend>
   <label for="char_name">Name</label>
   {html_text name='char_name' value=$char_name|escape style='float: left'}
   <label for="gp_base">GP-Base</label>
   {html_text name='gp_base' value=$gp_base|escape}<br />
   <label for="race">Race</label>
   {html_text name='race' value=$race|escape style='float: left'}
   <label for='culture'>Culture</label>
   {html_text name='culture' value=$culture|escape}<br />
   <label for='profession'>Profession</label>
   {html_text name='profession' value=$profession|escape}<br />
   <legend>Appearance</legend>
   <label for="sex">Sex</label>
   {html_text name='sex' value=$sex|escape style='float:left'}
   <label for="age">Age</label>
   {html_text name='age' value=$age|escape}<br />
   <label for="height">Height</label>
   {html_text name='height' value=$height|escape style='float: left'}
   <label for="weight">Weight</label>
   {html_text name='weight' value=$weight|escape}<br />
   <br />
   {carto_button type='submit'}
   {carto_button type='reset'}
{/carto_form}

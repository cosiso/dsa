{custom_form name='frm_kampftechniken'}
   {custom_hidden name='stage' value='update'}
   {custom_hidden name='id' value=$id}
   {custom_text name='name' value=$name|escape label='Name'}
   {custom_text name='skt' value=$skt|escape style='width: 30px' label='Kostentabelle'}
   {custom_text name='be' value=$be|escape style='width: 30px' label='Behinderung'}
   {custom_checkbox name='unarmed' checked=$unarmed label='Unarmed'}
   <div class="button_bar">
      {custom_button type="submit"}
      {custom_button type='close' onclick="$('#popup').hide()"}
   </div>
{/custom_form}
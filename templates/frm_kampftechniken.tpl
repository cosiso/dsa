<form name="frm_kampftechniken" id="frm_kampftechniken">
   {html_hidden name='stage' value='update'}
   {html_hidden name='id' value=$id}
   <label for="name">Name</label>
   {html_text name='name' value=$name|escape}
   <label for="skt">Kostentabelle</label>
   {html_text name='skt' value=$skt|escape}
   <label for="be">Behinderung</label>
   {html_text name='be' value=$be|escape}
   <label for="unarmed">Unarmed</label>
   {html_checkbox name='unarmed' checked=$unarmed}
   <div class="button_bar">
      {carto_button type="submit"}
      {carto_button type='close' onclick="close_kt_box()"}
   </div>
</form>
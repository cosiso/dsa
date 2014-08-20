@if (!empty($error))
   <script type="text/javascript">
      alertify.alert("{{ $error }}");
      $('#popup').hide();
   </script>
@else
{{ Form::open(array('name' => 'frm-charmagic',
                    'id'   => 'frm-charmagic')) }}
   <label for="character">Character</label>
   {{ Form::select('character', $characters, $charmagic->character_id, array('style' => 'width: 200px')) }}<br>
   <label for="quelle">Quelle</label>
   {{ Form::select('quelle', $quellen, $charmagic->quelle_id, array('style' => 'width: 200px')) }}<br>
   <label for="tradition">Tradition</label>
   {{ Form::select('tradition', $charmagic->lst_tradition(), $charmagic->tradition, array('style' => 'width: 200px')) }}<br>
   <label for="beschworung">Spell/Summon</label>
   {{ Form::select('beschworung', $charmagic->lst_beschworung(), $charmagic->beschworung, array('style' => 'width: 200px')) }}<br>
   <label for="wesen">Type of summoning</label>
   {{ Form::select('wesen', $charmagic->lst_wesen(), $charmagic->wesen) }}<br>
   {{ HTML::custom_text(array('name'  => 'skt',
                              'value' => e($charmagic->skt),
                              'label' => 'SKT',
                              'style' => 'width: 45px')) }}<br>
   {{ HTML::custom_text(array('name'  => 'value',
                              'value' => e($charmagic->value),
                              'label' => true,
                              'style' => 'width: 45px')) }}<br>
   <div class="button_bar">
      {{ HTML::custom_button(array('type' => 'submit')) }}
      {{ HTML::custom_button(array('type' => 'close-popup')) }}
   </div>
{{ Form::close() }}
@endif
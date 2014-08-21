@if (!empty($error))
   <script type="text/javascript">
      alertify.alert("{{ $error }}");
      $('#popup').hide();
   </script>
@else
{{ Form::open(array('name' => 'frm-charmagic',
                    'id'   => 'frm-charmagic')) }}
   {{ HTML::custom_hidden(array('name' => 'id', 'value' => $charmagic->id)) }}
   {{ HTML::custom_hidden(array('name' => 'character_id', 'value' => $character->id)) }}
   {{ HTML::custom_text(array('name'     => 'name',
                              'value'    => $character->name,
                              'style'    => 'width: 200px',
                              'label'    => true,
                              'disabled' => true)) }}<br>
   {{ HTML::custom_select(array('name'     => 'quelle',
                                'output'   => $quellen,
                                'selected' => $charmagic->quelle_id,
                                'style'    => 'width: 200px',
                                'label'    => true)) }}<br>
   {{ HTML::custom_select(array('name'     => 'tradition',
                                'output'   => $charmagic->lst_tradition(),
                                'selected' => $charmagic->tradition,
                                'style'    => 'width: 200px',
                                'label'    => true)) }}<br>
   {{ HTML::custom_select(array('name'     => 'beschworung',
                                'output'   => $charmagic->lst_beschworung(),
                                'selected' => $charmagic->beschworung,
                                'style'    => 'width: 200px',
                                'label'    => 'Spell/Summon')) }}<br>
   {{ HTML::custom_select(array('name'     => 'wesen',
                                'output'   => $charmagic->lst_wesen(),
                                'selected' => $charmagic->wesen,
                                'style'    => 'width: 200px',
                                'label'    => 'Type of summoning')) }}<br>
   {{ HTML::custom_text(array('name'  => 'skt',
                              'value' => $charmagic->skt,
                              'label' => 'SKT',
                              'style' => 'width: 45px')) }}<br>
   {{ HTML::custom_text(array('name'  => 'value',
                              'value' => $charmagic->value,
                              'label' => true,
                              'style' => 'width: 45px')) }}<br>
   <div class="button_bar">
      {{ HTML::custom_button(array('type' => 'submit')) }}
      {{ HTML::custom_button(array('type' => 'close-popup')) }}
   </div>
{{ Form::close() }}
@endif
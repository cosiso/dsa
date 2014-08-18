@if (isset($error))
   <script type="text/javascript">
      alertify.alert('{$error}');
      $('#popup').hide();
   </script>
@else
{{ Form::open(array('name' => 'form-instruktion',
                    'id'   => 'form-instruktion')) }}
   {{ HTML::custom_text(array('name'        => 'name',
                              'value'       => $instruktion->name,
                              'style'       => 'width: 25em',
                              'placeholder' => 'Type a name',
                              'label'       => 'Name')) }}<br>
   {{ HTML::custom_textarea(array('name'        => 'desc',
                                  'value'       => htmlspecialchars($instruktion->description),
                                  'style'       => 'width: 400px; height: 250px',
                                  'placeholder' => 'Type a description',
                                  'label'       => 'Description')) }}<br>
   <div class="button_bar">
      {{ HTML::custom_button(array('type' => 'submit')) }}
      {{ HTML::custom_button(array('type' => 'close-popup')) }}
   </div>
{{ Form::close() }}
@endif

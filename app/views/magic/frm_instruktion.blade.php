@if (isset($error))
   <script type="text/javascript">
      alertify.alert('{{ $error }}');
      $('#popup').hide();
   </script>
@else
   {{ Form::open(array('name' => 'frm-instruktion',
                       'id'   => 'frm-instruktion')) }}
      <b>Add instruktion for</b> <h4 style="display: inline">{{{ $character->name }}}</h4><br>
      {{ HTML::custom_select(array('name'        => 'instruktion',
                                   'output'      => $character->available_instruktionen(),
                                   'placeholder' => 'Select an instruktion', )) }}
      <div class="button_bar">
         {{ HTML::custom_button(array('type' => 'submit')) }}
         {{ HTML::custom_button(array('type' => 'close-popup')) }}
      </div>
   {{ Form::close() }}
@endif
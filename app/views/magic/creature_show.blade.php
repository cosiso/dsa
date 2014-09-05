@if (! empty($error))
   <script type="text/javascript">
      alertify.alert('{{ $error }}');
      $('#popup').hide();
   </script>
@else
   <h4>Edit creature</h4>
   {{ Form::open(array('name' => 'frm-creature',
                       'id'   => 'frm-creature')) }}
      {{ HTML::custom_hidden(array('name'  => 'id',
                                   'value' => $creature->id)) }}
      {{ HTML::custom_text(array('name'  => 'name',
                                 'label' => 'Name',
                                 'style' => 'width: 225px',
                                 'value' => $creature->name,
                                 'placeholder' => 'Type a name')) }}<br>
      {{ HTML::custom_select(array('name'        => 'quelle',
                                   'output'      => $quellen,
                                   'selected'    => $creature->quelle_id,
                                   'placeholder' => 'Select a quelle',
                                   'style'       => 'width: 225px',
                                   'label'       => true)) }}<br>
      <div style="width: 300px">
         <div style="width: 150px; float: left">
            {{ HTML::custom_text(array('name'  => 'beschworung',
                                       'label' => 'Beschwörung',
                                       'value' => $creature->beschworung,
                                       'style' => 'width: 80px',
                                       'placeholder' => 'Enter value')) }}
         </div>
         <div style="width: 150px; float: left">
            {{ HTML::custom_text(array('name'  => 'beherrschung',
                                       'label' => true,
                                       'value' => $creature->beschworung,
                                       'style' => 'width: 80px',
                                       'placeholder' => 'Enter value')) }}
         </div>
         <br style="clear: both">
      </div>
      {{ HTML::custom_textarea(array('name'  => 'description',
                                     'value' => $creature->description,
                                     'label' => true,
                                     'style' => 'width: 400px; height: 300px')) }}<br>
      <div class="button_bar">
         {{ HTML::custom_button(array('type' => 'submit')) }}
         {{ HTML::custom_button(array('type' => 'close-popup')) }}
      </div>
   {{ Form::close() }}
@endif
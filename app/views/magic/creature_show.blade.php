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
                                 'label' => true,
                                 'style' => 'width: 225px',
                                 'value' => $creature->name,
                                 'placeholder' => 'Type a name')) }}<br>
      {{ HTML::custom_select(array('name'        => 'quelle',
                                   'output'      => $quellen,
                                   'selected'    => $creature->quelle_id,
                                   'placeholder' => 'Select a quelle',
                                   'style'       => 'width: 225px',
                                   'label'       => true)) }}<br>
      <table>
         <tr>
            <td>
               {{ HTML::custom_text(array('name'  => 'beschworung',
                                          'label' => 'Beschwörung',
                                          'value' => $creature->beschworung,
                                          'style' => 'width: 80px',
                                          'placeholder' => 'Enter value')) }}
            </td>
            <td>
               {{ HTML::custom_text(array('name'  => 'beherrschung',
                                          'label' => true,
                                          'value' => $creature->beschworung,
                                          'style' => 'width: 80px',
                                          'placeholder' => 'Enter value')) }}
            </td>
            <td></td>
         </tr>
         <tr>
            <td>
               {{ HTML::custom_text(array('name'  => 'le',
                                          'label' => 'LE',
                                          'value' => $creature->le,
                                          'style' => 'width: 80px',
                                          'placeholder' => 'Enter value')) }}
            </td>
            <td>
               {{ HTML::custom_text(array('name'  => 'ae',
                                          'label' => 'AE',
                                          'value' => $creature->ae,
                                          'style' => 'width: 80px',
                                          'placeholder' => 'Enter value')) }}
            </td>
            <td>
               {{ HTML::custom_text(array('name'  => 'rs',
                                          'label' => 'RS',
                                          'value' => $creature->rs,
                                          'style' => 'width: 80px',
                                          'placeholder' => 'Enter value')) }}
            </td>
         </tr>
         <tr>
            <td>
               {{ HTML::custom_text(array('name'  => 'ini',
                                          'label' => 'INI',
                                          'value' => $creature->ini,
                                          'style' => 'width: 80px',
                                          'placeholder' => 'Enter value')) }}
            </td>
            <td>
               {{ HTML::custom_text(array('name'  => 'gs',
                                          'label' => 'GS',
                                          'value' => $creature->gs,
                                          'style' => 'width: 80px',
                                          'placeholder' => 'Enter value')) }}
            </td>
            <td>
               {{ HTML::custom_text(array('name'  => 'mr',
                                          'label' => 'MR',
                                          'value' => $creature->mr,
                                          'style' => 'width: 80px',
                                          'placeholder' => 'Enter value')) }}
            </td>
         </tr>
         <tr>
            <td>
               {{ HTML::custom_text(array('name'  => 'gw',
                                          'label' => 'GW',
                                          'value' => $creature->gw,
                                          'style' => 'width: 80px',
                                          'placeholder' => 'Enter value')) }}
            </td>
            <td colspan="2"></td>
         </tr>
      </table><br>
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
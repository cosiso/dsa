@if (! empty($error))
   <script type="text/javascript">
      alertify.alert('{{ $error }}');
      $('#popup').hide();
   </script>
@else
   {{ Form::open(array('name' => 'frm-creature',
                       'id'   => 'frm-creature')) }}
      {{ HTML::custom_hidden(array('name'  => 'id',
                                   'value' => $creature->id)) }}
      <table>
         <tr>
            <td colspan="8">
               {{ HTML::custom_text(array('name'  => 'name',
                                          'label' => true,
                                          'style' => 'width: 250px',
                                          'value' => $creature->name,
                                          'placeholder' => 'Type a name')) }}
            </td>
         </tr>
         <tr>
            <td colspan="4">
               {{ HTML::custom_select(array('name'        => 'quelle',
                                            'output'      => $quellen,
                                            'selected'    => $creature->quelle_id,
                                            'placeholder' => 'Select a quelle',
                                            'style'       => 'width: 250px',
                                            'label'       => true)) }}
            </td>
            <td colspan="4">
               {{ HTML::custom_select(array('name'   => 'rank',
                                            'label'  => true,
                                            'output' => $creature->ranks,
                                            'selected' => $creature->rank,
                                            'style'  => 'width: 250px',
                                            'placeholder' => 'Select a rank')) }}
            </td>
         </tr>
         <tr>
            <td colspan="2">
               {{ HTML::custom_text(array('name'  => 'beschworung',
                                          'label' => 'Beschwörung',
                                          'value' => $creature->beschworung,
                                          'style' => 'width: 80px',
                                          'placeholder' => 'Enter value')) }}
            </td>
            <td colspan="6">
               {{ HTML::custom_text(array('name'  => 'beherrschung',
                                          'label' => true,
                                          'value' => $creature->beherrschung,
                                          'style' => 'width: 80px',
                                          'placeholder' => 'Enter value')) }}
            </td>
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
            <td>
               {{ HTML::custom_text(array('name'  => 'ini',
                                          'label' => 'INI',
                                          'value' => $creature->ini,
                                          'style' => 'width: 80px',
                                          'placeholder' => 'Enter value')) }}
            </td>
            <td>
               {{ HTML::custom_text(array('name'  => 'pa',
                                          'label' => 'PA',
                                          'value' => $creature->pa,
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
            <td>
               {{ HTML::custom_text(array('name'  => 'gw',
                                          'label' => 'GW',
                                          'value' => $creature->gw,
                                          'style' => 'width: 80px',
                                          'placeholder' => 'Enter value')) }}
            </td>
         </tr>
         <tr>
            <td colspan="8">
               <label>Attacks</label>
            </td>
         </tr>
         <tr>
            <td colspan="3">
               <b>Name:</b>
               {{ HTML::custom_text(array('name' => 'at-name', 'style' => 'width: 200px', 'placeholder' => 'Name of attack')) }}
            </td>
            <td>
               <b>DK:</b>
               {{ HTML::custom_text(array('name' => 'at-dk', 'style' => 'width: 50px', 'placeholder' => 'DK')) }}
            </td>
            <td>
               <b>AT:</b>
               {{ HTML::custom_text(array('name' => 'at-at', 'style' => 'width: 50px', 'placeholder' => 'AT')) }}
            </td>
            <td>
               <b>TP:</b>
               {{ HTML::custom_text(array('name' => 'at-tp', 'style' => 'width: 50px', 'placeholder' => 'TP')) }}
            </td>
            <td colspan="2" style="text-align: right">
               {{ HTML::custom_text(array('name' => 'at-remark', 'style' => 'width: 150px', 'placeholder' => 'Remark')) }}
               add
            </td>
         </tr>
         <tr>
            <td colspan="4" style="padding-right: 8px">
               {{ HTML::custom_textarea(array('name'  => 'kampfregeln',
                                     'value' => $creature->kampfregeln,
                                     'label' => true,
                                     'style' => 'width: 100%; height: 60px',
                                     'placeholder' => 'Enter kampfregeln')) }}<br>
            </td>
            <td colspan="4">
               {{ HTML::custom_textarea(array('name'  => 'eigenschaften',
                                     'value' => $creature->eigenschaften,
                                     'label' => true,
                                     'style' => 'width: 100%; height: 60px',
                                     'placeholder' => 'Enter eigenschaften')) }}<br>
            </td>
         </tr>
         <tr>
            <td colspan="4" style="padding-right: 8px">
               {{ HTML::custom_textarea(array('name'  => 'zauber',
                                     'value' => $creature->zauber,
                                     'label' => true,
                                     'style' => 'width: 100%; height: 60px',
                                     'placeholder' => 'Enter zauber')) }}<br>
            </td>
            <td colspan="4">
               {{ HTML::custom_textarea(array('name'  => 'leihgaben',
                                     'value' => $creature->leihgaben,
                                     'label' => true,
                                     'style' => 'width: 100%; height: 60px',
                                     'placeholder' => 'Enter leihgaben')) }}<br>
            </td>
         </tr>
         <tr>
            <td colspan="4" style="padding-right: 8px">
               {{ HTML::custom_textarea(array('name'  => 'dienste',
                                     'value' => $creature->dienste,
                                     'label' => true,
                                     'style' => 'width: 100%; height: 60px',
                                     'placeholder' => 'Enter dienste')) }}<br>
            </td>
            <td colspan="4">
               {{ HTML::custom_textarea(array('name'  => 'nachteil',
                                     'value' => $creature->nachteil,
                                     'label' => true,
                                     'style' => 'width: 100%; height: 60px',
                                     'placeholder' => 'Enter nachteil')) }}<br>
            </td>
         </tr>
         <tr>
            <td colspan="8">
               {{ HTML::custom_textarea(array('name'  => 'description',
                                     'value' => $creature->description,
                                     'label' => true,
                                     'style' => 'width: 100%; height: 80px',
                                     'placeholder' => 'Enter description')) }}<br>
            </td>
         </tr>
      </table><br>
      <div class="button_bar">
         {{ HTML::custom_button(array('type' => 'submit')) }}
         {{ HTML::custom_button(array('type' => 'close-popup')) }}
      </div>
   {{ Form::close() }}
@endif
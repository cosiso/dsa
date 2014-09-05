<hr>
@if (! empty($error))
   <script type="text/javascript">
      alertify.alert('{{ $error }}');
   </script>
@else
   <h4>{{{ $name }}}</h4>
      {{-- var_dump($creatures) --}}
   <ul id="creature-list" class="single-line">
      @foreach ($creatures as $creature)
         <li id="creature-{{ $creature->id }}" onclick="edit_creature(this)">{{{ $creature->name }}}</li>
      @endforeach
   </ul><br>
   <span class="link-add" onclick="edit_creature(null)">Add creature</span><br><br>
   <div id="edit-creature"></div>
@endif
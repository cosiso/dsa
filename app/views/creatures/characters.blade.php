<ul class="single-line">
   @foreach ($chars as $id => $name)
      <li id="char-{{ $id }}" onclick="select_char(this)">{{{ $name }}}</li>
   @endforeach
</ul>

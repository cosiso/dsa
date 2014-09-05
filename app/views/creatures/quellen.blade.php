<ul class="single-line">
   @foreach ($quellen as $quelle)
      <li id="quelle-{{ $quelle['id'] }}" onclick="select_quelle(this)">{{{ $quelle['name'] }}} ({{ $quelle['value'] }})</li>
   @endforeach
</ul>
<ul id="list-quellen" class="single-line">
   @foreach ($quellen as $quelle)
      <li id="quelle-{{ $quelle->id }}" onclick="select_quelle(this)">{{{ $quelle->name }}}</li>
   @endforeach
</ul>
<div id="quelle-creatures"></div>
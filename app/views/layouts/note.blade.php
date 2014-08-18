<div id="close" style="border-bottom: 1px dotted #2a6464">
   <span onclick="$('#popup').hide()">
      close <img src="{{ asset('images/action_delete.png') }}" alt="close">
   </span>
</div>
<div id="text">
@yield('text')
</div>
@unless ($hidebot)
<div id="close" style="border-top: 1px dotted #2a6464">
   <span onclick="$('#popup').hide()">
      close <img src="{{ asset('images/action_delete.png') }}" alt="close">
   </span>
</div>
@endunless
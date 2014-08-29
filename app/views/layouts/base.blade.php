<!DOCTYPE html>
<html>
<head>
   @section('title')
      <title>{{{ $title or 'DSA' }}}</title>
   @show
   <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
   @section('css')
      <link href="/css/dsa.css" rel="stylesheet" type="text/css" />
      <link href="/css/alertify.css" rel="stylesheet" type="text/css" />
   @show
</head>
<body>
   <div id="head">
      @section('head')
         {{ HTML::custom_button(array('value' => 'Home', 'onclick' => "location = '/index2.php'")) }}
         {{ HTML::custom_spacer(array('width' => 10)) }}
         {{ HTML::custom_button(array('value' => 'Characters', 'onclick' => "location = 'characters.php'")) }}
         {{ HTML::custom_button(array('value' => 'Magic', 'onclick' => "location = '/magic'")) }}
         {{ HTML::custom_spacer(array('width' => 30)) }}
         {{ HTML::custom_button(array('value' => 'Setup', 'onclick' => "location = 'setup.php'")) }}
         {{ HTML::custom_spacer(array('width' => 100)) }}
         {{ HTML::custom_button(array('value' => 'roll d6', 'onclick' => "dieroll('d6')")) }}
         {{ HTML::custom_button(array('value' => 'roll d20', 'onclick' => "dieroll('d20')")) }}
         {{ HTML::custom_button(array('value' => 'roll 3d20', 'onclick' => "dieroll('3d20')")) }}
         <hr />
      @show
   </div>
   <div id="div_menu_left" class="caption_left" style="width: 200px; float: left; height: 100%">
      @yield('menu_left')
   </div>
   <div id="main" style="float: left">
      @section('content')
      @show
   </div>
   @section('popup')
      <div id="popup" style="display: none"></div>
   @show
   @section('extra')
   @show
   @section('include-scripts')
      <script type="text/javascript" src="/scripts/jquery.js"></script>
      <script type="text/javascript" src="/tools/jquery-ui-1.10.4/ui/minified/jquery-ui.min.js"></script>
      <script type="text/javascript" src="/scripts/alertify.min.js"></script>
      <script type="text/javascript" src="/scripts/jquery.validate.min.js"></script>
      <script type="text/javascript" src="/scripts/jquery.form.min.js"></script>
      <script type="text/javascript" src="/scripts/jquery.simpletip-1.3.1.min.js"></script>
      <script type="text/javascript" src="/scripts/jquery.tablesorter.min.js"></script>
      <script type="text/javascript" src="/scripts/selectize.min.js"></script>
      <script type="text/javascript">
         <!--
         function dieroll(dice) {
            var roll;
            if (dice == 'd6') {
               roll = Math.floor(Math.random() * 6 + 1);
            } else if (dice == 'd20') {
               roll = Math.floor(Math.random() * 20 + 1);
            } else if (dice == '3d20') {
               roll = Math.floor(Math.random() * 20 + 1) + ' - ' +
                      Math.floor(Math.random() * 20 + 1) + ' - ' +
                      Math.floor(Math.random() * 20 + 1);
            } else {
               alertify.alert('Unknown die-roll');
               return;
            }
            var msg = 'You rolled: <b>' + roll + '</b>';
            if (roll == '1' && dice == 'd20') {
               alertify.success(msg)
            } else if (roll == '20') {
               alertify.error(msg);
            } else {
               alertify.log(msg);
            }
         }
         //-->
      </script>
   @show
   @section('javascript')
   @show
</body>
</html>

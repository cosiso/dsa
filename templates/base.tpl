<!DOCTYPE html>
<html>
<head>
   <title>{block name='title'}{$title}{/block}</title>
   <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
   {block name='css'}
      <link href="css/dsa.css" rel="stylesheet" type="text/css" />
      <link href="css/alertify.css" rel="stylesheet" type="text/css" />
      <link href="css/selectize.default.css" rel="stylesheet" type="text/css" />
   {/block}
</head>
<body>
   <div id="head">
      {block name='head'}
         {custom_button value='home' onclick="location = 'index.php'"}
         {custom_spacer width=10}
         {custom_button value='characters' onclick="location = 'characters.php'"}
         {custom_button value='spells' onclick="alert('Spells')"}
         {custom_spacer width=30}
         {custom_button value='setup' onclick="location = 'setup.php'"}
         <hr />
      {/block}
   </div>
   <div id="div_menu_left" class="caption_left" style="width: 200px; float: left; height: 100%">
      {block name='menu_left'}
      {/block}
   </div>
   <div id="main" style="float: left">
      {custom_hidden}
      {block name='main'}
      {/block}
   </div>
   {block name='popup'}<div id="popup" style="display: none"></div>{/block}
   {block name='extra'}{/block}
   {block name='include-scripts'}
      <script type="text/javascript" src="scripts/jquery.js"></script>
      <script type="text/javascript" src="tools/jquery-ui-1.10.4/ui/minified/jquery-ui.min.js"></script>
      <script type="text/javascript" src="scripts/alertify.min.js"></script>
      <script type="text/javascript" src="scripts/jquery.validate.min.js"></script>
      <script type="text/javascript" src="scripts/jquery.form.min.js"></script>
      <script type="text/javascript" src="scripts/jquery.simpletip-1.3.1.min.js"></script>
      <script type="text/javascript" src="scripts/jquery.tablesorter.min.js"></script>
      <script type="text/javascript" src="scripts/selectize.min.js"></script>
   {/block}
   {block name='javascript'}{/block}
</body>
</html>
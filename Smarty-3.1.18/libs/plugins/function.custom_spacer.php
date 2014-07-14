<?php
function smarty_function_custom_spacer($params, &$smarty) {
   $src = 'images/spacer.gif';
   $width = '1';
   $height = '1';
   $border = '0';
   foreach($params as $_key => $_val) {
      $$_key = $_val;
   }
   $result = '<img src="' . $src . '" width="' . $width . '" height="' . $height . '" border="' . $border . '" alt=" ">';
   return $result;
}
?>

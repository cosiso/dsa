<?php
function smarty_function_carto_calender_button($params, &$smarty) {
   $img = '/images/calendar-icon.jpg';
   $width = '30';
   $height = '31';
   foreach($params as $_key => $_val) {
      switch ($_key) {
         case 'id':
         case 'img':
         case 'width':
         case 'height':
            $$_key = $_val;
            break;
         default:
            if ( is_array($_val) )
               $smarty->trigger_error("html_text: attribute '$_key' cannot be an array", E_USER_NOTICE);
            else
               $extra .= " " . $_key . '="' . $_val . '"';
            break;
      }
   }

   if (! $id)
      $smarty->trigger_error("carto_calender_button: missing required attribute 'id'", E_USER_NOTICE);
   
   $result = '<input type="button" id="' . $id . '" style="background-image: url(\'' . $img . '\'); width: ' . $width . 'px; height: ' . $height . 'px; cursor: pointer"';
   if ($extra) $result .= ' ' . $extra;
   $result .= ' />';
   return $result;
}
?>

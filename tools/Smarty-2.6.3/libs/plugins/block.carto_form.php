<?php
function smarty_block_carto_form($params, $content, &$smarty, &$repeat) {
   $class = 'v2';
   $method = 'post';
   foreach($params as $_key => $_val) {
      switch($_key) {
         case 'class':
         case 'method':
         case 'id':
            $$_key = $_val;
            break;
         case 'name':
            $name = $_val;
            if (! $id) $id = $name;
            break;
         default:
            if ( is_array($_val) )
               $smarty->trigger_error("html_text: attribute '$_key' cannot be an array", E_USER_NOTICE);
            else
               $extra .= " " . $_key . '="' . $_val . '"';
            break;
      }
   }
   if (! $name)
      $smarty->trigger_error("carto_form: missin required attribute 'name'", E_USER_NOTICE);
   
   $result = '<form name="' . $name . '" id="' . $id . '" class="' . $class . '" method="' . $method . '"';
   if ($extra) $result .= $extra;
   $result .= ">\n" . $content . "</form>\n";
   return $result;
}
?>

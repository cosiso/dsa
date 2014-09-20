<?php
function smarty_block_custom_form($params, $content, &$smarty, &$repeat) {
   $extra = [];
   $method = 'post';
   foreach($params as $_key => $_val) {
      if ( is_array($_val) )
         $smarty->trigger_error("custom_form: attribute '$_key' cannot be an array", E_USER_NOTICE);
      switch($_key) {
         case 'method':
         case 'id':
         case 'name':
            if ( is_array($_val) )
               $smarty->trigger_error("custom_form: attribute '$_key' cannot be an array", E_USER_NOTICE);
            else
               $$_key = $_val;
            break;
         default:
            $extra[$_key] = $_val;
            break;
      }
   }

   if ($content) {
      # Closing tag
      $result = $content . '</form>';
   } else {
      # Opening tag
      if ($id and ! $name) $name = $id;
      if (! $name) $smarty->trigger_error("custom_form: missing required attribute 'name'", E_USER_NOTICE);
      if (! $id) $id = $name;
      $result = '<form name="' . $name . '" id="' . $id . '" method="' . $method . '"';
      foreach ($extra as $_key => $_val) {
         $result .= " $_key=\"$_val\"";
      }
      $result .= '>';
   }
   return $result;
}
?>

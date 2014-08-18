<?php
function smarty_function_custom_checkbox($params, &$smarty) {
   foreach($params as $_key => $_val) {
      switch($_key) {
         case 'checked':
            if ($_val) $checked=true;
            break;
         case 'label':
         case 'name':
         case 'class':
         case 'style':
         case 'text':
         case 'id':
            if ( is_array($_val) )
               $smarty->trigger_error("custom_checkbox: attribute '$_key' cannot be an array", E_USER_NOTICE);
            else
               $$_key = $_val;
            break;
         default:
            $extra .= "$_key=\"$_val\" ";
      }
   }
   if (! $name and ! $id) trigger_error('custom_checkbox: attribute "name" or "id" must be given', E_USER_ERROR);
   if (! $id) $id = $name;
   if (! $name) $name = $id;
   $result = ( ($label) ? '<label for="' . $name . '">' . $label . '</label>' : '') .
      '<input type="checkbox"' .
      ' name="' . $name . '"' .
      ' id="' . $id . '"' .
      ( ($class) ? ' class="' . $class . '"' : '') .
      ( ($style) ? ' style="' . $style . '"' : '') .
      ( ($checked) ? ' checked' : '') .
      '>' .
      ( ($text) ? $text : '');
   return $result;
}
?>

<?php
function smarty_function_html_radio($params, &$smarty)
{
   require_once $smarty->_get_plugin_filepath('shared','escape_special_chars');
   foreach($params as $_key => $_val) {
      switch($_key) {
         case 'checked':
            if ($_val) $checked=true;
            break;
         case 'value_checked':
         case 'label':
         case 'name':
         case 'class':
         case 'style':
         case 'extra':
         case 'id':
            if ( is_array($_val) )
               $smarty->trigger_error("html_text: attribute '$_key' cannot be an array", E_USER_NOTICE);
            else
               $$_key = $_val;
            break;
         default:
            $extra .= "$_key=\"$_val\" ";
      }
   }
   if ($value_checked) {
      $checked = ($checked == $value_checked) ? true : false;
   }
   $result = '<input type="radio"';
   if ($name) {
      $result .= ' name="' . $name . '"';
      if (! $id) $id = $name;
   }
   if ($id) $result .= ' id="' . $id . '"';
   if ($class) $result .= ' class="' . $class . '"';
   if ($style) $result .= ' style="' . $style . '"';
   if ($extra) $result .= ' ' . $extra;
   if ($checked) $result .= ' checked';
   $result .= ' />';
   if ($label) $result .= smarty_function_escape_special_chars($label);
   return $result;
}
?>

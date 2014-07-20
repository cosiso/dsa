<?php
/**
 * Smarty {custom_textarea} function plugin
 *
 * Type:     function
 * Name:     custom_textarea
 * Date:     Nov 27, 2011
 * Purpose:  format HTML tags for the type textarea
 * Input:
 *         - name = name for textarea
 *         - all fields are optional
 *         - extra = extra passed to input (optional, default empty)
 */
function smarty_function_custom_textarea($params, &$smarty)
{
   foreach($params as $_key => $_val) {
      switch($_key) {
         case 'value':
         case 'name':
         case 'id':
         case 'label':
            if ( is_array($_val) )
               trigger_error("custom_textarea: attribute '$_key' cannot be an array", E_USER_NOTICE);
            else
               $$_key = $_val;
            break;
         default:
            $extra .= ' ' . $_key . '="' . $_val . '"';
      }
   }
   if (! $name) trigger_error('custom_textarea: attribute "name" must be specified', E_USER_ERROR);
   $result = ( ($label) ? '<label for="' . $name . '">' . $label . '</label>' : '') .
      '<textarea name="' . $name . '" ' .
      'id="' . (($id) ? $id : $name) . '"';
   if ($extra) $result .= ' ' . $extra;
   $result .= '>' . $value . '</textarea>';
   return $result;
}
?>

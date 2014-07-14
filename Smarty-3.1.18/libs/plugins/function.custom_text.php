<?php

/**
 * Smarty {custom_text} function plugin
 *
 * Input:
 *         - name = name of input (optional, default empty)
 *         - value = value of input (optional, default empty)
 *         - id = id of input (optional, default empty)
 *         - class = class of input (optional, default empty)
 *         - style = style of input (optional, default empty)
 *         - extra = extra passed to input (optional, default empty)
 *         - label = put label in front with passed text (optional)
 *
 * Examples: {custom_text name="field" value="4" extra="maxlength=4"}
 * Output:   <input type="text" name="field" value="4" maxlength=4>
 */
function smarty_function_custom_text($params, &$smarty)
{
   foreach($params as $_key => $_val) {
      switch($_key) {
         case 'label':
         case 'name':
         case 'value':
         case 'class':
         case 'style':
         case 'extra':
         case 'id':
            if ( is_array($_val) )
               $smarty->trigger_error("custom_text: attribute '$_key' cannot be an array", E_USER_NOTICE);
            else
               $$_key = $_val;
            break;
         default:
            $extra .= "$_key=\"$_val\" ";
      }
   }
   if (! $name) $smarty->trigger_error('custom_text: attribute "name" must be given', E_USER_ERROR);
   $result = ( ($label) ? '<label for="' . $name . '">' . $label . '</label>' : '') .
         '<input type="text" name="' . $name . '"' .
         ' id="' . ( ($id) ? $id : $name) . '"';
   if ($value) $result .= ' value="' . $value . '"';
   if ($class) $result .= ' class="' . $class . '"';
   if ($style) $result .= ' style="' . $style . '"';
   if ($extra) $result .= ' ' . $extra;
   $result .= ">";
   return $result;
}
?>

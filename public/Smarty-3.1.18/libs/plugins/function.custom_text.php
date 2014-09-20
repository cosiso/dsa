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
   $extra = [];
   foreach($params as $_key => $_val) {
      if ( is_array($_val) )
         trigger_error("custom_text: attribute '$_key' cannot be an array", E_USER_NOTICE);
      switch($_key) {
         case 'label':
         case 'name':
         case 'id':
            $$_key = $_val;
            break;
         default:
            $extra[$_key] = $_val;
      }
   }
   if ($id and ! $name) $name = $id;
   if (! $name) trigger_error('custom_text: attribute "name" must be given', E_USER_ERROR);
   if (! $id) $id = $name;
   if ($label === true) $label = ucfirst($name);
   $result = ( ($label) ? '<label for="' . $name . '">' . $label . '</label>' : '') .
         '<input type="text" name="' . $name . '"' .
         ' id="' . $id . '"';
   foreach ($extra as $_key => $_val) $result .= " $_key=\"$_val\"";
   $result .= ">";
   return $result;
}
?>

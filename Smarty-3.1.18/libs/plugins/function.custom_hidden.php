<?php
/**
 * Smarty plugin
 * @package Smarty
 * @subpackage plugins
 */


/**
 * Smarty {custom_hidden} function plugin
 *
 * Type:     function<br>
 * Name:     html_hidden<br>
 * Date:     Mar 07, 2004<br>
 * Purpose:  format HTML tags for the type input hidden<br>
 * Input:<br>
 *         - all fields are optional
 *         - extra = extra passed to input (optional, default empty)<br>
 *
 * Examples: {custom_hidden name="field" value="4" extra="maxlength=4"}<br>
 * Output:   <input type="hidden" name="field" value="4" maxlength=4><br>
 * @author   Andre Speelmans <andre@cosiso.nl>
 * @version  1.0
 * @param array
 * @param Smarty
 * @return string
 */
function smarty_function_custom_hidden($params, &$smarty)
{
   foreach($params as $_key => $_val) {
      switch($_key) {
         case 'name':
            $name = $_val;
            break;
         case 'id':
            $id = $_val;
            break;
         case 'extra':
            if ( is_array($_val) )
               $smarty->trigger_error("custom_hidden: attribute '$_key' cannot be an array", E_USER_NOTICE);
            else
               $$_key = $_val;
            break;
         default:
            $extra .= ' ' . $_key . '="' . $_val . '"';
      }
   }
   $result = '<input type="hidden"';
   if ($name) {
      $result .= ' name="' . $name . '"';
      if (! $id) $id = $name;
   }
   if ($id)
      $result .= ' id="' . $id . '"';
   if ($extra) $result .= $extra;
   $result .= ">";
   return $result;
}
?>

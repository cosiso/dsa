<?php
/**
 * Smarty plugin
 * @package Smarty
 * @subpackage plugins
 */


/**
 * Smarty {html_hidden} function plugin
 *
 * Type:     function<br>
 * Name:     html_hidden<br>
 * Date:     Mar 07, 2004<br>
 * Purpose:  format HTML tags for the type input hidden<br>
 * Input:<br>
 *         - all fields are optional
 *         - extra = extra passed to input (optional, default empty)<br>
 *
 * Examples: {html_hidden name="field" value="4" extra="maxlength=4"}<br>
 * Output:   <input type="hidden" name="field" value="4" maxlength=4><br>
 * @author   Andre Speelmans <andre@as.no-ip.com>
 * @version  1.0
 * @param array
 * @param Smarty
 * @return string
 * @uses smarty_function_escape_special_chars()
 */
function smarty_function_html_hidden($params, &$smarty)
{
   require_once $smarty->_get_plugin_filepath('shared','escape_special_chars');
       
   foreach($params as $_key => $_val) {
      switch($_key) {
         case 'name':
            $name = smarty_function_escape_special_chars($_val);
            break;
         case 'id':
            $id = smarty_function_escape_special_chars($_val);
            break;
         case 'extra':
            if ( is_array($_val) )
               $smarty->trigger_error("html_text: attribute '$_key' cannot be an array", E_USER_NOTICE);
            else
               $$_key = $_val;
            break;
         default:
            $extra .= ' ' . $_key . '="' . smarty_function_escape_special_chars($_val) . '"';
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
/* vim: set expandtab: set tabstop=3: set shiftwidth=3: */
?>

<?php
/**
 * Smarty plugin
 * @package Smarty
 * @subpackage plugins
 */


/**
 * Smarty {html_text} function plugin
 *
 * Type:     function<br>
 * Name:     html_text<br>
 * Date:     Dec 03, 2003<br>
 * Purpose:  format HTML tags for the type input text<br>
 * Input:<br>
 *         - name = name of input (optional, default empty)<br>
 *         - value = value of input (optional, default empty)<br>
 *         - id = id of input (optional, default empty)<br>
 *         - class = class of input (optional, default empty)<br>
 *         - style = style of input (optional, default empty)<br>
 *         - extra = extra passed to input (optional, default empty)<br>
 *
 * Examples: {html_text name="field" value="4" extra="maxlength=4"}<br>
 * Output:   <input type="text" name="field" value="4" maxlength=4><br>
 * @author   Andre Speelmans <andre@as.no-ip.com>
 * @version  1.0
 * @param array
 * @param Smarty
 * @return string
 * @uses smarty_function_escape_special_chars()
 */
function smarty_function_html_text($params, &$smarty)
{
   foreach($params as $_key => $_val) {
      switch($_key) {
         case 'name':
         case 'value':
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
   $result = '<input type="text"';
   if ($name) {
      $result .= ' name="' . $name . '"';
      if (! $id) $id = $name;
   }
   if ($id) $result .= ' id="' . $id . '"';
   if ($value) $result .= ' value="' . $value . '"';
   if ($class) $result .= ' class="' . $class . '"';
   if ($style) $result .= ' style="' . $style . '"';
   if ($extra) $result .= ' ' . $extra;
   $result .= "/>";
   return $result;
}

/* vim: set expandtab: set tabstop=3: set shiftwidth=3: */

?>

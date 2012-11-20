<?php
/**
 * Smarty {html_textarea} function plugin
 *
 * Type:     function<br>
 * Name:     html_textarea<br>
 * Date:     Nov 27, 2011<br>
 * Purpose:  format HTML tags for the type textarea<br>
 * Input:<br>
 *         - all fields are optional
 *         - extra = extra passed to input (optional, default empty)<br>
 *
 * @author   Andre Speelmans <andre@cosiso.nl>
 * @version  1.0
 * @param array
 * @param Smarty
 * @return string
 * @uses smarty_function_escape_special_chars()
 */
function smarty_function_html_textarea($params, &$smarty)
{
   require_once $smarty->_get_plugin_filepath('shared','escape_special_chars');
       
   foreach($params as $_key => $_val) {
      switch($_key) {
         case 'value':
         case 'name':
         case 'id':
            $$_key = $_val;
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
   $result = '<textarea';
   if ($name) {
      $result .= ' name="' . $name . '"';
      if (! $id) $id = $name;
   }
   if ($id)
      $result .= ' id="' . $id . '"';
   if ($extra) $result .= $extra;
   $result .= ">";
   if ($value) {
      $value = smarty_function_escape_special_chars($value);
      $result .= $value;
   }
   $result .= '</textarea>';
   return $result;
}
/* vim: set expandtab: set tabstop=3: set shiftwidth=3: */
?>

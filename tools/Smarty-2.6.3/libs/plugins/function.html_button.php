<?php
/**
 * Smarty plugin
 * @package Smarty
 * @subpackage plugins
 */


/**
 * Smarty {html_button} function plugin
 *
 * Type:     function<br>
 * Name:     html_hidden<br>
 * Date:     Mar 07, 2004<br>
 * Purpose:  format HTML tags for the type input button<br>
 * Input:<br>
 *         - value = text to be displayed on button (required)<br>
 *         - type = type of button (submit, reset, button) (optional default button)<br>
 *         - class = value for class (optional, default button)<br>
 *         - all otherfields are optional<br>
 *         - extra = extra passed to input (optional, default empty)<br>
 *
 * Type "close" generates a button with onClick event of 'window.close()'<br>
 * Examples: {html_button type="submit" value="save" style="width: 100px"}<br>
 * Output:   <input type="submit" class="button" value="save" style="width: 100px"><br>
 * @author   Andre Speelmans <andre@as.no-ip.com>
 * @version  1.0
 * @param array
 * @param Smarty
 * @return string
 * @uses smarty_function_escape_special_chars()
 */
function smarty_function_html_button($params, &$smarty)
{
   require_once $smarty->_get_plugin_filepath('shared','escape_special_chars');
   
   $type = 'button';
   $class = 'button';
   switch ($params['type']) {
      case "close":
         $params['type'] = 'button';
         if (empty($params['onClick'])) $params['onClick'] = "window.close()";
         if (empty($params['value'])) $params['value'] = 'Sluiten';
         break;
      case "submit":
         if (empty($params['value'])) $params['value'] = 'Opslaan';
         break;
      case "reset":
         if (empty($params['value'])) $params['value'] = 'Annuleren';
         break;
   }
   foreach($params as $_key => $_val) {
      switch($_key) {
         case 'value':
            $value = smarty_function_escape_special_chars($_val);
            break;
         case 'class':
         case 'type':
            $$_key = $_val;
            break;
         default:
            if ( is_array($_val) )
               $smarty->trigger_error("html_text: attribute '$_key' cannot be an array", E_USER_NOTICE);
            else
               $extra .= " " . $_key . '="' . $_val . '"';
            break;
      }
   }
   if (! $value)
      $smarty->trigger_error("html_button: missin required attribute 'value'", E_USER_NOTICE);
   
   $result = '<input value="' . $value . '" class="' . $class . '" type="' . $type . '"';
   if ($extra) $result .= $extra;
   $result .= ">";
   return $result;
}

/* vim: set expandtab: set tabstop=3: set shiftwidth=3: */

?>

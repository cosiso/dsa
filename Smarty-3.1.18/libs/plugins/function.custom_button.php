<?php
/**
 * Smarty plugin
 * @package Smarty
 * @subpackage plugins
 */


/**
 * Smarty {custom_button} function plugin
 *
 * Type:     function<br>
 * Name:     custom_button<br>
 * Date:     Nov 25, 2011<br>
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
 * Output:   <input type="submit" class="menu-button" value="save" style="width: 100px"><br>
 * @author   Andre Speelmans <andre@cosiso.nl>
 * @version  1.0
 * @param array
 * @param Smarty
 * @return string
 */
function smarty_function_custom_button($params, &$smarty)
{
   $type = 'button';
   $class = 'menu-button';
   # Verifieer for disabled and not set class
   if ($params[disabled] and empty($params['class']))
      $params['class'] = 'menu-button-disabled';
   switch ($params['type']) {
      case 'remove':
         $params[type] = 'button';
         if (empty($params[value])) $params[value] = 'Remove';
         if (empty($params['class'])) $params['class'] = 'menu-button-reset';
         break;
      case 'save':
         $params[type] = 'button';
         if (empty($params[value])) $params[value] = 'Save';
         if (empty($params['class'])) $params['class'] = 'menu-button-submit';
         break;
      case "close":
         $params['type'] = 'button';
         if (empty($params['onclick'])) $params['onclick'] = "window.close()";
         if (empty($params['value'])) $params['value'] = 'Close';
         if (empty($params['class'])) $params['class'] = 'menu-button-reset';
         break;
      case "submit":
         if (empty($params['value'])) $params['value'] = 'Save';
         if (empty($params['class'])) $params['class'] = 'menu-button-submit';
         break;
      case "reset":
         if (empty($params['value'])) $params['value'] = 'Cancel';
         if (empty($params['class'])) $params['class'] = 'menu-button-reset';
         break;
   }
   foreach($params as $_key => $_val) {
      switch($_key) {
         case 'value':
            $value = $_val;
            break;
         case 'class':
         case 'type':
            $$_key = $_val;
            break;
         case 'name':
            $name = $_val;
            if (! $id) $id = $name;
            break;
         case 'id':
            $id = $_val;
            break;
         default:
            if ( is_array($_val) )
               trigger_error("custom_button: attribute '$_key' cannot be an array", E_USER_NOTICE);
            else
               $extra .= " " . $_key . '="' . $_val . '"';
            break;
      }
   }
   if (! $value)
      trigger_error("custom_button: missing required attribute 'value'", E_USER_NOTICE);

   $result = '<input value="' . $value . '" class="' . $class . '" type="' . $type . '"';
   if ($name) $result .= ' name="' . $name . '"';
   if ($id) $result .= ' id="' . $id . '"';
   if ($extra) $result .= $extra;
   $result .= " />";
   return $result;
}
?>

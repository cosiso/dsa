<?php
/**
 * Smarty plugin
 * @package Smarty
 * @subpackage plugins
 */


/**
 * Smarty {html_selectfile} function plugin
 *
 * Type:     function<br>
 * Name:     html_selectfile<br>
 * Date:     Dec 03, 2003<br>
 * Purpose:  format HTML tags for a drop down select filled with entries from file<br>
 * Input:<br>
 *         - name = name of select (optional, default empty)<br>
 *         - file = name of file with entries<br>
 *                  this file consists of 2 items per line<br>
 *                  code\tfull name<br>
 *         - selected = code of selected entry
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
function smarty_function_html_selectfile($params, &$smarty)
{
   if (! $params['file'])
      $smarty->trigger_error("html_selectfile: attribute 'file] required", E_USER_NOTICE);
   foreach($params as $_key => $_val) {
      switch($_key) {
         case 'name':
            $name = $_val;
            break;
         case 'id':
            $id = $_val;
            break;
         case 'file':
            $filename = $_val;
            // file will be handled below
            break;
         case 'selected':
         case 'extra':
            if ( is_array($_val) )
               $smarty->trigger_error("html_text: attribute '$_key' cannot be an array", E_USER_NOTICE);
            else
               $$_key = $_val;
            break;
         default:
            $extra .= "$_key=\"$_val\" ";
      }
   }
   $result = "<select";
   if ($name) {
      $result .= ' name="' . $name . '"';
      if (! $id) $id = $name;
   }
   if ($id) $result .= ' id="' . $id . '"';
   if ($extra) $result .= ' ' . $extra;
   $result .= ">\n";
   # Set options
   $lines = file($filename);
   foreach ($lines as $line) {
      list($code, $value) = preg_split("/\t+/", $line);
      $result .= "<option value='" . htmlentities($code, ENT_QUOTES) . "'";
      if ($code == $selected)
         $result .= " selected";
      $result .= ">" . htmlentities($value, ENT_QUOTES) . "</option>\n";
   }
   $result .= "</select>";
   return $result;
}

/* vim: set expandtab: set tabstop=3: set shiftwidth=3: */

?>

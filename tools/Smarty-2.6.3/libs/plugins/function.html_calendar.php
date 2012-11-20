<?php
/**
 * Smarty plugin
 * @package Smarty
 * @subpackage plugins
 */


/**
 * Smarty {html_calendar} function plugin
 *
 * Type:     function<br>
 * Name:     html_calendar<br>
 * Date:     Mrt 01, 2004<br>
 * Purpose:  format HTML tags for the type input text + calendar popup<br>
 * Input:<br>
 *         - name = name of input<br>
 *         - form = name of form that contains this field<br>
 *         - value = value of input (optional, default empty)<br>
 *         - id = id of input (optional, default empty)<br>
 *         - class = class of input (optional, default empty)<br>
 *         - style = style of input (optional, default empty)<br>
 *         - date_format = format of date (optional, default dd-mm-yyyy)<br>
 *         - img_src = src of image (optional, default img/icons/calendar.gif)<br>
 *         - extra = extra passed to input (optional, default empty)<br>
 *
 * Examples: {html_calendar name="field" value="4" form="tst" extra="maxlength=4"}<br>
 * Output:   <input type="text" name="field" value="4" maxlength=4><img src="img/calendar" onClick="popUpCalendar(this, tst.field, 'dd-mm-yyyy')"><br>
 * @author   Andre Speelmans <andre@as.no-ip.com>
 * @version  1.0
 * @param array
 * @param Smarty
 * @return string
 * @uses smarty_function_escape_special_chars()
 */
function smarty_function_html_calendar($params, &$smarty)
{
   $date_format = "dd-mm-yyyy";
   $img_src  = "img/icons/calendar.gif";
   foreach($params as $_key => $_val) {
      switch($_key) {
         case 'name':
         case 'value':
         case 'form':
         case 'class':
         case 'style':
         case 'extra':
         case 'img_src':
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
   $result .= '&nbsp;<img src="' . $img_src . '" onClick=\'popUpCalendar(this, ' . $form . '.' . $name . ', "' . $date_format . '")\' style="cursor: pointer">';
   return $result;
}

/* vim: set expandtab: set tabstop=3: set shiftwidth=3: */

?>

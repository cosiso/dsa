<?php

HTML::macro('custom_hidden', function($params = array()) {
   foreach($params as $key => $val) {
      if (is_array($val)) return "<em>custom_hidden: error - $key cannot be an array</em>";
      switch($key) {
         case 'name':
         case 'value':
            $$key = $val;
            break;
         default:
            $extra["$key"] = $val;
      }
   }
   if (empty($name) and isset($extra['id'])) $name = $extra['id'];
   if (empty($name)) return '<em>custom_text: error - attribute "name" must be given</em>';

   $result = Form::hidden($name, (empty($value)) ? null : $value, $extra);
   return $result;
});
HTML::macro('custom_text', function($params = array()) {
   $extra = '';
   foreach($params as $key => $val) {
      switch($key) {
         case 'label';
         case 'name':
         case 'value':
            if ( is_array($val) ) return "<em>custom_text: error - $key cannot be an array</em>";
            $$key = $val;
            break;
         default:
            if ( is_array($val) ) return "<em>custom_text: error - $key cannot be an array</em>";
            $extra["$key"] = $val;
      }
   }
   if (empty($extra['id']) and isset($name)) $extra['id'] = $name;
   if (empty($name) and isset($extra['id'])) $name = $extra['id'];
   if (empty($name)) return '<em>custom_textarea: error - attribute "name" must be given</em>';

   $result = (empty($label)) ? Form::label($name, ($label === true) ? null : $label) : '';
   $result .= Form::text($name, (empty($value) ? null : $value), $extra);
   return $result;
});
HTML::macro('custom_textarea', function($params = array()) {
   $value = ''; $extra = '';
   foreach ($params as $key => $val) {
      switch($key) {
         case 'label':
         case 'name':
         case 'id':
         case 'value':
            if ( is_array($val) ) return "<em>custom_textarea: error - $key cannot be an array</em>";
            $$key = $val;
            break;
         default:
            if ( is_array($val) ) return "<em>custom_textarea: error - $key cannot be an array</em>";
            $extra["$key"] = $val;
      }
   }
   if (empty($extra['id']) and isset($name)) $extra['id'] = $name;
   if (empty($name) and isset($extra['id'])) $name = $extra['id'];
   if (empty($name)) return '<em>custom_textarea: error - attribute "name" must be given</em>';

   $result = (empty($label)) ? Form::label($name, ($label === true) ? null : $label) : '';
   $result .= Form::textarea($name, (empty($value) ? null : $value), $extra);
   return $result;
});
HTML::macro('custom_spacer', function($params = array()) {
   # Set defaults
   $src = '/images/spacer.gif'; $alt = ' '; $secure = null;
   foreach ($params as $key => $value) {
      if (is_array($value)) return "<em>custom_spacer: error - attribute $key cannot be an array</em>";
      switch ($key) {
         case 'src':
         case 'alt':
         case 'secure':
            $$key = $value;
            break;
         default:
            $data["$key"] = $value;
      }
   }
   $data = array('width'  => 1,
                 'height' => 1,
                 'border' => 0);
   $data = array_merge($data, $params);
   return HTML::image($src, $alt, $data, $secure);
});
HTML::macro('custom_button', function($params = array()) {
   $extra = array();
   foreach ($params as $key => $val) {
      switch ($key) {
         case 'value':
         case 'name':
         case 'type':
         case 'id':
         case 'class':
         case 'disabled':
            $$key = $val;
            break;
         default:
            if (is_array($val)) return "<em>custom_button: error - $key cannot be an array</em>";
            $extra["$key"] = $val;
      }
   }
   # Set defaults
   if (empty($id) and ! empty($name)) $id = $name;
   if (empty($name) and ! empty($id)) $name = $id;
   if (empty($type)) $type = 'button';
   switch ($type) {
      case 'button':
         break;
      case 'remove':
         if (empty($value)) $value = 'Remove';
         if (empty($class)) $class = 'menu-button-reset';
         $type = 'button';
         break;
      case 'save':
         if (empty($value)) $value = 'Save';
         if (empty($class)) $class = 'menu-button-submit';
         $type = 'submit';
         break;
      case 'close':
         if (empty($value)) $value = 'Close';
         if (empty($class)) $class = 'menu-button-reset';
         if (empty($extra['onclick'])) $extra['onclick'] = 'window.close()';
         $type = 'button';
         break;
      case 'close-popup':
         if (empty($value)) $value = 'Close';
         if (empty($class)) $class = 'menu-button-reset';
         if (empty($extra['onclick'])) $extra['onclick'] = "$('#popup').hide()";
         $type = 'button';
      case 'submit':
         if (empty($value)) $value = 'Save';
         if (empty($class)) $class = 'menu-button-submit';
         break;
      case 'reset':
         if (empty($value)) $value = 'Cancel';
         if (empty($class)) $class = 'menu-button-reset';
         break;
      default:
         return '<em>custom_button: error - invalid type</em>';
   }
   if (empty($class)) $class = (isset($disabled)) ? 'menu-button-disabled' : 'menu-button';
   if (empty($value)) $value = '';

   # Generate output
   $data = compact('class', 'id');
   if (count($extra)) $data = array_merge($data, $extra);
   $result = Form::input($type, (empty($name)) ? null : $name, $value, $data);
   return $result;
});

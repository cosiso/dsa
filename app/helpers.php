<?php

function is_digits($integer) {
   return (ctype_digit(strval($integer)));
}
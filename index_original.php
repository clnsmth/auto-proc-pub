<?php

$format = $_GET['format'];


if ($format == 'ascii') {
   $ascii_response = "Hello world";
   echo $ascii_response;
}

if ($format == 'json') {
   $json = "Hello worlds";
   echo $json; 
}


?>

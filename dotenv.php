<?php

function get_dotenv() {
  $array = explode("\n", file_get_contents(dirname(__FILE__) . "/.env"));
  $array = array_filter($array, function ($line) {
    return !empty($line);
  });
  $array = array_map(function ($line) {
    return explode("=", trim($line));
  }, $array);

  return array_combine(array_map(function ($pair) {
    return $pair[0];
  }, $array), array_map(function ($pair) {
    return $pair[1];
  }, $array));
}

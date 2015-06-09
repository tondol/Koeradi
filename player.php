<?php

# dotenv
$dotenv_array = explode("\n", file_get_contents(dirname(__FILE__) . "/.env"));
$dotenv_array = array_map(function ($line) {
  return explode("=", trim($line));
}, $dotenv_array);
$dotenv = array_combine(array_map(function ($pair) {
  return $pair[0];
}, $env_array), array_map(function ($pair) {
  return $pair[1];
}, $env_array));

$contents_uri = empty($dotenv["CONTENTS_URI"]) ? "./" : $dotenv["CONTENTS_URI"];
$filename = basename($_GET['filename']);
$filepath = $contents_uri . $filename;

?>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css" rel="stylesheet" />
  <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>
  <script src="https://jwpsrv.com/library/Jr71WDfEEeO6GhIxOQfUww.js"></script>
  <title><?= htmlspecialchars($filename, ENT_QUOTES) ?></title>
  <style>
    .page-header { margin: 20px 0; }
    .page-header h1,
    .page-header h2 { margin: 0; }
  </style>
</head>
<body>
<div class="container">
  <div class="page-header">
    <h1>声ラジアーカイバ</h1>
  </div>
  <div class="page-header">
    <h2><?= htmlspecialchars($filename, ENT_QUOTES) ?></h2>
  </div>
  <div id="player"></div>
  <hr />
  <p><a href="index.php" class="btn btn-primary">一覧に戻る</a></p>
</div> 
<script type="text/javascript">
  jwplayer("player").setup({
    file: "<?= htmlspecialchars($filepath, ENT_QUOTES) ?>",
    width: 640,
    height: 360
  });
</script>
</body>
</html>

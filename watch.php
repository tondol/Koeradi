<?php

$filename = basename($_GET['filename']);

?>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css" rel="stylesheet" />
  <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>
  <script src="https://jwpsrv.com/library/Jr71WDfEEeO6GhIxOQfUww.js"></script>
  <title><?= htmlspecialchars($filename, ENT_QUOTES) ?></title>
</head>
<body>
<div id="player"></div> 
<script type="text/javascript">
  jwplayer("player").setup({
    file: "<?= htmlspecialchars($filename, ENT_QUOTES) ?>"
  });
</script>
</body>
</html>

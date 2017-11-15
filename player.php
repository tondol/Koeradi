<?php

date_default_timezone_set('Asia/Tokyo');
require dirname(__FILE__) . '/vendor/autoload.php';

(new Dotenv\Dotenv(dirname(__FILE__)))->load();
$filename = basename($_GET['filename']);
$contents_dir = empty($_ENV["CONTENTS_DIR"]) ? "." : $_ENV["CONTENTS_DIR"];
$contents_dir_uri = empty($_ENV["CONTENTS_DIR_URI"]) ? "." : $_ENV["CONTENTS_DIR_URI"];
$acd_cli_cache_path = empty($_ENV["ACD_CLI_CACHE_PATH"]) ? "." : $_ENV["ACD_CLI_CACHE_PATH"];
$acd_cli_contents_dir = empty($_ENV["ACD_CLI_CONTENTS_DIR"]) ? "" : $_ENV["ACD_CLI_CONTENTS_DIR"];

if (filesize("$contents_dir/$filename") == 0) {
  // On Amazon Cloud Drive
  $json = json_decode(shell_exec(
      "ACD_CLI_CACHE_PATH=$acd_cli_cache_path " .
      "ACD_CLI_SETTINGS_PATH=$acd_cli_cache_path " .
      "/usr/local/bin/acdcli metadata $acd_cli_contents_dir/$filename 2>&1"), true);
  if (is_null($json)) {
      shell_exec(
          "ACD_CLI_CACHE_PATH=$acd_cli_cache_path " .
          "ACD_CLI_SETTINGS_PATH=$acd_cli_cache_path " .
          "/usr/local/bin/acdcli sync");
      $json = json_decode(shell_exec(
          "ACD_CLI_CACHE_PATH=$acd_cli_cache_path " .
          "ACD_CLI_SETTINGS_PATH=$acd_cli_cache_path " .
          "/usr/local/bin/acdcli metadata $acd_cli_contents_dir/$filename 2>&1"), true);
  }
  $pathinfo = pathinfo($filename);
  $uri = $json["tempLink"] . "?/v." . $pathinfo["extension"];
  $filesize = sprintf("%.2fMB", $json["contentProperties"]["size"] / 1000.0 / 1000.0);
} else {
  // On File System
  $uri = "$contents_dir_uri/$filename";
  $filesize = sprintf("%.2fMB", filesize($contents_dir . "/" . $filename) / 1000.0 / 1000.0);
}

?>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css" rel="stylesheet" />
  <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>
  <link rel="stylesheet" type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/dplayer/1.16.0/DPlayer.min.css" />
  <script src="//cdnjs.cloudflare.com/ajax/libs/flv.js/1.3.3/flv.min.js"></script>
  <script src="//cdnjs.cloudflare.com/ajax/libs/dplayer/1.16.0/DPlayer.min.js"></script>
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
    <h1>Koeradi</h1>
  </div>
  <div class="page-header">
    <h2><?= htmlspecialchars($filename, ENT_QUOTES) ?></h2>
  </div>
  <div id="player"></div>
  <hr />
  <p>
    <a href="index.php" class="btn btn-primary">一覧に戻る</a>
    <a href="<?= htmlspecialchars($uri, ENT_QUOTES) ?>" class="btn btn-default">
    ダウンロード（<?= htmlspecialchars($filesize, ENT_QUOTES) ?>）
    </a>
  </p>
</div>
<script type="text/javascript">
var dp = new DPlayer({
    container: document.getElementById('player'),
    screenshot: true,
    video: {
        url: "<?= htmlspecialchars($uri, ENT_QUOTES) ?>",
    }
});

</script>
</body>
</html>

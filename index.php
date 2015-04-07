<?php

$movies = array_merge(glob("*.mp4"), glob("*.m4a"), glob("*.flv"));
rsort($movies);
$movies = array_map(function ($filename) {
  return array(
    'filename' => $filename,
    'filesize' => filesize($filename),
  );
}, $movies);

$scripts = array_merge(glob("*.sh"), glob("*.rb"));
$programs = file_get_contents("crontab.txt");

?>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css" rel="stylesheet" />
  <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>
  <title>声ラジアーカイバ</title>
  <style>
    .page-header { margin: 20px 0; }
    .page-header h1,
    .page-header h2 { margin: 0; }
    .cell-filename { vertical-align: middle !important; }
    .cell-watch { text-align: center; }
    .cell-download { text-align: center; }
  </style>
</head>
<body>
  <div class="container">
    <div class="page-header">
      <h1>声ラジアーカイバ</h1>
    </div>
    <div class="page-header">
      <h2>ファイル一覧</h2>
    </div>
<?php if (count($movies) == 0): ?>
    <p>ファイルがありません。</p>
<?php else: ?>
    <table class="table table-bordered table-striped">
      <thead>
      <tr>
        <th>ファイル名</th>
        <th>視聴</th>
        <th>ダウンロード</th>
      </tr>
      </thead>
      <tbody>
  <?php foreach ($movies as $movie): ?>
      <?php
        $filesize = sprintf("%.2f", $movie['filesize'] / 1000.0 / 1000.0);
      ?>
        <tr>
          <td class="cell-filename">
            <?= htmlspecialchars($movie['filename'], ENT_QUOTES) ?>
          </td>
          <td class="cell-watch">
            <a href="player.php?filename=<?= htmlspecialchars($movie['filename'], ENT_QUOTES) ?>" class="btn btn-primary">
              視聴する
            </a>
          </td>
          <td class="cell-download">
            <a href="<?= htmlspecialchars($movie['filename'], ENT_QUOTES) ?>" class="btn btn-default">
              ダウンロード（<?= htmlspecialchars($filesize, ENT_QUOTES) ?> MB）
            </a>
          </td>
        </tr>
  <?php endforeach ?>
      </tbody>
    </table>
<?php endif ?>
    <div class="page-header">
      <h2>対応局</h2>
    </div>
    <ul>
<?php foreach ($scripts as $script): ?>
      <li><?= htmlspecialchars($script, ENT_QUOTES) ?></li>
<?php endforeach ?>
    </ul>
    <div class="page-header">
      <h2>対象プログラム</h2>
    </div>
    <pre><?= htmlspecialchars($programs, ENT_QUOTES) ?></pre>
  </div>
</body>
</html>

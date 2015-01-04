<?php

$movies = array();
foreach (glob("*.flv") as $filename) {
  $movies[] = array(
    'filename' => $filename,
    'filesize' => filesize($filename),
  );
}

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
</head>
<body>
  <div class="container">
    <h1>声ラジアーカイバ</h1>
    <h2>ファイル一覧</h2>
<?php if (count($movies) == 0): ?>
    <p>ファイルがありません。</p>
<?php else: ?>
    <dl>
  <?php foreach ($movies as $movie): ?>
      <dt><a href="<?= htmlspecialchars($movie['filename'], ENT_QUOTES) ?>">
        <?= htmlspecialchars($movie['filename'], ENT_QUOTES) ?>
      </a></dt>
      <dd><?= htmlspecialchars(sprintf("%.2f", $movie['filesize'] / 1000.0 / 1000.0), ENT_QUOTES) ?> MB</dd>
  <?php endforeach ?>
    </dl>
<?php endif ?>
    <h2>対応局</h2>
    <ul>
<?php foreach ($scripts as $script): ?>
      <li><?= htmlspecialchars($script, ENT_QUOTES) ?></li>
<?php endforeach ?>
    </ul>
    <h2>対象プログラム</h2>
    <pre><?= htmlspecialchars($programs, ENT_QUOTES) ?></pre>
  </div>
</body>
</html>

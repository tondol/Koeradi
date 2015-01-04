<?php

$movies = array();
foreach (glob("*.flv") as $filename) {
  $movies[] = array(
    'filename' => $filename,
    'filesize' => filesize($filename),
  );
}

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
    <h2>対象プログラム</h2>
    <ul>
      <li>agqr-uchiasa (月 20:59 - 21:30)</li>
      <li>wallop-koncheki (火 21:29 - 22:00)</li>
      <li>agqr-igaitai (火 23:59 - 24:30)</li>
      <li>agqr-ageradi (水 18:29 - 19:00)</li>
    </ul>
    <h2>ファイル一覧</h2>
<?php if (count($movies) == 0): ?>
    <p>ファイルがありません。</p>
<?php else: ?>
    <dl>
  <?php foreach ($movies as $movie): ?>
      <dt><a href="<?= htmlspecialchars($movie['filename'], ENT_QUOTES) ?>">
        <?= htmlspecialchars($movie['filename'], ENT_QUOTES) ?>
      </a></dt>
      <dd><?= htmlspecialchars($movie['filesize'], ENT_QUOTES) ?> bytes</dd>
  <?php endforeach ?>
    </dl>
<?php endif ?>
  </div>
</body>
</html>
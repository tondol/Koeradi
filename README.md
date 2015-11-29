Koeradi
====

Koeradiは声優さんがMCをされているネットラジオ等をアーカイブするウェブアプリです。

Requirements
----

- Ruby（Version 1.9 もしくはそれ以降）
    - `hibiki.rb`を実行するため
- PHP（Version 5.4 もしくはそれ以降）
    - フロントエンドを実行するため
    - Composer
- rtmpdump
- ffmpeg
    - HLSとTLSに対応したビルド
- swftools

Install
----

### rtmpdump/ffmpeg/swftoolsの導入

詳細は割愛します。
新しめのソースをダウンロードして自前ビルドするのが確実です。

### 必要なファイル郡の設置

```
$ git clone https://github.com/tondol/Koeradi.git koeradi
$ cd koeradi
$ bundle install
$ php /path/to/composer.phar install
```

### .envの編集

設定ファイルである`.env`を新規作成し，編集します。
各種スクリプトはこの設定ファイルを参照して動作します。

```
CONTENTS_DIR=/home/foo/www/koeradi
CONTENTS_DIR_URI=http://foo.bar.com/koeradi
```

録音したファイルを保存するディレクトリと，
そのディレクトリにウェブUIからアクセスするときのURIを指定します。
後者はウェブUIを利用しない場合は指定不要です。

ウェブUIを利用するには，httpサーバー経由でリポジトリ直下のphpスクリプトと，
上記で設定した録音ファイルの保存先ディレクトリにブラウザアクセスできる必要があります。
ウェブUIを利用する場合は，**Basic認証などの方法によりアクセス制限の設定を追加すること**を強くお薦めします。

### crontabの設定

リポジトリ内の`crontab.txt`を見ながら設定ファイルを記述してください。
基本的には
「ファイル名に付加する番組名（整理用）」
「対象局を意味するID（対象スクリプトにより変化）」
「録音する長さ（秒）」
などを引数で与えます。
Radikoの場合はここにアカウントのメールアドレスやパスワードも与えます。

現在のダウンロードスクリプトが対応していない局を録音するには，
別途シェルスクリプトなりRubyなりでダウンロードスクリプトを新しく記述する必要があります。
もし新しくスクリプトを追加した場合は，プルリクを投げていただければこのリポジトリに取り込みます。

### (Optional) acdcliの設定

`acd_cron.sh`を定期実行することで，Amazon Cloud Driveにデータを自動コピーすることができます。
スクリプトの実行により，録音ファイルがAmazon Cloud Driveの指定ディレクトリにアップロードされ，
ローカルにはサイズ0のファイルのみが残されます。
自動コピー機能を利用した場合も，
ファイルの置き場所を意識することなくウェブ側のプレイヤーインターフェイスを利用することができます。

次のコマンドで依存コマンド`acd_cli`を導入します（比較的新しめのpython3が必要になります）。

```
$ pip3 install --upgrade git+https://github.com/yadayada/acd_cli.git
```

設定ファイル`.env`に次の2行を追記してください。
`acd_cli`のキャッシュファイルを置くディレクトリと，Amazon Cloud Drive側のアップロード先ディレクトリを指定します。

```
ACD_CLI_CACHE_PATH=/home/foo/www/koeradi/acdcli
ACD_CLI_CONTENTS_DIR=/koeradi
```

`acd_cli init`を実行し，
OAuth認証により生成された`oauth_data`を設定ファイルで指定したキャッシュディレクトリに置きます。
`acd_cron.sh`を実行するユーザーとplayer.phpを実行するユーザーの両方から，
キャッシュディレクトリ内のファイルを読み書きできるようにしてください。

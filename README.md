Koeradi
====

koeradiは声優さんがMCをされているネットラジオ等をアーカイブするウェブアプリです。

Requirements
----

- Perl
    - `radiko.sh`がワンライナーに依存しているため
- Ruby（Version 1.9 もしくはそれ以降）
    - `hibiki.rb`を実行するため
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
$ git clone https://github.com/tondol/koeradi.git
$ bundle install
```

### .envの記述

ファイルシステムから見た動画配置先と，ブラウザから見た動画配置先をそれぞれ設定します。
各種スクリプトはこの設定ファイルを参照して動作します。

```
CONTENTS_DIR=/home/foo/www/koeradi
CONTENTS_URI=http://foo.bar.com/koeradi/
```

### crontabの設定

リポジトリ内の`crontab.txt`を見ながら設定ファイルを記述してください。

現在のダウンロードスクリプトが対応していない局を録音するには，別途シェルスクリプトなりRubyなりでダウンロードスクリプトを新しく記述する必要があります。
もし新しくスクリプトを追加した場合は，プルリクを投げていただければこのリポジトリに取り込みます。

### apache/nginxの設定

リポジトリのディレクトリを公開ディレクトリ以下に配置することで動作します。
**Basic認証などの方法によりアクセス制限の設定を追加すること** を強くお薦めします。

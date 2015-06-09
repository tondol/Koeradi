koeradi
====

koeradiは声優さんがMCをされているネットラジオ等をアーカイブするウェブアプリです。

Requirements
----

- Perl
    - `radiko.sh`から呼び出すため
    - 将来的にはRubyスクリプトに移行する
- Ruby（Version 1.9 もしくはそれ以降）
    - `hibiki.rb`から呼び出すため
    - Nokogiri
- rtmpdump
- ffmpeg
    - Http Live Streamingに対応したVersion
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

```
CONTENTS_DIR=/home/foo/www/koeradi
CONTENTS_URI=http://foo.bar.com/koeradi/
```

### crontabの設定

リポジトリ内の`crontab.txt`を見ながら設定ファイルを記述してください。

現在のダウンロードスクリプトが対応していない局を録音するには，別途シェルスクリプトなりRubyなりでダウンロードスクリプトを新しく記述する必要があります。
もし新しくスクリプトを追加した場合は，プルリクを投げていただければこのリポジトリに取り込みます。

また，現在のダウンロードスクリプトが対応していない放送を録音するには，その局のダウンロードスクリプトを一部修正する必要があります。
具体的には，第1引数に与える放送IDに応じて，ダウンロード先のエンドポイント等を適切に設定する処理を追加していただくことになります。
こちらも，新しく記述を追加した場合は，プルリクを投げていただければこのリポジトリに取り込みます。

### apache/nginxの設定

リポジトリのディレクトリを公開ディレクトリ以下に配置することで動作します。
**Basic認証などの方法によりアクセス制限の設定を追加すること** を強くお薦めします。

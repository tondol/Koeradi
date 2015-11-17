#!/usr/local/bin/ruby
# -*- conding: utf-8 -*-

# ruby hibiki.rb name station
# name:    prefix for mp4 filename
# station: station id of hibiki radio station

require 'dotenv'
require 'json'
require 'net/http'
require 'pp'
require 'yaml'

charset = nil
uri = nil
tag = ARGV.shift
program = ARGV.shift
time = Time.now.strftime("%Y%m%d-%H%M-%a")
filename = "#{time}-hibiki-#{tag}"

# dotenv
Dotenv.load
Dir::chdir(ENV.key?("CONTENTS_DIR") ? ENV["CONTENTS_DIR"] : File.dirname($0))

# load programs
programs = YAML.load_file("hibiki.yml") if File.exist?("hibiki.yml")
programs ||= {}

# api programs
res = Net::HTTP.start('vcms-api.hibiki-radio.jp', use_ssl: true) {|http|
  req = Net::HTTP::Get.new('/api/v1/programs/' + program)
  req['X-Requested-With'] = 'XMLHttpRequest'
  http.request(req)
}
json = JSON.parse(res.body)
video_id = json['episode']['video']['id']

# api play_check
res = Net::HTTP.start('vcms-api.hibiki-radio.jp', use_ssl: true) {|http|
  req = Net::HTTP::Get.new('/api/v1/videos/play_check?video_id=' + video_id.to_s)
  req['X-Requested-With'] = 'XMLHttpRequest'
  http.request(req)
}
json = JSON.parse(res.body)
playpath = json['playlist_url']

if !programs.key?(tag) || programs[tag] != playpath
  # download playpath
  system("ffmpeg -re -i \"#{playpath}\"" +
    " -strict -2" +
    " -vcodec copy -acodec copy" +
    " -bsf:a aac_adtstoasc" +
    " #{filename}.mp4")

  # save programs
  programs[tag] = playpath
  File.write("hibiki.yml", programs.to_yaml)
end

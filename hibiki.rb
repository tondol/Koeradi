#!/usr/local/bin/ruby
# -*- conding: utf-8 -*-

require 'nokogiri'
require 'open-uri'
require 'pp'
require 'yaml'

charset = nil
uri = nil
tag = ARGV.shift
time = Time.now.strftime("%Y%m%d-%H%M-%a")
filename = "#{time}-hibiki-#{tag}"

# load programs
Dir::chdir(File.dirname($0))
programs = YAML.load_file("hibiki.yml") if File.exist?("hibiki.yml")
programs ||= {}

case tag
when "cafe" then
  uri = "http://hibiki-radio.jp/description/cafe"
when "nicorinpana" then
  uri = "http://hibiki-radio.jp/description/lovelive_ms"
when "imascg" then
  uri = "http://hibiki-radio.jp/description/imas_cg"
when "yutorin" then
  uri = "http://hibiki-radio.jp/description/aimin"
end

# download html
html = open(uri) {|f|
  charset = f.charset
  f.read
}

# parse
document = Nokogiri::HTML.parse(html, nil, charset)

# playpath
playpath = document.css('a').map {|node|
  href = node.attribute('href')
  if href && href.value.include?("m3u8")
    href.value
  else
    nil
  end
}.compact.first

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

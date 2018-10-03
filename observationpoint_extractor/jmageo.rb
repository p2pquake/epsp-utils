#!/usr/bin/env ruby

# 気象庁の震度観測点をデータ化する
require 'net/http'
require 'uri'

#body = Net::HTTP.get(URI.parse("http://www.data.jma.go.jp/svd/eqev/data/kyoshin/jma-shindo.html"))
body = File.read("./jma-shindo.html")

body.each_line { |line|
  items = line.scan(/<td>(.*?)<\/td>/)
  if items.size > 8 && items[8][0].strip.empty?
    output = []
    
    if items[0][0] =~ /(.+[都道府県])/
      output << $1
    elsif items[0][0] =~ /地方/
      output << "北海道"
    else
      output << items[0][0]
    end

    output << items[1][0]
    latitude = items[3][0].to_i + (items[4][0].to_f / 60)
    longitude = items[5][0].to_i + (items[6][0].to_f / 60)
    output << sprintf("%.3f", latitude)
    output << sprintf("%.3f", longitude)

    #puts "{\"#{output[0]}#{output[1]}\", {#{sprintf("%.3f", latitude)}, #{sprintf("%.3f", longitude)}}},"
    puts output.join(',')
  end
}


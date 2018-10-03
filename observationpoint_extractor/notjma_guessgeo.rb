#!/usr/bin/env ruby

jmageo = {}
File.open(ARGV[0]).each { |line|
  items = line.chomp.split(/,/)
  jmageo[items[1]] = [items[2].to_f, items[3].to_f]
}

# 西端・東端
jma_west = nil
jma_east = nil
# 北端・南端
jma_north = nil
jma_south = nil

othergeo = {}
File.open(ARGV[1]).each { |line|
  if line =~ /coords="(\d+),(\d+),.+(気象庁) +([^"]+)/
    x = $1.to_i
    y = $2.to_i
    name = $4

    jma_west = [name, x, y] if !jma_west || jma_west[1] > x
    jma_east = [name, x, y] if !jma_east || jma_east[1] < x
    jma_north = [name, x, y] if !jma_north || jma_north[2] > y
    jma_south = [name, x, y] if !jma_south || jma_south[2] < y
  end
  if line =~ /coords="(\d+),(\d+),.+(防災科学技術研究所|地方公共団体) +([^"]+)/
    othergeo[$4] = [$1.to_i, $2.to_i, $3]
  end
}

# 緯度・経度に変換する
# オフセット

#puts "/#{jma_west[0]}/#{jmageo[jma_west[0]]}/"
#puts "/#{jma_east[0]}/#{jmageo[jma_east[0]]}/"
#puts "/#{jma_north[0]}/#{jmageo[jma_north[0]]}/"
#puts "/#{jma_south[0]}/#{jmageo[jma_south[0]]}/"

offset_x = jma_west[1]
offset_longi = jmageo[jma_west[0]][1]
unit_x = (jmageo[jma_east[0]][1] - jmageo[jma_west[0]][1]) / (jma_east[1] - jma_west[1])

offset_y = jma_north[2]
offset_lati = jmageo[jma_north[0]][0]
unit_y = (jmageo[jma_south[0]][0] - jmageo[jma_north[0]][0]) / (jma_south[2] - jma_north[2])

#puts "#{offset_x} (#{offset_longi}): #{unit_x}/pixel"
#puts "#{offset_y} (#{offset_lati}): #{unit_y}/pixel"

othergeo = othergeo.map { |k,v|
  [k, [v[2], (v[1] - offset_y) * unit_y + offset_lati, (v[0] - offset_x) * unit_x + offset_longi]]
}

othergeo.each { |k,v|
  #puts "#{k}(#{v[0]}): [#{v[1]}, #{v[2]}]"
  puts ",#{k},#{sprintf("%.3f", v[1])},#{sprintf("%.3f", v[2])}"
}


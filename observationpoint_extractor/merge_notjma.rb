#!/usr/bin/env ruby

notjma = {}
Dir::glob("*_*.txt").sort.each { |filename|
  File.open(filename).each { |line|
    items = line.chomp.split(/,/)
    notjma[items[1]] = [items[2], items[3]]
  }
}

notjma.each { |k,v|
  puts ",#{k},#{v[0]},#{v[1]}"
}


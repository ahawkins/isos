#!/usr/bin/env ruby

require 'json'
require 'time'
require 'erb'

Entry = Struct.new(:image, :date, :location)
Section = Struct.new(:date, :entries)

@entries = JSON.load($stdin).map do |data|
  Entry.new.tap do |entry|
    entry.image = "images/#{data.fetch('image')}"
    entry.location = data.fetch('location')
    entry.date = Time.parse(data.fetch('date'))
  end
end.sort do |e1, e2|
  e2.date <=> e1.date
end

puts ERB.new(File.read('template.erb')).result

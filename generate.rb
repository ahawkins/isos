#!/usr/bin/env ruby

require 'json'
require 'time'
require 'erb'
require 'open3'

Entry = Struct.new(:image, :date, :location)
Section = Struct.new(:date, :entries)

ExifError = Class.new StandardError

@entries = JSON.load($stdin).map do |data|
  Entry.new.tap do |entry|
    entry.image = "images/#{data.fetch('image')}"
    entry.location = data.fetch('location')

    stdin, stdout, stderr, exif = Open3.popen3 %Q{exif -t "Date and Time" --machine-readable "images/#{data.fetch('image')}"}

    if exif.value.success?
      raw = stdout.read
      parts = raw.split ' '
      year = parts[0].gsub(':', '-')
      time = parts[1]

      stdout.close
      stderr.close

      entry.date = Time.parse "#{year}T#{time}Z"
    else
      fail ExifError, "#{data.fetch('image')} - #{stderr.read}"
    end
  end
end.sort do |e1, e2|
  e2.date <=> e1.date
end

puts ERB.new(File.read('template.erb')).result

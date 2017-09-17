#!/usr/bin/env ruby

require 'json'
require 'time'
require 'erb'
require 'open3'

Entry = Struct.new(:image, :date, :location, :aspect_ratio)
Section = Struct.new(:date, :entries)

ExifError = Class.new StandardError
IdentifyError = Class.new StandardError

@entries = JSON.load($stdin).map do |data|
  Entry.new.tap do |entry|
    entry.image = "images/#{data.fetch('image')}"
    entry.location = data.fetch('location')

    if !File.exists?(entry.image)
      abort "No such file: #{entry.image}"
    end

    stdin, stdout, stderr, exif = Open3.popen3 %Q{exif -t "Date and Time (Original)" --machine-readable "#{entry.image}"}

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

    stdin, stdout, stderr, identify = Open3.popen3 %Q{identify -format "%[fx:w/h]\n" "images/#{data.fetch('image')}"}

    if identify.value.success?
      aspect_ratio = stdout.read.to_f.round(1)

      stdout.close
      stderr.close

      entry.aspect_ratio = case aspect_ratio
                            when 1.6..1.8 then '16-9'
                            when 1.5 then '3-2'
                            when 1.3 then '4-3'
                            else
                              fail "Unknown aspect ratio: #{aspect_ratio} for #{data.fetch('image')}"
                            end
    else
      fail IdentifyError, "#{data.fetch('image')} - #{stderr.read}"
    end
  end
end.sort do |e1, e2|
  e2.date <=> e1.date
end

puts ERB.new(File.read('template.erb')).result

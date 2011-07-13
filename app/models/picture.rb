require 'carrierwave/orm/mongoid'

class Picture
  extend ActiveSupport::Memoizable
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessor :location_name

  mount_uploader :image, PictureUploader
  field :taken_at, :type => Time
  field :description, :type => String

  embeds_one :location

  before_create :make_location
  before_create :set_timestamp

  index :taken_at

  def has_location?
    exif.gps_latitude && exif.gps_longitude
  end

  def exif
    EXIFR::JPEG.new(image.file.file)
  end
  memoize :exif

  private
  def make_location
    return unless has_location?
    create_location :latitude => gps_coords.first, :longitude => gps_coords.last, :name => location_name
  end

  def gps_coords
    lat = exif.gps_latitude[0].to_f + (exif.gps_latitude[1].to_f / 60) + (exif.gps_latitude[2].to_f / 3600)
    long = exif.gps_longitude[0].to_f + (exif.gps_longitude[1].to_f / 60) + (exif.gps_longitude[2].to_f / 3600)
    long = long * -1 if exif.gps_longitude_ref == "W"
    lat = lat * -1 if exif.gps_latitude_ref == "S"

    [lat, long]
  end

  def set_timestamp
    self.taken_at = exif.date_time
  end
end

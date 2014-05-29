require 'carrierwave/mongoid'
require 'open-uri'

class Picture
  include Mongoid::Document

  mount_uploader :image, PictureUploader
  field :taken_at, :type => Time

  embedded_in :post

  scope :most_recent, order_by(['taken_at', :desc]).limit(1)

  before_create :set_timestamp

  index taken_at: 1

  def latitude
    gps_coords[0] if has_location?
  end

  def longitude
    gps_coords[1] if has_location?
  end

  def has_location?
    exif.gps_latitude && exif.gps_longitude
  end

  def exif
    @exif ||= begin
      if new_record?
        EXIFR::JPEG.new(image.file.file)
      else
        EXIFR::JPEG.new(open(image.url))
      end
    end
  end

  private
  def gps_coords
    lat = exif.gps_latitude[0].to_f + (exif.gps_latitude[1].to_f / 60) + (exif.gps_latitude[2].to_f / 3600)
    long = exif.gps_longitude[0].to_f + (exif.gps_longitude[1].to_f / 60) + (exif.gps_longitude[2].to_f / 3600)
    long = long * -1 if exif.gps_longitude_ref == "W"
    lat = lat * -1 if exif.gps_latitude_ref == "S"

    [lat, long]
  end

  def set_timestamp
    self.taken_at = exif.date_time || exif.date_time_original
  end
end

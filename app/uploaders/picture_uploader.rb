# encoding: utf-8

require 'carrierwave/processing/mime_types'

class PictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include CarrierWave::MimeTypes

  process :set_content_type

  version :gallery do
    process :resize_to_fill => [576, 432]
  end

  version :wall do
    process :resize_to_fill => [360, 270]
  end

  version :thumb do
    process :resize_to_fill => [115, 86]
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "#{model.class.name.underscore}/#{mounted_as}/#{model.id}"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg png)
  end
end

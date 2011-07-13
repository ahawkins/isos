require 'spec_helper'

describe Picture do
  it "should be able to upload pictures" do
    picture = Picture.new
    picture.image = File.open(Rails.root.join('spec/support/pictures/without_location.jpg'))
    picture.save!
  end

  it "should use the exif data to store when the picture was taken" do
    picture = Picture.new
    picture.image = File.open(Rails.root.join('spec/support/pictures/without_location.jpg'))
    picture.save!
    picture.taken_at.should eql(picture.exif.date_time)
  end

  it "should be able to get locations from pictures" do
    picture = Picture.new
    picture.image = File.open(Rails.root.join('spec/support/pictures/helsinki_with_location.jpg'))
    picture.location_name = 'Helsinki Bridge'
    picture.save!

    picture.location.should_not be_nil
    picture.location.name.should eql('Helsinki Bridge')
    picture.location.latitude.should_not be_blank
    picture.location.longitude.should_not be_blank
  end
end

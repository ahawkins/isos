require 'spec_helper'

describe Post do
  it { should embed_one(:location) }
  it { should embed_one(:picture) }
  it { should embed_one(:track) }

  it { should have_field(:message) }

  it { should validate_presence_of(:location) }

  describe "Uploading pictures" do
    subject { Post.new.build_picture }

    it "should be able to upload pictures" do
      subject.image = File.open(Rails.root.join('spec/support/pictures/without_location.jpg'))
      subject.save!
    end

    it "should use the exif data to store when the picture was taken" do
      subject.image = File.open(Rails.root.join('spec/support/pictures/without_location.jpg'))
      subject.save!
      subject.taken_at.should eql(subject.exif.date_time_original)
    end

    it "should be able to get locations from pictures" do
      subject.image = File.open(Rails.root.join('spec/support/pictures/helsinki_with_location.jpg'))
      subject.save!

      subject.should have_location
      subject.latitude.should_not be_blank
      subject.longitude.should_not be_blank
    end
  end
end

require 'spec_helper'

describe Location do
  describe "When there is no name, it should required gps" do
    subject { Post.new.build_location :name => nil }

    it { should validate_presence_of(:latitude) }
    it { should validate_presence_of(:longitude) }
  end
end

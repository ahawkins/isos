require 'spec_helper'
require 'twitter_scraper'
require 'hashie'

describe TwitterScraper do
  subject { TwitterScraper }

  it "should find tweets from twitter" do
    mock_twitter = mock(Twitter::Search)
    Twitter::Search.stub(:new).and_return(mock_twitter)
    mock_twitter.should_receive(:from).with('Adman65')
    mock_twitter.should_receive(:hashtag).with('#isos')
    mock_twitter.should_receive(:fetch).and_return([])

    subject.tweets
  end

  describe "the tweet wrapper" do
    describe "gps info" do
      it "should use the geo info for the coords" do
        hashie = Hashie::Mash.new(:geo => {:coordinates => [1,0]})
        tweet = TwitterScraper::Tweet.new(hashie)
        tweet.geo_coords.should eql([1,0])
      end
    end

    describe "finding the track" do
      it "should be able to find the track in a tweet" do
        hashie = Hashie::Mash.new(:text => 't:JPL - We Move in Symmetry:')
        tweet = TwitterScraper::Tweet.new(hashie)
        tweet.track.should eql('JPL - We Move in Symmetry')
      end

      it "should return nil if there is no track" do
        hashie = Hashie::Mash.new(:text => 'crossing the globe')
        tweet = TwitterScraper::Tweet.new(hashie)
        tweet.track.should be_nil
      end

      it "should not get confused by a url" do
        hashie = Hashie::Mash.new(:text => 't:JPL - We Move in Symmetry: http://t.co/23847')
        tweet = TwitterScraper::Tweet.new(hashie)
        tweet.track.should eql('JPL - We Move in Symmetry')
      end

      it "should be able to find the artist" do
        hashie = Hashie::Mash.new(:text => 't:JPL - We Move in Symmetry: http://t.co/23847')
        tweet = TwitterScraper::Tweet.new(hashie)
        tweet.artist.should eql('JPL')
      end

      it "should be able to find the name" do
        hashie = Hashie::Mash.new(:text => 'Crossing the globe l:32,000ft: t:JPL - We Move in Symmetry: #isos http://t.co/pe6MIoV')
        tweet = TwitterScraper::Tweet.new(hashie)
        tweet.track_name.should eql('We Move in Symmetry')
      end
    end

    describe "finding the location" do
      it "should be able to find the location in a tweet" do
        hashie = Hashie::Mash.new(:text => 'l:Helsinki:')
        tweet = TwitterScraper::Tweet.new(hashie)
        tweet.location.should eql('Helsinki')
      end

      it "should return nil if there is no track" do
        hashie = Hashie::Mash.new(:text => 'crossing the globe')
        tweet = TwitterScraper::Tweet.new(hashie)
        tweet.location.should be_nil
      end

      it "should not get confused by a url" do
        hashie = Hashie::Mash.new(:text => 'l:Helsinki: http://t.co/23847')
        tweet = TwitterScraper::Tweet.new(hashie)
        tweet.location.should eql('Helsinki')
      end
    end

    describe "Extracting the status update" do
      it "should be the message if that's it" do
        hashie = Hashie::Mash.new(:text => 'crossing the globe')
        tweet = TwitterScraper::Tweet.new(hashie)
        tweet.message.should eql('crossing the globe')
      end

      it "should not include the track" do
        hashie = Hashie::Mash.new(:text => 'crossing the globe t:ISOS6:')
        tweet = TwitterScraper::Tweet.new(hashie)
        tweet.message.should eql('crossing the globe')
      end

      it "should not include the location" do
        hashie = Hashie::Mash.new(:text => 'crossing the globe l:Helsinki:')
        tweet = TwitterScraper::Tweet.new(hashie)
        tweet.message.should eql('crossing the globe')
      end

      it "should not include the hashtag" do
        hashie = Hashie::Mash.new(:text => 'crossing the globe #isos')
        tweet = TwitterScraper::Tweet.new(hashie)
        tweet.message.should eql('crossing the globe')
      end

      it "should not include the picture link" do
        hashie = Hashie::Mash.new(:text => 'crossing the globe http://t.co/38zFxu #isos')
        tweet = TwitterScraper::Tweet.new(hashie)
        tweet.message.should eql('crossing the globe')
      end

      it "should remove all the extra stuff" do
        hashie = Hashie::Mash.new(:text => 'crossing the globe t:jpl: l:32000ft: http://t.co/38zFxu #isos')
        tweet = TwitterScraper::Tweet.new(hashie)
        tweet.message.should eql('crossing the globe')
      end
    end
  end
end

require 'fileutils'

class TwitterScraper
  FEED = 'Adman65'
  HASH_TAG = '#isos'

  def self.tweets
    # search = Twitter::Search.new
    # search.from FEED
    # search.hashtag HASH_TAG
    # search.fetch.map {|t| Tweet.new(t) }
    Twitter.search("from:#{FEED} #{HASH_TAG}", :result_type => "recent").results.map do |status|
      Tweet.new status
    end
  end

  def self.from_ids(twitter_ids)
    twitter_ids.map do |twitter_id|
      Tweet.new(Twitter.status(twitter_id))
    end
  end

  def self.find(id)
    Tweet.new(Twitter.status(id))
  end

  class Tweet
    def initialize(tweet)
      @tweet = tweet
    end

    def id
      @tweet.id
    end

    def geo_coords
      return unless @tweet.geo
      @tweet.geo.coordinates
    end

    def latitude
      return unless geo_coords
      geo_coords.first
    end

    def longitude
      return unless geo_coords
      geo_coords[1]
    end

    def track
      match = @tweet.text.match(/(?:\A|\s)t:([^:]+):/)
      match ? match[1] : nil
    end

    def artist
      return unless track
      track.match(/(.+)\s\-/)[1]
    end

    def track_name
      return unless track
      track.match(/\-\s(.+)/)[1]
    end

    def location
      match = @tweet.text.match(/(?:\A|\s)l:([^:]+):/)
      match ? match[1] : nil
    end

    def message
      m = @tweet.text.dup
      m.gsub!(/[tl]{1}:[^:]+:/, '')
      m.gsub!(/http:\/\/.+\/.+\b?/, '')
      m.gsub!(/#.+\b/, '')
      m.strip
    end

    def created_at
      @tweet.created_at
    end

    def text
      @tweet.text
    end

    def picture
      if @tweet.media.empty? && contains_link?
        text.match(url_regexp)[1]
      elsif @tweet.media.any?
        @tweet.media.first.media_url
      else
        nil
      end
    end

    private
    def contains_link?
      text =~ url_regexp
    end

    def url_regexp
      /(http:\/\/[^\s]+)[$\z\s]?/
    end
  end
end

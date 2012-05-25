class TwitterScraper
  FEED = 'Adman65'
  HASH_TAG = '#isos'

  def self.tweets
    search = Twitter::Search.new
    search.from FEED
    search.hashtag HASH_TAG
    search.fetch.map {|t| Tweet.new(t) }
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
      return unless picture_link

      agent = Mechanize.new
      page = agent.get picture_link

      if page.uri.host =~ /twitpic/i
        TwitPicScraper.scrape page
      elsif page.uri.host =~ /yfrog/
        YFrogScraper.scrape page
      elsif page.uri.host =~ /twitter/
        TwitterPhotoScraper.scrape page
      end
    end

    private
    def picture_link
      match = text.match(/(http:\/\/.+\/.+)/)
      if match
        match[1]
      else
        nil
      end
    end

    class YFrogScraper
      def self.scrape(page)
        page.link_with(:text => 'Direct').href
      end
    end

    class TwitPicScraper
      def self.scrape(page)
        page = page.links.find {|l| l.href =~ /full/ }.click
        page.search('//body/img').first.attr('src')
      end
    end

    class TwitterPhotoScraper
      def self.scrape(page)
        tweet_id = page.uri.to_s.split('/').reverse[2]

        page = page.links.select { |l| l.href == "#{page.uri}/large" }.first.click
        src = page.search("img.large.media-slideshow-image").first.attr('src')

        full_path = Rails.root.join "tmp", "#{tweet_id}.jpg"

        Curl::Easy.download(src, full_path)

        File.open full_path
      end
    end
  end
end

require 'time'

task :tweets => :environment do
  require 'twitter_scraper'
  TwitterScraper.tweets.each do |tweet|
    puts tweet.text
  end
end

task :scrape => :environment do
  require 'twitter_scraper'
  require 'tweet_importer'
  TwitterScraper.tweets.each do |tweet|
    TweetImporter.import! tweet
  end
end

desc "Sync development db with current db since twitter is a cunt"
task :sync => :environment do
  hashes = JSON.parse(open('http://isos.broadcastingadam.com/posts.json').read)

  hashes.each do |hash|
    next unless hash['posted_at']

    post = Post.new

    post.message = hash.fetch 'message'

    if hash['track']
      post.build_track :artist => hash.fetch('track').fetch('artist'), :name => hash.fetch('track').fetch('name')
    end

    if hash['picture']
      post.create_picture :remote_image_url => hash['picture']['image']['url']
    end

    if hash['location']
      post.build_location :latitude => hash['location']['latitude'], :longitude => hash['location']['longitude'], :name => hash['location']['name']
    end

    post.posted_at = Time.parse hash.fetch('posted_at')
    post.twitter_id = hash.fetch 'twitter_id', nil

    post.save!
  end
end

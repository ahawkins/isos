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
  require 'twitter_scraper'
  require 'tweet_importer'

  hashes = JSON.parse(open('http://isos.broadcastingadam.com/posts.json').read)
  twitter_ids = hashes.map {|h| h['twitter_id'] }.compact

  TwitterScraper.from_ids(twitter_ids[0..20]).each do |tweet|
    TweetImporter.import! tweet
  end
end

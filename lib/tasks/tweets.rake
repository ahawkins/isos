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

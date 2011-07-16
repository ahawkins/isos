require 'open-uri'
require 'ruby-debug'
class TweetImporter
  def self.import!(tweet)
    return if Post.exists?(:conditions => {:twitter_id => tweet.id})

    begin
      post = Post.new

      puts "Processing: #{tweet.text} #{tweet.id}"

      post.message = tweet.message

      if tweet.track
        post.build_track :artist => tweet.artist, :name => tweet.track_name
      end

      if tweet.picture
        post.create_picture :remote_image_url => tweet.picture, :location_name => tweet.location
      end

      if post.picture && post.picture.has_location?
        post.build_location :latitude => post.picture.latitude, :longitude => post.picture.longitude, :name => tweet.location
      else
        post.build_location :latitude => tweet.latitude, :longitude => tweet.longitude, :name => tweet.location
      end

      if post.picture
        post.posted_at = post.picture.taken_at
      else
        post.posted_at = tweet.created_at
      end

      post.twitter_id = tweet.id

      post.save!
    rescue Exception => ex
      puts "Error occured, continuing on COMMANDER"
      puts ex
    end
  end
end
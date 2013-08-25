require 'open-uri'

class TweetImporter
  def self.import!(tweet)
    return if Post.where(twitter_id: tweet.id).exists?

    begin
      post = Post.new

      puts "Processing: #{tweet.text} #{tweet.id}"

      post.message = tweet.message

      if tweet.track
        post.build_track :artist => tweet.artist, :name => tweet.track_name
      end

      if tweet.picture && tweet.picture.is_a?(String)
        post.create_picture :remote_image_url => tweet.picture, :location_name => tweet.location
      elsif tweet.picture
        post.create_picture :image => tweet.picture, :location_name => tweet.location
      end

      if post.picture && post.picture.has_location?
        post.build_location :latitude => post.picture.latitude, :longitude => post.picture.longitude, :name => tweet.location
      else
        post.build_location :latitude => tweet.latitude, :longitude => tweet.longitude, :name => tweet.location
      end

      if post.picture && post.picture.taken_at
        post.posted_at = post.picture.taken_at
      else
        post.posted_at = tweet.created_at
      end

      post.twitter_id = tweet.id

      post.save!
    rescue Exception => ex
      puts "Error occured, continuing on COMMANDER"
      puts ex
      puts ex.backtrace.join("\n") if Rails.env == 'development'
    end
  end
end

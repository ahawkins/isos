class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  field :posted_at, :type => Time
  field :message, :type => String
  field :twitter_id, :type => Integer

  embeds_one :picture
  embeds_one :track
  embeds_one :location

  scope :with_picture, where(:picture.exists => true)
  scope :with_track, where(:track.exists => true)

  default_scope order_by([:posted_at, :desc])

  delegate :exif, :to => :picture

  index [:posted_at, :desc]

  validates_presence_of :location
end

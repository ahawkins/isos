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
  scope :with_latitude_and_longitude, where(:'location.latitude'.exists => true, :'location.longitude'.exists => true)
  scope :locations, where(:'location.name'.exists => true).order_by('location.name ASC').distinct('location.name')

  default_scope order_by([:posted_at, :desc])

  delegate :exif, :to => :picture

  index :posted_at

  validates_presence_of :location
end

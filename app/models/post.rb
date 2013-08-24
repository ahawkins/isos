class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  field :posted_at, :type => Time
  field :message, :type => String
  field :twitter_id, :type => Integer

  embeds_one :picture, cascade_callbacks: true
  embeds_one :track
  embeds_one :location

  scope :with_picture, where(:picture.exists => true)
  scope :with_track, where(:track.exists => true)
  scope :with_latitude_and_longitude, where(:'location.latitude'.exists => true, :'location.longitude'.exists => true)

  default_scope order_by([:posted_at, :desc])

  delegate :exif, :to => :picture

  index :posted_at => 1

  validates_presence_of :location

  def self.picture(picture_id)
    where(:'picture._id' => Moped::BSON::ObjectId(picture_id)).first.picture
  end

  def self.locations
    Post.unscoped.where(:'location.name'.exists => true).order_by('location.name ASC').distinct('location.name').compact
  end
end

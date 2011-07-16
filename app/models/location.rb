class Location
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :longitude, :type => Float
  field :latitude, :type => Float

  embedded_in :post

  index [:name, :asc]

  validates_presence_of :longitude, :latitude, :if => proc { |l| l.name.blank? }
end

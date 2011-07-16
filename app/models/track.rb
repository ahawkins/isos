class Track
  include Mongoid::Document
  include Mongoid::Timestamps

  field :artist, :type => String
  field :name, :type => String

  embedded_in :post

  index [:artist, :asc]

  def to_s
    "#{artist} - #{name}"
  end
end

class Location
  include Mongoid::Document

  field :name, :type => String
  field :longitude, :type => BigDecimal
  field :latitude, :type => BigDecimal

  embedded_in :post

  index name: 1

  validates_presence_of :longitude, :latitude, :if => proc { |l| l.name.blank? }
end

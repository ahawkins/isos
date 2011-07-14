class Location
  include Mongoid::Document

  field :name, :type => String
  field :longitude, :type => BigDecimal
  field :latitude, :type => BigDecimal

  embedded_in :picture
end

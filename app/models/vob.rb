class Vob
  include Mongoid::Document
  include Mongoid::Geospatial
  include Mongoid::Timestamps
  
  belongs_to :user

  geo_field :location
  field :content, type: String, default: ''

  def self.nearby(distance, longitude, latitude)
    distance_degrees = distance.to_f / 69.0
    location = [longitude.to_f, latitude.to_f]
    query = near(location: location).max_distance(location: distance_degrees)
    nearby_vob_ids = query.map {|v| v.id.to_s }
    all.to_a.map do |vob|
      vob_json = vob.as_json
      vob_json['nearby'] = nearby_vob_ids.include?(vob.id.to_s) ? 1 : 0
      vob_json
    end
  end

  def as_json(options = {})
    result = super(options)
    result['user_id'] = user.uid
    result
  end
end

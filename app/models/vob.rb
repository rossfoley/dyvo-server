class Vob
  include Mongoid::Document
  include Mongoid::Geospatial
  
  belongs_to :user

  geo_field :location
  field :content, type: String, default: ''

  def as_json(options = {})
    result = super(options)
    result['user_id'] = user.uid
    result
  end
end

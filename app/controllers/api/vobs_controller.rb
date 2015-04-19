class Api::VobsController < Api::BaseController
  def index
    success Vob.all.map &:as_json
  end

  def within
    distance_degrees = params[:distance].to_f / 69.0
    location = [params[:longitude].to_f, params[:latitude].to_f]
    query = Vob.near(location: location).max_distance(location: distance_degrees)
    success query.map &:as_json
  end
end

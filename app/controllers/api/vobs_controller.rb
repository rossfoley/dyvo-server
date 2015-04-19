class Api::VobsController < Api::BaseController
  before_filter :load_vob

  def index
    success Vob.all.to_a
  end

  def show
    success @vob
  end

  def destroy
    if @vob.destroy
      success
    end
  end

  def create
    @vob = current_user.vobs.create(vob_data)
    success @vob
  end

  def update
    if @vob.update_attributes vob_data
      success @vob
    end
  end

  def within
    distance_degrees = params[:distance].to_f / 69.0
    location = [params[:longitude].to_f, params[:latitude].to_f]
    query = Vob.near(location: location).max_distance(location: distance_degrees)
    success query.to_a
  end

  private

  def load_vob
    if params[:id]
      @vob = Vob.find(params[:id])
      unless @vob
        failure :not_found, 'VOB with specified ID does not exist'
      end
    end
  end

  def vob_data
    if params[:vob_data]
      if params[:vob_data].is_a? String
        vob_data = JSON.parse params[:vob_data]
      else
        vob_data = params.require(:vob_data).permit!
      end
      longitude = vob_data.delete 'longitude'
      latitude = vob_data.delete 'latitude'
      vob_data['location'] = [longitude.to_f, latitude.to_f]
      vob_data
    end
  end
end

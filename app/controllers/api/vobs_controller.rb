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
    success Vob.nearby(params[:distance], params[:longitude], params[:latitude])
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
    vob_data = params.permit(:content, :longitude, :latitude)
    longitude = vob_data.delete :longitude
    latitude = vob_data.delete :latitude
    vob_data[:location] = [longitude.to_f, latitude.to_f]
    vob_data
  end
end

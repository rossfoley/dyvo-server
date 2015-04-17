class Api::RoomsController < Api::BaseController
  before_filter :load_room

  def index
    success Room.all.to_a
  end

  def show
    success @room
  end

  def update
    if @room.update_attributes room_data
      if room_data.has_key? 'playlist' or room_data.has_key? :playlist
        @room.started_at = DateTime.now
        @room.save
      end
      success @room
    else
      failure :conflict, 'That room name is already in use' 
    end
  end

  def create
    @room = Room.create(room_data)
    if @room.valid?
      @room.add_band_member current_user
      @room.initialize_playlist
      success @room
    else
      failure :conflict, 'A room with that name already exists!'
    end
  end

  def destroy
    if @room.destroy
      success
    end
  end

  def search
    success Room.full_text_search(params[:search_term]).to_a
  end

  def current_song
    success @room.current_song
  end

  def add_band_member
    user = User.where(username: params[:new_member_username]).first
    if user
      @room.add_band_member(user)
      success @room
    else
      failure :not_found, 'User with specified username does not exist'
    end
  end

  private

  def load_room
    if params[:id]
      @room = Room.find(params[:id])
      unless @room
        failure :not_found, 'Room with specified ID does not exist'
      end
    end
  end

  def room_data
    if params[:room_data]
      if params[:room_data].is_a? String
        JSON.parse params[:room_data]
      else
        params.require(:room_data).permit!
      end
    end
  end
end

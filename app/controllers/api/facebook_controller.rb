class Api::FacebookController < BaseController
  def login
    info = FacebookService.get_user_info params[:access_token]
    if info.nil?
      failure :unprocessable_entity, 'Unable to login user'
    else
      user = User.from_facebook(info)
      user.access_token = params[:access_token]
      user.save
      FacebookService.refresh_friends user
      
      success user.as_json
    end
  end

  def verify_callback
    if params['hub.verify_token'] == 'dyvorosschrisdan'
      render json: params['hub.challenge']
    end
  end

  def handle_callback
    params['entry'].each do |entry|
      user = User.where(uid: entry['id']).first
      unless user.nil?
        if entry['changed_fields'].include? 'friends'
          FacebookService.refresh_friends user
        end
        if entry['changed_fields'].include? 'name'
          info = FacebookService.get_user_info user.access_token
          unless info.nil?
            user.name = info['name']
            user.first_name = info['first_name']
            user.last_name = info['last_name']
            user.save
          end
        end
      end
    end

    head :ok
  end
end

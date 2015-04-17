require 'rubygems'
require 'open-uri'
require 'json'

class FacebookService
  def self.refresh_friends(user)
    url = "https://graph.facebook.com/me/friends?access_token=#{user.access_token}"
    request = nil
    begin
      request = open(url)
    rescue Exception => e
    end

    unless request.nil?
      if request.status == ['200', 'OK']
        response = JSON.parse(request.read)
        unless response.has_key? 'error'
          user.remove_all_friends
          friend_ids = response['data'].map {|friend| friend['id']}
          friends = User.in(uid: friend_ids).to_a
          friends.each do |friend|
            user.make_friendship friend
          end
        end
      end
    end
  end

  def self.get_user_info(access_token)
    url = "https://graph.facebook.com/me/?access_token=#{access_token}"
    request = nil

    begin
      request = open(url)
    rescue Exception => e
      nil
    end

    unless request.nil?
      if request.status == ['200', 'OK']
        response = JSON.parse(request.read)
        if response.has_key? 'error'
          nil
        else
          response
        end
      end
    end
  end
end
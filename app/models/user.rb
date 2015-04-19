class User
  include Mongoid::Document

  ################
  # Devise Setup #
  ################

  acts_as_token_authenticatable
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Database Authenticatable
  field :email, type: String, default: ''
  field :encrypted_password, type: String

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  # Facebook Information
  field :name, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :uid, type: String
  field :provider, type: String
  field :authentication_token, type: String
  field :friend_ids, type: Array, default: []
  field :access_token, type: String, default: ''

  # VOBs
  has_many :vobs

  ##################
  # Facebook Login #
  ##################

  def self.from_facebook(data)
    user = any_of({uid: data['id']}, {email: data['email']}).first
    user = User.create if user.nil?
    user.email = data['email'] || Devise.friendly_token + '@dyvo.herokuapp.com'
    user.password = Devise.friendly_token[0,20]
    user.uid = data['id']
    user.provider = 'facebook'
    user.name = data['name']
    user.first_name = data['first_name']
    user.last_name = data['last_name']
    user
  end

  ##################
  # Friend Methods #
  ##################

  def make_friendship(friend)
    self.add_friend(friend)
    friend.add_friend(self)
  end

  def break_friendship(friend)
    self.remove_friend(friend)
    friend.remove_friend(self)
  end

  def friends
    User.in(uid: friend_ids).to_a
  end

  def is_friends_with? other_user
    friend_ids.include? other_user.uid
  end

  def add_friend(friend)
    unless is_friends_with? friend
      friend_ids << friend.uid
      save
    end
  end

  def remove_friend(friend)
    friend_ids.delete friend.uid
    save
  end

  def remove_all_friends
    friends.each do |friend|
      break_friendship friend
    end
  end

  def filtered_friends
    friends.map do |friend|
      friend.filtered_json
    end
  end

  ###################
  # Utility Methods #
  ###################

  def filtered_json
    excluded = ['encrypted_password', 'password_salt', 'authentication_token', 'access_token']
    as_json.delete_if do |key|
      key.in? excluded
    end
  end

  # Necessary to make Devise work with Rails 4.1 and Mongoid
  def self.serialize_from_session(key, salt)
    record = to_adapter.get(key[0]["$oid"])
    record if record && record.authenticatable_salt == salt
  end
end

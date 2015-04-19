class Api::UsersController < ApplicationController
  before_filter :load_user

  def show
    success @user.filtered_json
  end

  def friends
    success @user.filtered_friends
  end

  def vobs
    success @user.vobs.map &:as_json
  end

  private

  def load_user
    if params.has_key? :id
      @user = User.where(uid: params[:id]).first
    else
      @user = current_user
    end

    if @user.nil?
      failure :not_found, 'User was not found'
    end
  end
end

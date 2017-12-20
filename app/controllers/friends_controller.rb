class FriendsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user, only: %i(show destroy)
  before_action :find_friend, only: :update
  before_action :correct_user, only: :show
  authorize_resource

  def index
    @user = User.find_by id: params[:user_id]
    return unless @user
    @title = t "users.friended.title"
    array_id = Friend.friend_list_id params[:user_id]
    @friends = User.friend_of_user(array_id).order_by_created_at.paginate page: params[:page]
  end

  def destroy
    destroy_friend params[:id], current_user.id
    reponse_action
  end

  def show
    if params[:role]
      user_ids = Friend.sender(@user.id).status_request(false).pluck(:accepter_id)
      @friends = User.user_by_ids(user_ids).paginate page: params[:page]
      render "show_pending"
    else
      user_ids = Friend.accepter(@user.id).status_request(false).pluck(:sender_id)
      @friends = User.user_by_ids(user_ids).paginate page: params[:page]
    end
  end

  def create
    @user = User.find_by id: params[:accepter_id]
    if @user
      current_user.send_request_friend @user
      reponse_action
    else
      display_error
    end
  end

  def edit; end

  def update
    if @friend.accept_request
      flash[:success] = t "friends.show.success"
      redirect_to request.referer || root_url
    else
      flash[:danger] = t "friends.show.add_arror"
      redirect_to root_url
    end
  end

  private

  def destroy_friend sender_id, accepter_id
    friend = Friend.find_by sender_id: [sender_id, accepter_id], accepter_id: [sender_id, accepter_id]
    if friend && friend.destroy
      flash[:success] = t "friends.destroy.success"
    else
      flash[:danger] = t "friends.destroy.fail"
    end
  end

  def reponse_action
    respond_to do |format|
      format.html{redirect_to request.referer}
      format.js
    end
  end

  def display_error
    flash[:danger] = t "users.flash.errorshow"
    redirect_to root_url
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user
    display_error
  end

  def find_friend
    @friend = Friend.find_by sender_id: params[:sender_id], accepter_id: params[:accepter_id]
    return if @friend
    flash[:danger] = t "friends.flash.error"
    redirect_to root_url
  end
end

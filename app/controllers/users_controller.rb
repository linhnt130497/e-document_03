class UsersController < ApplicationController
  before_action :find_user, except: %i(new create index)
  before_action :authenticate_user!, except: %i(create new)
  authorize_resource

  def edit; end

  def new
    @user = User.new
  end

  def show
    @documents = @user.documents.order_by_created_at.paginate page: params[:page]
    @coin_values = CoinValue.all
  end

  def create
    @user = User.new user_params
    @user.coin = Settings.user.default_coin
    @user.down_count = @user.up_count = Settings.user.default_count
    if @user.is_admin? && current_user.is_admin?
      save_admin
    else
      @user.is_admin = false
      save_user
    end
  end

  def update
    if current_user.is_admin? && (!current_user? @user)
      update_admin @user
    else
      update_user @user
    end
  end

  def index
    if params[:name]
      @users = User.search_users(params[:name]).status_admin(false).
        order_by_created_at.paginate page: params[:page]
      respond_to do |format|
        format.html{render partial: "users"}
        format.js
      end
    else
      @users = User.status_admin(false).order_by_created_at.paginate page: params[:page]
    end
  end

  private

  def save_admin
    if @user.save
      flash[:success] = t "users.new.create_success"
      redirect_to root_url
    else
      render :new
    end
  end

  def save_user
    if @user.save
      flash[:success] = t "users.new.create_success"
      log_in @user
      redirect_to @user
    else
      render :new
    end
  end

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation, :avatar, :is_admin
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "users.show.error_message"
    redirect_to root_path
  end

  def update_admin user
    if user.update_attribute :is_admin, true
      flash[:success] = t "users.update.admin_success"
    else
      flash[:danger] = t "users.update.admin_fail"
    end
    redirect_to request.referer || root_url
  end

  def update_user user
    if user.update_attributes user_params
      flash[:success] = t "users.update.success"
      redirect_to @user
    else
      render :edit
    end
  end
end

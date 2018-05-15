class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update)
  before_action :correct_user, only: %i(edit update)
  before_action :load_user, only: %i(edit update show)

  def index
    @users = User.paginate page: params[:page], per_page: Settings.user.per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "alert.signup_success"
      log_in @user
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = t "alert.profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def show
    return if @user
    flash[:danger] = t "alert.user_not_exist"
    redirect_to root_url
  end

  private
  def load_user
    @user = User.find_by id: params[:id]
  end

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  # confirms a logged-in user
  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "alert.please_log_in"
    redirect_to login_url
  end

  # confirms the correct user
  def correct_user
    set_user
    return if current_user? @user
    flash[:danger] = t "alert.permit_deny"
    redirect_to root_url
  end
end

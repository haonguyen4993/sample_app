class UsersController < ApplicationController
  before_action :load_user, except: %i(index new create)
  before_action :logged_in_user, only: %i(index edit update)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)

  def index
    @users = User.except_ids(current_user.id).activated
      .paginate page: params[:page], per_page: Settings.user.per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "alert.active_email_msg"
      redirect_to root_url
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
  end

  def destroy
    if @user.destroy
      flash[:success] = t "alert.user_deleted"
    else
      flash[:danger] = t "alert.cant_delete", name: @user.name
    end
    redirect_to users_url
  end

  private
  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "alert.user_not_exist"
    redirect_to root_url
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
    return if current_user? @user
    flash[:danger] = t "alert.permit_deny"
    redirect_to root_url
  end

  # confirms an admin user
  def admin_user
    return if current_user.is_admin?
    flash[:danger] = t "alert.permit_deny"
    redirect_to root_url
  end
end

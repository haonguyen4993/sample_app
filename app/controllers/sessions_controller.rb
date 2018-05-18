class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      check_activated
    else
      flash[:danger] = t "alert.invalid_login"
      render :new
    end
  end

  def destroy
    log_out
    flash[:success] = t "alert.log_out"
    redirect_to root_url
  end

  private
  def check_activated user
    if user.activated?
      log_in user
      redirect_back_or user
    else
      flash[:warning] = t "alert.please_activate"
      redirect_to root_url
    end
  end
end

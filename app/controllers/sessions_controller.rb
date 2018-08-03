class SessionsController < ApplicationController
  def new; end

  def create
    return flash_danger unless params[:session].present?
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      login user
    else
      flash_danger
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  def login user
    log_in user
    remember_me user
    redirect_back_or user
  end

  private

  def flash_danger
    flash.now[:danger] = t ".login_error"
    render :new
  end

  def remember_me user
    if params[:session][:remember_me] == Settings.sessions.is_remember
      remember user
    else
      forget user
    end
  end
end

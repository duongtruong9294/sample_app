class SessionsController < ApplicationController
  def new; end

  def create
    return flash_danger unless params[:session].present?
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      log_in user
      redirect_to user
    else
      flash_danger
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end

  private

  def flash_danger
    flash.now[:danger] = t ".login_error"
    render :new
  end
end

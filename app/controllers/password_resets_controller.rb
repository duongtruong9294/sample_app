class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration,
    only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".info"
      redirect_to root_path
    else
      flash.now[:danger] = t ".not_found_email"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t(".check_empty"))
      render :edit
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = t ".password_reset"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def get_user
    @user = User.find_by email: params[:email]
    return page_not_found? unless @user
  end

  def valid_user
    redirect_to root_path unless @user&.activated && @user&.
      authenticated?(:reset, params[:id])
  end

  def check_expiration
    return true unless @user.password_reset_expired?
    flash[:danger] = t ".password_reset_eror"
    redirect_to new_password_reset_path
  end
end

class UsersController < ApplicationController
  before_action :logged_in_user, except: [:show, :new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :load_user, except: [:index, :new, :create]

  def show
    @microposts = @user.microposts.paginate page: params[:page],
      per_page: Settings.micropost.per_page
  end

  def index
    @users = User.paginate page: params[:page],
      per_page: Settings.micropost.per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".info"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".update_success"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".deleted_success"
    else
      flash[:danger] = t ".deleted_danger"
    end
    redirect_to users_path
  end

  def following
    @title = t ".title"
    @users = @user.following.paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @title = t ".title"
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def correct_user
    redirect_to(root_path) unless current_user? @user
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def load_user
    @user = User.find params[:id]
  end
end

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :following, :followers]
  before_action :validate_user, only: [:edit, :update]
  
  def show
    @microposts = @user.microposts.order(created_at: :desc).page(params[:page]).per(7)
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end
  
  def update
    if @user.update(user_params)
      flash[:success] = "success"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def following
    @users = @user.following_users
  end
  
  def followers 
    @users = @user.follower_users
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :area, :profile, :password,
                                 :password_confirmation)
  end
  
  def validate_user
    if current_user != @user
      redirect_to @user
    end
  end
  
  def set_user
    @user = User.find(params[:id])
  end
end
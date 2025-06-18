class UsersController < ApplicationController
  before_action :require_login, only: [ :edit, :update, :destroy ]
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_user, only: [ :edit, :update, :destroy ]

  def index
      @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Account created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(filtered_user_params)
      redirect_to @user, notice: "Account updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    reset_session if @user == current_user
    redirect_to root_path, notice: "Account deleted"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_user
    unless @user == current_user
      redirect_to root_path, alert: "You can only modify your own account"
    end
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def filtered_user_params
    p = user_params
    if p[:password].blank? && p[:password_confirmation].blank?
      p.except(:password, :password_confirmation)
    else
      p
    end
  end
end

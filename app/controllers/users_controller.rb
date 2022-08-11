class UsersController < ApplicationController
  skip_before_action :login_required, only: %i[new create]
  before_action :authenticate_user, only: %i[show]
  before_action :forbid_login_user, only: %i[new]
    
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user.id)
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def authenticate_user
    @user = User.find(params[:id])
    unless @user == current_user
      flash[:danger] = "アクセスする権限がありません"
      redirect_to tasks_path
    end
  end

  def forbid_login_user
    if current_user
      flash[:notice] = "ログインしています"
      redirect_to user_path(current_user)
    end
  end
end

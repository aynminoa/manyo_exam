class Admin::UsersController < ApplicationController
  before_action :require_admin

  def index
    @users = User.all.includes(:tasks)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # session[:user_id] = @user.id
      redirect_to admin_user_path(@user.id)
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "ユーザー情報を更新しました"
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to admin_users_path, notice: "ユーザーを削除しました"
    else
      redirect_to admin_users_path, notice: "管理者は少なくとも1人必要です"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

  def require_admin
    redirect_to tasks_path, notice: "管理者以外はアクセスできません" unless current_user.admin?
  end

end

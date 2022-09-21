class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create, :index]

  def index
    users = User.all
    render json: users
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: { name: @user.name, email: @user.email }.to_json, status: :created
    else
      render json: { message: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end

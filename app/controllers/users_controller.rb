class UsersController < ApplicationController
  before_action :authorized, only: [:auto_login]

  # REGISTER

  def create
    @user = User.create(user_params)
    if @user.valid?
      @token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: @token }, status: :created
    else
      render json: { error: 'failed to create user' }, status: :not_acceptable
    end
  end

  # LOGGING IN

  def login
    @user = User.find_by(username: params[:username])

    if @user && @user.authenticate(params[:password])
      @token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: @token }, status: :accepted
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end

  # LOGGING OUT

  def logout
    reset_session
    render json: { message: 'Successfully logged out' }, status: :ok
  end

  # GETTING LOGGED IN USER

  def auto_login
    render json: @user
  end

  private

  def user_params
    params.permit(:username, :password, :password_confirmation)
  end
end

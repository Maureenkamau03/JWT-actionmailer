class UsersController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_credentials
  skip_before_action :authorize, only:[:login] 

  def create
    user = User.create!(user_params)
    render json: user, status: :created
  end
  def login
    user = User.find_by(username:params[:username])
    if user &.authenticate (params[:password])
      token =  encode_token(user_id:user.id)
      render json: {user:user, token:token}
    else
      render json: {error: "invalid username or password"}
    end
  end

  def user_params
    params.permit(:username,:password,:password_confirmation)
  end
  def authorize
    render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
  end
  def invalid_credentials invalid
    render json:{errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
  end

end

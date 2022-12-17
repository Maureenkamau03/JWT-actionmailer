class ApplicationController < ActionController::API
  before_action :authorize
  def encode_token(payload)
    JWT.encode(payload,"my_secret")
  end
  
  def decode_token
    header = request.headers["authorization"]
    if header
      token = header.split(' ')[1]
      begin
        decoded_token = JWT.decode(token, "my_secret", true, algorithm:('HS256'))
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def valid_user
    decoded_token = decode_token
    if decoded_token
      user_id= decoded_token[0]['user_id']
      user=User.find_by(id: user_id)
    end
  end
  def logged_in?
    !! valid_user 
  end

  def authorize
    render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
  end
end

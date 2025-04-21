class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix
  
  respond_to :json
  skip_before_action :verify_signed_out_user, only: :destroy
  before_action :authenticate_user!, only: :destroy

  private

  def respond_with(current_user, _opts = {})
    Rails.logger.info("Current user: #{current_user.inspect}")

    if current_user && valid_credentials?
      Rails.logger.info("Current user is valid")
      render json: {
        status: { 
          code: 200, message: 'Logged in successfully.',
          data: { 
            user: UserSerializer.new(current_user).serializable_hash[:data][:attributes],
            token: generate_token(current_user)
          }
        }
      }, status: :ok
    else
      Rails.logger.info("Current user is invalid")
      render json: {
        status: 401,
        message: 'Invalid email or password.'
      }, status: :unauthorized
    end
  end

  def respond_to_on_destroy
    if request.headers['Authorization'].present?
      secret_key = Rails.application.credentials.devise_jwt_secret_key || ENV['DEVISE_JWT_SECRET_KEY']
      token = request.headers['Authorization'].split(' ').last
      begin
        jwt_payload = JWT.decode(token, secret_key, true, algorithm: 'HS256').first
        current_user = User.find(jwt_payload['sub'])
      rescue JWT::DecodeError => e
        Rails.logger.error("JWT decode error: #{e.message}")
      end
    end
    
    if current_user
      render json: {
        status: 200,
        message: 'Logged out successfully.'
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end

  def generate_token(user)
    secret_key = Rails.application.credentials.devise_jwt_secret_key || ENV['DEVISE_JWT_SECRET_KEY']
    usr_sub = { 
      sub: user.id,
      exp: 30.minutes.from_now.to_i,
      jti: SecureRandom.uuid,
      #scope: ['user', 'api']
      scp: ['user', 'api'],  # OAuth 2.0 style
      roles: ['user'],       # Custom format
      aud: 'api'             # Audience claim
    }
    JWT.encode(usr_sub, secret_key, 'HS256')
  end

  def valid_credentials?
    user = User.find_by(email: params[:user][:email])
    user&.valid_password?(params[:user][:password])
  end

end

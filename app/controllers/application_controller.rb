class ApplicationController < ActionController::API
  #before_action :authenticate_user!
  before_action :log_auth_token
  before_action :configure_permitted_parameters, if: :devise_controller?

  skip_before_action :log_auth_token, only: [:create, :new], if: -> { 
    (controller_path == 'users/sessions' && action_name == 'create') ||
    (controller_path == 'users/registrations' && action_name == 'create')
  }

  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in) do |user_params|
      user_params.permit(:email, :password)
    end
  end

  private

  def log_auth_token 
    return if (controller_name == 'sessions' && action_name == 'create') ||
      (controller_name == 'registrations' && action_name == 'create')

    if token = get_token_from_header
      Rails.logger.info("Auth token: #{token}")
      begin
        token = request.headers['Authorization'].split(' ').last 
        secret_key = Rails.application.credentials.devise_jwt_secret_key || ENV['DEVISE_JWT_SECRET_KEY']
        jwt_payload = JWT.decode(token, secret_key, true, algorithm: 'HS256').first
        Rails.logger.info("Decoded JWT payload: #{jwt_payload}")
        @jwt_payload_sub = jwt_payload['sub']
      rescue JWT::ExpiredSignature, JWT::DecodeError, ActiveRecord::RecordNotFound => e
        render json: { error: e.message }, status: :unauthorized
        return
      end
    else
      render json: { error: 'No Authentication token' }, status: :unauthorized
      return
    end
  end

  def get_token_from_header
    request.headers['Authorization'].split(' ').last if request.headers['Authorization'].present?
  end

  def current_user # override?
    @current_user ||= User.find(@jwt_payload_sub)
  end
end
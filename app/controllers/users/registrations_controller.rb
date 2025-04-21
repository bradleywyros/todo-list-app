class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix
  
  respond_to :json

  before_action :configure_permitted_parameters, only: %i[ create ]

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password])
  end

  private

  def respond_with(current_user, _opts = {})
    Rails.logger.info("Current user: #{current_user.inspect}")
    if current_user.persisted?
      render json: {
        status: {code: 200, message: 'Signed up successfully.'},
        data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
      }
    else
      render json: {
        status: {message: "User couldn't be created successfully. #{current_user.errors.full_messages.to_sentence}"}
      }, status: :unprocessable_entity
    end
  end
  
end

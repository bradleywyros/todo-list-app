module Admin
  class BaseController < ApplicationController
    before_action :authorize_admin

    private

    def authorize_admin
      unless current_user&.admin?
        render json: { error: "Admin Access Only" }, status: :forbidden
      end
    end
  end
end
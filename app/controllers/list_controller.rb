class ListController < ApplicationController
  include ListConcern
  
  before_action :parse_params, only: %i[ index ]
  before_action :set_list, only: %i[ index ]

  # GET /lists
  def index
    render json: @list
  end

  # POST /lists
  # Should list be automatically created when a user is registered?
  def create
    @list = List.new(name: params[:name], user_id: current_user.id)

    if @list.save
      render json: @list, status: :created, location: @list, message: 'List created successfully'
    else
      render json: @list.errors, status: :unprocessable_entity, message: 'Failed to create list'
    end
  end

  private

  def set_list
    begin
      if current_user
        list = List.find_by!(user_id: current_user.id)
        @list = parse_list(list)
      else
        render json: { error: 'You must sign in to see your ToDo List' }, status: :forbidden
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'List not found' }, status: :not_found
    rescue StandardError => err
      render json: { error: err.message }, status: :unprocessable_entity
    end
  end
end

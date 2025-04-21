module Admin
  class ListController < BaseController
    include ListConcern

    before_action :parse_params, only: %i[ index show ]
    before_action :set_lists, only: %i[ index ]
    before_action :set_list, only: %i[ show ]

    # GET /lists
    def index
      render json: @lists
    end

    # GET /lists/1
    def show
      render json: @list
    end

    # POST /lists
    # Should list be automatically created when a user is registered?
    def create
      @list = List.new(name: params[:name], user_id: params[:user_id])

      if @list.save
        render json: { message: 'List created successfully', list: @list }, status: :created
      else
        render json: { message: 'Failed to create list', errors: @list.errors }, status: :unprocessable_entity
      end
    end

    # DELETE /lists/1
    def destroy
      begin
        list = List.find_by_id!(params[:id])
        if list.destroy
          render json: { message: 'List deleted successfully' }, status: :ok
        else
          render json: { error: 'Failed to delete list' }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'List not found' }, status: :not_found
      end
    end

    private

    def set_lists
      begin
        @lists = List.all.map { |list| parse_list(list) }
      rescue StandardError => err
        render json: { error: err.message }, status: :unprocessable_entity
      end
    end

    def set_list
      begin
        list = List.find_by_id!(params[:id])
        @list = parse_list(list)
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'List not found' }, status: :not_found
      rescue JWT::VerificationError => e
        render json: { error: e.message }, status: :not_found
      rescue StandardError => err
        render json: { error: err.message }, status: :unprocessable_entity
      end
    end

  end
end

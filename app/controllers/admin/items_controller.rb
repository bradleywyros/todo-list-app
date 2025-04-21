module Admin
  class ItemsController < BaseController

    before_action :parse_params, only: %i[ create ]
    before_action :set_list 
    before_action :set_item, only: %i[ show start complete destroy ]
    
    def create
      # add item to list
      begin
        @item = @list.items.new(item_params)
    
        if @item.save
          render json: { message: %{Item "#{@item.title}" created successfully}, item: @item }, status: :created
        else
          render json: { message: 'Failed to create item', errors: @item.errors }, status: :unprocessable_entity 
        end
      rescue StandardError => err
        render json: { error: err.class.name, message: err.message }, status: :unprocessable_entity 
      end
    end

    def show
      render json: @item
    end
  
    def start
      # mark status of item as in progress
      if @item.update(status: 'in_progress')
        render json: { message: %{List item "#{@item.title}" marked as in progress}, item: @item }, status: :ok
      else
        render json: { message: %{Failed to mark list item "#{@item.title}" as completed}, errors: @item.errors }, status: :unprocessable_entity
      end
    end
  
    def complete
      # mark status of item as completed
      if @item.update(status: 'completed')
        render json: { message: %{List item "#{@item.title}" marked as completed}, item: @item }, status: :ok
      else
        render json: { message: %{Failed to mark list item "#{@item.title}" as completed}, errors: @item.errors }, status: :unprocessable_entity
      end
    end
  
    def destroy
      if @item.destroy
        render json: { message: 'Item deleted successfully' }, status: :ok
      else
        render json: { error: 'Failed to delete item' }, status: :unprocessable_entity
      end
    end
  
    private
  
    def set_list
      begin
        if current_user.admin?
          @list = List.find_by_id!(params[:list_id])
        else
          render json: { error: 'Admin Access Only' }, status: :forbidden
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'List not found' }, status: :not_found
      end
    end
  
    def set_item
      begin
        @item = @list.items.find_by_id!(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Item not found' }, status: :not_found
      end
    end
  
    def parse_params
      params[:duedate] = validate_date(params[:duedate]) if params[:duedate].present?
    end
  
    def item_params
      params.permit(:title, :duedate, :description)
    end
  
    def validate_date(date)
      Date.strptime(date, "%Y-%m-%d")
    end
  end  
end
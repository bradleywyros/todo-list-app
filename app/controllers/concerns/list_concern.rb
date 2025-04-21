module ListConcern
  extend ActiveSupport::Concern

  class UnexpectedParameters < StandardError; end

  included do
    def parse_list(list)
      {
        id: list.id,
        name: list.name,
        items: filter_list_items(list.items).map do |item|
          {
            id: item.id,
            title: item.title,
            description: item.description,
            status: item.status,
            duedate: item.duedate
          }
        end
      }
    end

    private

    def parse_items(items)
      return [] unless items.any?
      filter_list_items(items).map do |item|
        {
          id: item.id,
          title: item.title,
          description: item.description,
          status: item.status,
          duedate: item.duedate
        }
      end
    end

    ITEM_STATUS = ['pending', 'completed', 'in_progress']
  
    def filter_list_items(items)
      if params[:status]
        raise "Item status must be 'pending', 'completed', or 'in_progress'" unless ITEM_STATUS.include?(params[:status])
        items = items.by_status(params[:status])
      end
  
      if params[:start_date].present? && params[:end_date].present?
        items = items.by_duedate_range(params[:start_date], params[:end_date])
      elsif params[:due_date] # this will override start_date or end_date if used together
        items = items.by_duedate(params[:due_date] )
      elsif params[:start_date].present?
        items = items.from_start_date(params[:start_date])
      elsif params[:end_date].present?
        items = items.by_end_date(params[:end_date])
      end
  
      items.order(duedate: :asc)
    end

    def parse_params
      Rails.logger.info("Params: #{list_params}")
      begin
        if list_params[:due_date].present? && (list_params[:start_date].present? || list_params[:end_date].present?)
          raise UnexpectedParameters, 'Due Date should not be used with Start Date or End Date'
        end
  
        list_params[:due_date] = validate_date(list_params[:due_date]) if list_params[:due_date].present?
        list_params[:start_date] = validate_date(list_params[:start_date]) if list_params[:start_date].present?
        list_params[:end_date] = validate_date(list_params[:end_date]) if list_params[:end_date].present?
  
        if list_params[:start_date].present? && list_params[:end_date].present?
          if list_params[:start_date] >= list_params[:end_date]
            raise UnexpectedParameters, 'Start date cannot be greater than end date'
          end
        end
      rescue StandardError => err
        render json: { error: err.class.name, message: err.message }, status: :unprocessable_entity # Better message handling?
      end
    end
  
    def list_params
      @list_params ||= params.permit(:status, :due_date, :start_date, :end_date)
    end
  
    def validate_date(date)
      Date.strptime(date, "%Y-%m-%d")
    end
  end
end
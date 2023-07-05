module Pagination
  protected

  def paginate(class_name, where: {}, scope: nil)
    model = class_name.to_s.constantize

    page = params[:page]&.to_i || 1
    limit = params[:limit]&.to_i || 50
    sort_by = params[:sort_by]&.underscore || 'updated_at'
    order_by = params[:order_by]&.upcase || (params[:sort_by] ? 'ASC' : 'DESC')

    data = model.where(where)

    data = data.instance_exec(&scope) unless scope.nil?

    total = data.count

    paginated = data
                .order({ sort_by => order_by })
                .offset((page - 1) * limit)
                .limit(limit)

    render json: {
      content: ActiveModelSerializers::SerializableResource.new(paginated),
      pagination: {
        current_page: page,
        total_pages: (total / limit.to_f).ceil,
        total_elements: total
      }
    }
  end
end

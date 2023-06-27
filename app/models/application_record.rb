class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  scope :pagination, lambda { |filters: {}, page: 1, limit: 50, sort_by: 'updated_at', order_by: 'DESC'|
    query = order("#{sort_by} #{order_by}").offset((page - 1) * limit).limit(limit)

    filters.each do |key, value|
      query = query.where("LOWER(#{key}) LIKE ?", "%#{value.downcase}%")
    end

    return query
  }
end

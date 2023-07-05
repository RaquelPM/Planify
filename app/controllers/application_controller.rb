class ApplicationController < ActionController::API
  include Authentication
  include Pagination

  before_action :authenticate
end

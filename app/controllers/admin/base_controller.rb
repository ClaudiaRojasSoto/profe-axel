module Admin
  class BaseController < ApplicationController
    include AdminAuthentication

    layout "admin"
    before_action :require_admin
  end
end

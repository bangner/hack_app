class Admin::FrontController < BaseController
  before_filter :super_admin_access_only
  layout "base"
end

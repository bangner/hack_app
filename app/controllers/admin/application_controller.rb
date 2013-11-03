class Admin::ApplicationController < HackappController
  before_filter :super_admin_access_only
  layout "application"
end

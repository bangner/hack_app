class Admin::ApplicationController < HackappController
  before_filter :super_admin_access_only

  def index
  end

end

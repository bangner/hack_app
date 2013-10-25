class Admin::SchoolsController < Admin::ApplicationController

  def index
    @schools = School.all
  end

  def new
    @school = School.new
  end

  def create
    School.create(school_permitted)
    redirect_to admin_schools_path
  end

  private
    def school_permitted
      params.require(:school).permit(
        :name
      )
    end

end

class Admin::SchoolsController < Admin::ApplicationController

  def index
    @schools = School.all
  end

  def new
    @school = School.new
  end

  def create
    @school = School.new(school_permitted)
    @school.logo = upload_logo

    # Update school applications
    @primary_application = SchoolApplication.new
    @primary_application.question_ids = Question.where(:application_set => "primary").pluck(:id)
    @school.primary_application = @primary_application

    @secondary_application = SchoolApplication.new
    @school.secondary_application = @secondary_application

    @school.save

    redirect_to admin_schools_path
  end

  def edit
    @school = School.find_by_id(params[:id])
  end

  def update
    params[:school][:logo] = upload_logo if params[:school][:logo]
    School.find_by_id(params[:id]).update_attributes(school_permitted)

    redirect_to admin_schools_path
  end

  def destroy
    School.destroy(params[:id])
    respond_to do |format|
      response = { :error => false }
      format.json { render :json => response }
    end
  end

  private
    def upload_logo
      logo_io = params[:school][:logo]
      ext = File.extname(logo_io.original_filename)

      school_slug = params[:school][:name].parameterize

      # Create directory if it does not exist
      school_directory = Rails.root.join('public', 'uploads', 'schools', school_slug).to_s
      Dir.mkdir(school_directory) unless File.exists?(school_directory)

      File.open(school_directory + '/logo' + ext, "wb") do |file|
        file.write(logo_io.read)
      end

      return home_path + 'uploads/schools/' + school_slug + '/logo' + ext
    end

    def school_permitted
      params.require(:school).permit(
        :name,
        :description,
        :website,
        :email,
        :twitter,
        :facebook,
        :video,
        :video_source,
        :logo
      )
    end

end

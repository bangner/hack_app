class Admin::BootcampsController < Admin::FrontController
  
  include Media

  def index
    @bootcamps = Bootcamp.all
  end

  def new
    @bootcamp = Bootcamp.new
  end

  def create
    @bootcamp = Bootcamp.new(bootcamp_permitted)
    @bootcamp.logo = upload_logo

    # Update bootcamp applications
    @bootcamp.primary_application = BootcampApplication.new
    @bootcamp.primary_application.question_ids = Question.primary.pluck(:id)
    @bootcamp.secondary_application = BootcampApplication.new

    @bootcamp.save

    redirect_to admin_bootcamps_path
  end

  def edit
    @bootcamp = Bootcamp.find_by_id(params[:id])
  end

  def update
    params[:bootcamp][:logo] = upload_logo if params[:bootcamp][:logo]
    Bootcamp.find_by_id(params[:id]).update_attributes(bootcamp_permitted)

    redirect_to admin_bootcamps_path
  end

  def destroy
    Bootcamp.destroy(params[:id])
    respond_to do |format|
      response = { :error => false }
      format.json { render :json => response }
    end
  end

  private
    def bootcamp_permitted
      params.require(:bootcamp).permit(
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

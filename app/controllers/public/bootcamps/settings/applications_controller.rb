class Public::Bootcamps::Settings::ApplicationsController < Public::BootcampsController
  
  before_filter :current_bootcamp_admin_or_super_admin_only, only: [:edit, :update]

  def edit
    @bootcamp = Bootcamp.find_by_id(params[:bootcamp_id])
    @applications = @bootcamp.get_applications_by_set
    @questions = Question.get_by_application_set
  end

  def update
    @bootcamp = Bootcamp.find_by_id(params[:bootcamp_id])

    if params.key?(:questions)
      @bootcamp.primary_application.question_ids = params[:questions][:primary] ? params[:questions][:primary].keys : []
      @bootcamp.secondary_application.question_ids = params[:questions][:secondary] ? params[:questions][:secondary].keys : []
    else
      @bootcamp.primary_application.question_ids = []
      @bootcamp.secondary_application.question_ids = []
    end

    @bootcamp.primary_application.save
    @bootcamp.secondary_application.save

    flash[:notice] = "Bootcamp application settings have been saved successfully."
    redirect_to edit_bootcamp_settings_applications_path(@bootcamp)
  end
  
end

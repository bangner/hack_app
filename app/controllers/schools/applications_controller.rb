class Schools::ApplicationsController < ApplicationController

  def edit
    @school = School.find_by_id(params[:school_id])

    # Grab application question selection
    @applications = {}
    @applications["primary"] = @school.primary_application
    @applications["secondary"] = @school.secondary_application

    # Grab questions
    @questions = Question.all.group_by { |question| question[:application_set] }
  end

  def update
    @school = School.find_by_id(params[:school_id])

    # Update school applications
    @primary_application = @school.primary_application
    unless @primary_application
      @primary_application = SchoolApplication.new
      @school.primary_application = @primary_application
    end

    @secondary_application = @school.secondary_application
    unless @secondary_application
      @secondary_application = SchoolApplication.new
      @school.secondary_application = @secondary_application
    end
    
    if params[:questions]
      @primary_application.question_ids = params[:questions][:primary] ? params[:questions][:primary].keys : []
      @secondary_application.question_ids = params[:questions][:secondary] ? params[:questions][:secondary].keys : []
    else
      @primary_application.question_ids = []
      @secondary_application.question_ids = []
    end

    @primary_application.save
    @secondary_application.save

    if @school.save
      flash[:notice] = "Application settings have been saved successfully."
      return redirect_to edit_school_applications_path(@school)
    end

    # Grab application question selection
    @applications = {}
    @applications["primary"] = @school.primary_application
    @applications["secondary"] = @school.secondary_application

    @questions = Question.all.group_by { |question| question[:application_set] }

    render "schools/edit"
  end
  
end

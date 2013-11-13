class Public::Applicants::ApplicationController < Public::ApplicantsController

  skip_before_filter :non_applicant_access_only
  before_filter { |c| c.current_account_for_id_only params[:applicant_id] }

  def show
    @application = Application.find_active_by_applicant(params[:applicant_id])
    respond_to do |format|
      format.html { not_found }
      format.json { render :json => @application, :include => :bootcamp_selections }
    end
  end

  def update
    @application = Application.find_active_by_applicant(params[:applicant_id])
    @application.update_selections(params[:bootcamp_selections])
    respond_to do |format|
      format.html { not_found }
      format.json { render :json => { :error => false } }
    end
  end

  def new

    # Pull the application profile for the applicant
    # Make sure all of the required answers are answered
    @applicant_profile = ApplicantProfile.pull_for_applicant(params[:applicant_id])
    unless @applicant_profile.required_answered?
      flash[:notice] = "We need you to answer all required questions."
      return redirect_to edit_applicant_settings_profile_path(@applicant_profile.account_id)
    end

    # Pull the active application for the profile (a guarantee to have)
    # Make sure there are bootcamps selected
    @application = Application.find_active_by_profile(@applicant_profile)
    unless @application.bootcamp_selections.any?
      flash[:notice] = "Looks like you don't have any bootcamps selected. There are plenty to choose from."
      return redirect_to bootcamps_path
    end

    @selections = @application.prioritized_selections

  end

  def create

    # Pull the application profile for the applicant
    # Make sure all of the required answers are answered
    @applicant_profile = ApplicantProfile.pull_for_applicant(params[:applicant_id])
    unless @applicant_profile.required_answered?
      flash[:notice] = "We need you to answer all required questions."
      return redirect_to edit_applicant_settings_profile_path(@applicant_profile.account_id)
    end

    # Pull the active application for the profile (a guarantee to have)
    # Submit it (we don't care if there are no bootcamp selections,
    # as nothing will happen in that case)
    @application = Application.find_active_by_profile(@applicant_profile)
    unless @application.send_selections
      flash[:notice] = "We encountered an error submitting your application."
      return redirect_to new_applicant_application_path(@applicant_profile.account_id)
    end

    redirect_to applicant_applied_path(@applicant_profile.account_id)

  end

  def applied
    @application = Application.find_last_active_by_applicant(params[:applicant_id])
    return not_found unless @application

    @selections = @application.prioritized_selections
  end

end

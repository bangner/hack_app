class Public::Applicants::Settings::ProfileController < Public::ApplicantsController
  
  skip_before_filter :non_applicant_access_only
  before_filter :only => [:edit, :update] { |c| c.current_account_for_id_only params[:applicant_id] }

  def edit
    @applicant = Account.find_by_id(params[:applicant_id])
    @applicant_profile = ApplicantProfile.pull_for_applicant(@applicant)
    @questions = Question.primary_by_field_set
  end

  def update
    @applicant = Account.find_by_id(params[:applicant_id])
    @applicant_profile = ApplicantProfile.pull_for_applicant(@applicant)

    if @applicant_profile.update_answers(params[:question])
      flash[:notice] = "Profile updated successfully."
      return redirect_to edit_applicant_settings_profile_path(@applicant)
    end

    @error = "Error occurred updating profile."
    @questions = Question.primary_by_field_set
    render "public/applicants/settings/profile/edit"
  end
  
end

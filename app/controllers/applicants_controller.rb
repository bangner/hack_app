class ApplicantsController < ApplicationController

  def new
    @applicant = Account.new
  end

  def create

    @applicant = Account.find_by_email(params[:account][:email])

    if @applicant
      # Add role to account if doesn't have it
      if @applicant.roles.pluck(:name).include? Role::APPLICANT
        @applicant_profile = ApplicantProfile.find_by_account_id(@applicant.id)
        unless @applicant_profile
          @applicant_profile = ApplicantProfile.new 
          @applicant_profile.account = @applicant
          @applicant_profile.save
        end
      
        @error = "We found an account with that email. Perhaps you want to <a href='" + login_path + "'>log in</a>?"
        return render "applicants/new"
      else
        @applicant.roles << Role.find_by_name(Role::APPLICANT)
        @applicant.save

        @applicant_profile = ApplicantProfile.find_by_account_id(@applicant.id)
        unless @applicant_profile
          @applicant_profile = ApplicantProfile.new 
          @applicant_profile.account = @applicant
          @applicant_profile.save
        end

        @applicant_profile = ApplicantProfile.find_by_account_id(params[:id])
        @applicant_profile = ApplicantProfile.new unless @applicant_profile

        cookies[:h_a] = @applicant.auth_token
        return redirect_to edit_applicant_path(@applicant)
      end
    end

    # Create applicant
    @applicant = Account.new(applicant_permitted)
    @applicant.roles << Role.find_by_name(Role::APPLICANT)

    if @applicant.save
      @applicant_profile = ApplicantProfile.new 
      @applicant_profile.account = @applicant
      @applicant_profile.save

      cookies[:h_a] = @applicant.auth_token
      return redirect_to edit_applicant_path(@applicant)
    end

    render "applicants/new"
  end

  def edit
    @applicant = Account.find_by_id(params[:id])
    @applicant_profile = ApplicantProfile.find_by_account_id(params[:id])
    unless @applicant_profile
      @applicant_profile = ApplicantProfile.new
    end

    @questions = Question.where(:application_set => "primary")
    @questions = @questions.group_by { |question| question[:field_set] }

    render "applicants/edit"
  end

  def update

    @applicant = Account.find_by_id(params[:id])
    @applicant_profile = ApplicantProfile.find_by_account_id(params[:id])

    if @applicant_profile
      # Modify applicant profile if it exists
      params[:question].each do |question_id, answer|
        ap_answer = @applicant_profile.answers.find_by_question_id(question_id)
        if ap_answer
          ap_answer.update_attributes(:answer => answer)
        else
          new_answer = ApplicantProfileAnswer.new
          new_answer.question_id = question_id
          new_answer.answer = answer
          @applicant_profile.answers << new_answer
        end
      end
    else
      # Create applicant profile if doesn't exist
      @applicant_profile = ApplicantProfile.new
      @applicant_profile.account = @applicant
      @applicant_profile.answers = []

      params[:question].each do |question_id, answer|
        new_answer = ApplicantProfileAnswer.new
        new_answer.question_id = question_id
        new_answer.answer = answer

        @applicant_profile.answers << new_answer
      end
    end

    if @applicant_profile.save
      @questions = Question.where(:application_set => "primary")
      @questions = @questions.group_by { |question| question[:field_set] }

      flash[:notice] = "Profile changes have been made successfully."
      return redirect_to edit_applicant_path(@applicant)
    end

  end

  private
    def applicant_permitted
      params.require(:account).permit(
        :name,
        :email,
        :password_hash
      )
    end

end

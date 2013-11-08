class ApplicationController < HackappController
  before_filter :guest_access_only, :only => [:login_get, :login_post]
  before_filter :applicant_access_only, :only => [:apply_get, :apply_post]

  def index
    @latest_schools = School.order(created_at: :desc).limit(4)
  end

  def about
    render "application/about"
  end

  def login_get
    render "application/login"
  end

  def login_post
    if @account = Account.find_by_email(params[:email])
      if @account.authenticate params[:password]

        # Regenerate auth token
        @account.generate_auth_token!

        if params[:remember_me]
          cookies.permanent[:h_a] = @account.auth_token
        else
          cookies[:h_a] = @account.auth_token
        end

        return redirect_to home_path
      else
        @error = "Sorry, that password wasn't right."
      end
    else
      @error = "Sorry, we couldn't find an account with that email."
    end
    render "application/login"
  end

  def logout
    cookies.delete(:h_a)
    redirect_to home_path
  end

  def apply_get
    @applicant = current_account

    @applicant_profile = ApplicantProfile.find_by_account_id(@applicant.id)
    unless @applicant_profile
      flash[:notice] = "We need you to build your applicant profile first."
      return redirect_to edit_applicant_path(@applicant)
    end

    # TODO: Look for answers to required questions
    unless @applicant_profile.answers.any?
      flash[:notice] = "We need you to answer some questions."
      return redirect_to edit_applicant_path(@applicant)
    end

    @application = Application.where(submitted_at: nil, applicant_profile_id: @applicant_profile.id).first
    unless @application
      flash[:notice] = "Looks like you don't have any schools selected. There are plenty to choose from."
      return redirect_to schools_path
    end

    @school_selections = @application.school_selections.order(:priority)
    unless @school_selections.any?
      flash[:notice] = "Looks like you don't have any schools selected. There are plenty to choose from."
      return redirect_to schools_path
    end

    render "application/apply"
  end

  def apply_post

    @applicant = current_account
    @applicant_profile = ApplicantProfile.find_by_account_id(@applicant.id)
    @application = Application.where(submitted_at: nil, applicant_profile_id: @applicant_profile.id).first
    @school_selections = @application.school_selections.order(:priority)

    # Email schools and cc school admins
    @answers = @applicant_profile.answers
    @school_selections.each do |school_selection|
      answers = []
      primary_application = school_selection.school.primary_application
      next unless primary_application
      question_ids = primary_application.questions.pluck(:id)
      @answers.each do |answer|
        answers << answer if question_ids.include? answer.question_id
      end
      ApplicationMailer.send_answers_to_school(school_selection.school.admins, @applicant, school_selection, answers).deliver
    end

    @application.submitted_at = DateTime.now
    @application.save

    return redirect_to apply_done_path

  end

  def apply_done
    @applicant = current_account
    @applicant_profile = ApplicantProfile.find_by_account_id(@applicant.id)
    @application = Application.where(:applicant_profile_id => @applicant_profile.id).order(submitted_at: :desc).first
    @school_selections = @application.school_selections.order(:priority)
  end

end

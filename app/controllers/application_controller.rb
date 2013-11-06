class ApplicationController < HackappController
  before_filter :guest_access_only, :only => [:login_get, :login_post]
  before_filter :applicant_access_only, :only => [:apply_get, :apply_post]

  def index
    @latest_schools = School.order(:created_at).limit(4)
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
      return redirect_to edit_applicant_path(@account)
    end

    @application = Application.find_by_applicant_profile_id(@applicant_profile.id)
    unless @application
      flash[:notice] = "Looks like you don't have any schools selected."
      return redirect_to schools_path
    end

    @school_selections = @application.school_selections.order(:priority)
    unless @school_selections.any?
      flash[:notice] = "Looks like you don't have any schools selected."
      return redirect_to schools_path
    end

    render "application/apply"
  end

  def apply_post

    # Email schools and cc school admins



  end

end

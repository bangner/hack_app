class Public::ApplicantsController < Public::FrontController
  before_filter :non_applicant_access_only, :only => [:new, :create]

  def new
    @applicant = Account.new
  end

  def create

    # TODO: Validation

    # Let's see if we can find an account with that email. If we cannot,
    # let's create a new one
    unless @applicant = Account.find_by_email(params[:account][:email])
      @applicant = Account.new(account_permitted)
    end

    # Add the APPLICANT role
    @applicant.roles << Role.find_by_name(Role::APPLICANT)

    if @applicant.save
      app_profile = ApplicantProfile.init_for_applicant(@applicant)
      Application.init_for_applicant_profile(app_profile)

      cookies[:h_a] = @applicant.auth_token
      return redirect_to edit_applicant_settings_profile_path(@applicant)
    end

    render "applicants/new"
    
  end

  private
    def account_permitted
      params.require(:account).permit(
        :name,
        :email,
        :password_hash
      )
    end

end

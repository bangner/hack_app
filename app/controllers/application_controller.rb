class ApplicationController < HackappController
  before_filter :guest_access_only, :only => [:login_get, :login_post]

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
    render "application/apply"
  end

end

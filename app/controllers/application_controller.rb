class ApplicationController < HackappController
  before_filter :guest_access_only, :only => [:login_get, :login_post]

  def login_get
    render "application/login"
  end

  def login_post
    if @account = Account.find_by_email(params[:email])
      if @account.is_password? params[:password]
        session[:account_id] = @account.id
        return redirect_to home_path
      else
        @error = "Improper credentials."
      end
    else
      @error = "Couldn't find user with that email address."
    end
    render "application/login"
  end

  def logout
    reset_session

    redirect_to home_path
  end

end

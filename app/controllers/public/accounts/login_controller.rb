class Public::Accounts::LoginController < Public::AccountsController

  before_filter :guest_access_only

  def create
    if @account = Account.find_by_email(params[:email])
      if @account.authenticate params[:password]

        # Regenerate auth token
        @account.generate_auth_token!

        if params[:remember_me]
          cookies.permanent[:h_a] = @account.auth_token
        else
          cookies[:h_a] = @account.auth_token
        end

        return redirect_to root_path
      else
        @error = "Sorry, that password wasn't right."
      end
    else
      @error = "Sorry, we couldn't find an account with that email."
    end
    render "new"
  end

end

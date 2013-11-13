class Public::AccountsController < Public::FrontController

  before_filter :only => [:logout] { |c| c.current_account_for_id_only params[:account_id] }
  before_filter :current_account_for_id_only, only: [:edit, :update]

  def edit
    @account = Account.find_by_id(params[:id])
  end
  
  def update
    @account = Account.find_by_id(params[:id])
    @account.assign_attributes(account_permitted)
    
    unless params[:new_password].blank?
      if @account.authenticate params[:old_password]
        @account.password_hash = params[:new_password]
        @account.hash_password!
      else
        @error = "Can't set new password because the old one was incorrect."
      end
    end

    unless @error
      if @account.save
        flash[:notice] = "Account changes have been made successfully."
        return redirect_to edit_account_path(@account)
      end
    end

    render "public/accounts/edit"
  end

  def logout
    cookies.delete(:h_a)
    redirect_to root_path
  end

  private
    def account_permitted
      params.require(:account).permit(:name)
    end

end

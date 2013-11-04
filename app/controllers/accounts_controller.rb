class AccountsController < ApplicationController
  def edit
    @account = Account.find_by_id(params[:id])
  end
  def update
    @account = Account.find_by_id(params[:id])
    orig_pass_hash = @account.password_hash
    @account.assign_attributes(account_permitted)
    if params[:account][:password_hash].blank?
      @account.password_hash = orig_pass_hash
    else
      @account.hash_password!
    end
    if @account.save
      flash[:notice] = "Account changes have been made successfully."
      return redirect_to edit_account_path(@account)
    end
    render "accounts/edit"
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

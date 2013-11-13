class Admin::AccountsController < Admin::FrontController

  def index
    @accounts = Account.all
  end

  def edit
    @account = Account.find_by_id(params[:id])
  end

  def update
    Account.find_by_id(params[:id]).update_attributes(account_permitted)
    redirect_to admin_accounts_path
  end

  private
    def account_permitted
      params.require(:account).permit(
        :name,
        :email,
        :role_ids => []
      )
    end

end

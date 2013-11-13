class Public::Bootcamps::AdminsController < Public::BootcampsController
  before_filter :valid_invite_only, :only => [:new, :create]

  def new
    @invitation = BootcampInvitation.includes(:bootcamp).find_by_code params[:code]
    @admin = Account.new
  end

  def create

    # TODO: Validation

    @invitation = BootcampInvitation.includes(:bootcamp).find_by_code(params[:code])
    @admin = Account.find_by_email(@invitation.email)

    if @admin
      # Account with that email already exists
      # Add the BOOTCAMP ADMIN role to account
      @admin.add_role(Role::BOOTCAMP_ADMIN)
    else
      # Account not found, we need to create one
      @admin = Account.new(account_permitted)
      @admin.email = @invitation.email
      @admin.roles << Role.find_by_name(Role::BOOTCAMP_ADMIN)
      @admin.save
    end

    @invitation.bootcamp.add_admin(@admin)
    @invitation.expire!

    cookies[:h_a] = @admin.auth_token
    return redirect_to edit_bootcamp_settings_profile_path(@invitation.bootcamp)
    
  end

  private
    def account_permitted
      params.require(:account).permit(
        :name,
        :password_hash
      )
    end

  protected
    def valid_invite_only
      return not_found unless params.key? :code
      invitation = BootcampInvitation.find_by_code params[:code]
      return not_found if invitation.nil? or invitation.is_expired
    end

end

class Admin::InvitationsController < Admin::FrontController

  def index
    @invitations = BootcampInvitation.all
  end

  def new
    if Bootcamp.all.empty?
      return redirect_to new_admin_bootcamp_path
    end

    @invitation = BootcampInvitation.new
    @code = SecureRandom.urlsafe_base64
  end

  def create
    # Check if an account already exists with that email.
    # If it does, automatically add bootcamp administrator role and return
    account = Account.where(:email => params[:bootcamp_invitation][:email]).first
    if account
      unless account.roles.pluck(:name).include? Role::BOOTCAMP_ADMIN
        account.roles << Role.find_by_name(Role::BOOTCAMP_ADMIN)
        account.save
      end

      bootcamp = Bootcamp.find_by_id(params[:bootcamp_invitation][:bootcamp_id])
      unless bootcamp.admins.pluck(:id).include? account.id
        bootcamp.admins << account
        bootcamp.save
      end

      return redirect_to admin_invitations_path
    end
    
    # Check if another invitation exists with that email and bootcamp.
    # If it does, expire it
    invitation = BootcampInvitation.where(
      :email => params[:bootcamp_invitation][:email],
      :bootcamp_id => params[:bootcamp_invitation][:bootcamp_id],
      :is_expired => false
      ).first
    if invitation
      invitation.update_attributes(:is_expired => true)
    end

    @invitation = BootcampInvitation.create(bootcamp_invitation_permitted)
    BootcampInvitationMailer.invite_bootcamp_admin(@invitation).deliver
    
    redirect_to admin_invitations_path
  end

  def update
    BootcampInvitation.find_by_id(params[:id]).update_attributes(bootcamp_invitation_permitted)
    respond_to do |format|
      response = { :error => false }
      format.json { render :json => response }
    end
  end

  def destroy
    BootcampInvitation.destroy(params[:id])
    respond_to do |format|
      response = { :error => false }
      format.json { render :json => response }
    end
  end

  private
    def bootcamp_invitation_permitted
      params.require(:bootcamp_invitation).permit(
        :bootcamp_id,
        :email,
        :code,
        :is_expired
      )
    end

end

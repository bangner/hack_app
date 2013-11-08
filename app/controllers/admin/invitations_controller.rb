class Admin::InvitationsController < Admin::ApplicationController

  def index
    @invitations = SchoolInvitation.all
  end

  def new
    if School.all.empty?
      return redirect_to new_admin_school_path
    end

    @invitation = SchoolInvitation.new
    @code = SecureRandom.urlsafe_base64
  end

  def create
    # Check if an account already exists with that email.
    # If it does, automatically add school administrator role and return
    account = Account.where(:email => params[:school_invitation][:email]).first
    if account
      unless account.roles.pluck(:name).include? Role::SCHOOL_ADMIN
        account.roles << Role.find_by_name(Role::SCHOOL_ADMIN)
        account.save
      end

      school = School.find_by_id(params[:school_invitation][:school_id])
      unless school.admins.pluck(:id).include? account.id
        school.admins << account
        school.save
      end

      return redirect_to admin_invitations_path
    end
    
    # Check if another invitation exists with that email and school.
    # If it does, expire it
    invitation = SchoolInvitation.where(
      :email => params[:school_invitation][:email],
      :school_id => params[:school_invitation][:school_id],
      :is_expired => false
      ).first
    if invitation
      invitation.update_attributes(:is_expired => true)
    end

    @invitation = SchoolInvitation.create(school_invitation_permitted)
    SchoolInvitationMailer.invite_school_admin(@invitation).deliver
    
    redirect_to admin_invitations_path
  end

  def update
    SchoolInvitation.find_by_id(params[:id]).update_attributes(school_invitation_permitted)
    respond_to do |format|
      response = { :error => false }
      format.json { render :json => response }
    end
  end

  def destroy
    SchoolInvitation.destroy(params[:id])
    respond_to do |format|
      response = { :error => false }
      format.json { render :json => response }
    end
  end

  private
    def school_invitation_permitted
      params.require(:school_invitation).permit(
        :school_id,
        :email,
        :code,
        :is_expired
      )
    end

end

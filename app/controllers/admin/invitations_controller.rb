class Admin::InvitationsController < Admin::ApplicationController

  def index
    @invitations = SchoolInvitation.all
  end

  def new
    @invitation = SchoolInvitation.new
    @code = SecureRandom.urlsafe_base64
  end

  def create
    SchoolInvitation.create(school_invitation_permitted)
    SchoolInvitationMailer.invite_school_admin(params[:school_invitation][:email], params[:school_invitation][:code]).deliver
    redirect_to admin_invitations_path
  end

  private
    def school_invitation_permitted
      params.require(:school_invitation).permit(
        :school_id,
        :email,
        :code
      )
    end

end

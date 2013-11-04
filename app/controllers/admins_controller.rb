class AdminsController < ApplicationController
  before_filter :valid_invite, :only => [:new, :create]

  def new
    @invitation = SchoolInvitation.find_by_code params[:code]
    @school_administrator = Account.new
  end

  def create

    # TODO: Validation

    invitation = SchoolInvitation.find_by_code params[:code]
    @school = School.find_by_id invitation.school_id

    account = Account.find_by_email(params[:account][:email])
    if account
      unless account.roles.pluck(:name).include? Role::SCHOOL_ADMIN
        account.roles << Role.find_by_name(Role::SCHOOL_ADMIN)
        account.save
      end
      unless @school.admins.pluck(:id).include? account.id
        @school.admins << account
        @school.save
      end
      invitation.expire!
      cookies[:h_a] = account.auth_token
      return redirect_to edit_school_path(@school)
    end

    admin = Account.new(school_administrator_permitted)
    admin.roles << Role.find_by_name(Role::SCHOOL_ADMIN)
    if admin.save
      @school.admins << admin
      @school.save

      invitation.expire!
      cookies[:h_a] = admin.auth_token
      redirect_to edit_school_path(@school)
    else
      render "admins/new"
    end

  end

  private
    def school_administrator_permitted
      params.require(:account).permit(
        :name,
        :email,
        :password_hash
      )
    end

  protected
    def valid_invite
      return redirect_to home_path unless params.key? :code
      invitation = SchoolInvitation.find_by_code params[:code]
      return redirect_to home_path unless invitation
      redirect_to home_path if invitation.is_expired
    end

end

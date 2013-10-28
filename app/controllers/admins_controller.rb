class AdminsController < ApplicationController
  before_filter :valid_invite, :only => [:new, :create]

  def new
    @invitation = SchoolInvitation.find_by_code params[:code]
    @school_administrator = Account.new
  end

  def create

    # TODO: Validation

    # See if school admin already exists by email (maybe tried to be an applicant?)
    # If he does exist, add SchoolAdmin role to account

    # Stripe.api_key = Rails.configuration.stripe_sk
    # customer = Stripe::Customer.create(
    #   :description => params[:school_administrator][:name],
    #   :card  => params[:stripe_card_token]
    # )

    @school_administrator = Account.new(school_administrator_permitted)
    @school_administrator.roles << Role.find_by_name(Role::SCHOOL_ADMIN)

    @invitation = SchoolInvitation.find_by_code params[:code]

    if @school_administrator.save
      school = School.find_by_id @invitation.school_id
      school.accounts << @school_administrator

      @invitation.expire!

      session[:account_id] = @school_administrator.id

      redirect_to school
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
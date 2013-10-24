class School::AdminsController < ApplicationController
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

    account = Account.new(school_administrator_permitted)
    account.roles << Role.find_by_name(Role::SCHOOL_ADMIN)

    if account.save
      invite = SchoolInvitation.find_by_code params[:code]
      school = School.find_by_id invite.school_id
      school.accounts << account
      session[:account_id] = account.id
    end

    redirect_to school
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
      redirect_to home_path unless SchoolInvitation.find_by_code params[:code]
    end

end

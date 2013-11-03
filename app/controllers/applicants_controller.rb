class ApplicantsController < ApplicationController
  def new
    @applicant = Account.new
  end
  def create
    @applicant = Account.new(applicant_permitted)
    @applicant.roles << Role.find_by_name(Role::APPLICANT)

    if @applicant.save
      cookies[:h_a] = @applicant.auth_token
      redirect_to home_path
    else
      render "applications/new"
    end
  end

  private
    def applicant_permitted
      params.require(:account).permit(
        :name,
        :email,
        :password_hash
      )
    end
end

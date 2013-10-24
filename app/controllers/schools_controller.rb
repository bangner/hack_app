class SchoolsController < ApplicationController

  def index
    @schools = School.all
  end

  def show
    @school = School.find(params[:id])
  end

  def new
    @primary_questions = Question.find_all_by_filter('primary')
    @secondary_questions = Question.find_all_by_filter('secondary')

    @school = School.new
    @school.accounts.build
  end

  def create
    # TODO: Validation

    # See if school admin already exists by email (maybe tried to be an applicant?)
    # If he does exist, add SchoolAdmin role to account

    Stripe.api_key = Rails.configuration.stripe_sk
    customer = Stripe::Customer.create(
      :description => params[:school][:name],
      :card  => params[:stripe_card_token]
    )

    school = School.new(school_permitted)
    
    school.stripe_customer_id = customer[:id]
    school.accounts.first.roles = [Role.find_by_name(Role::SCHOOL_ADMIN)]

    school.primary_application = SchoolApplication.new
    school.primary_application.question_ids = params[:questions][:primary].keys

    school.secondary_application = SchoolApplication.new
    school.secondary_application.question_ids = params[:questions][:secondary].keys

    school.save

    redirect_to school
  end

  private
    def school_permitted
      params.require(:school).permit(
        :name,
        :stripe_customer_id,
        accounts_attributes: [
          :name,
          :email,
          :password_hash
        ]
      )
    end

end

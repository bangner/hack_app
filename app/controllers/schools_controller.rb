class SchoolsController < ApplicationController

  def index
    @schools = School.all
  end

  def show
    @school = School.find(params[:id])
  end

  def edit

  end

  def update

    # Stripe.api_key = Rails.configuration.stripe_sk
    # customer = Stripe::Customer.create(
    #   :description => params[:school_administrator][:name],
    #   :card  => params[:stripe_card_token]
    # )

  end

end

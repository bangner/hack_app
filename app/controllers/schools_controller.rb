class SchoolsController < ApplicationController

  def index
    @schools = School.all
  end

  def show
    @school = School.find_by_id(params[:id])
  end

  def edit
    @school = School.find_by_id(params[:id])

    # Grab card info
    Stripe.api_key = Rails.configuration.stripe_sk
    if @school.stripe_customer_id
      @stripe_customer = Stripe::Customer.retrieve(@school.stripe_customer_id)
      @stripe_customer_card = @stripe_customer.cards.data.first if @stripe_customer.cards.count
    end
  end

  def update
    @school = School.find_by_id(params[:id])

    # Update school information based on edit form
    params[:school][:logo] = upload_logo if params[:school][:logo]
    params[:school][:price] = params[:school][:price].to_money.format(:symbol => false, :thousands_separator => false).to_f
    @school.assign_attributes(school_permitted)

    # Save school to Stripe if card change
    if params[:stripe_card_token]
      Stripe.api_key = Rails.configuration.stripe_sk
      if @school.stripe_customer_id
        @stripe_customer = Stripe::Customer.retrieve(@school.stripe_customer_id)
        @stripe_customer.card = params[:stripe_card_token] # obtained with Stripe.js
        @stripe_customer.save
      else
        @stripe_customer = Stripe::Customer.create(
          :description => params[:school][:name],
          :card  => params[:stripe_card_token]
        )
        @school.stripe_customer_id = @stripe_customer.id
      end
      @stripe_customer_card = @stripe_customer.cards.data.first
    end

    if @school.save
      flash[:notice] = "School profile changes have been made successfully."
      return redirect_to edit_school_path(@school)
    end

    # TODO Uh oh error, return
    render "schools/edit"
  end

  private
    def upload_logo
      logo_io = params[:school][:logo]
      ext = File.extname(logo_io.original_filename)

      school_slug = params[:school][:name].parameterize

      # Create directory if it does not exist
      school_directory = Rails.root.join('public', 'uploads', 'schools', school_slug).to_s
      Dir.mkdir(school_directory) unless File.exists?(school_directory)

      File.open(school_directory + '/logo' + ext, "wb") do |file|
        file.write(logo_io.read)
      end

      return home_path + 'uploads/schools/' + school_slug + '/logo' + ext
    end

    def school_permitted
      params.require(:school).permit(
        :name,
        :description,
        :website,
        :email,
        :twitter,
        :facebook,
        :focus,
        :price,
        :stack,
        :video,
        :video_source,
        :logo
      )
    end

end

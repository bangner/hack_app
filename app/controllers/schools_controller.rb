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

    # Grab application question selection
    @applications = {}
    @applications["primary"] = @school.primary_application
    @applications["secondary"] = @school.secondary_application

    # Grab questions
    @questions = Question.all.group_by { |question| question[:application_set] }
  end

  def update
    @school = School.find_by_id(params[:id])
    @account = current_account

    # Update school information based on edit form
    params[:school][:logo] = upload_logo if params[:school][:logo]
    @school.assign_attributes(school_permitted)

    # Update school applications
    @primary_application = @school.primary_application
    unless @primary_application
      @primary_application = SchoolApplication.new
      @school.primary_application = @primary_application
    end

    @secondary_application = @school.secondary_application
    unless @secondary_application
      @secondary_application = SchoolApplication.new
      @school.secondary_application = @secondary_application
    end
    
    if params[:questions]
      @primary_application.question_ids = params[:questions][:primary] ? params[:questions][:primary].keys : []
      @secondary_application.question_ids = params[:questions][:secondary] ? params[:questions][:secondary].keys : []
    else
      @primary_application.question_ids = []
      @secondary_application.question_ids = []
    end

    @primary_application.save
    @secondary_application.save

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
    @questions = Question.all.group_by { |question| question[:application_set] }
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
        :video,
        :video_source,
        :logo
      )
    end

end

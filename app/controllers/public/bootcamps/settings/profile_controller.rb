class Public::Bootcamps::Settings::ProfileController < Public::BootcampsController

  include Media
  before_filter :current_bootcamp_admin_or_super_admin_only, only: [:edit, :update]

  def edit
    @bootcamp = Bootcamp.find_by_id(params[:bootcamp_id])
    @credit_card = @bootcamp.retrieve_stripe_cc
  end

  def update
    @bootcamp = Bootcamp.find_by_id(params[:bootcamp_id])

    # Update bootcamp information based on edit form
    params[:bootcamp][:logo] = upload_logo if params[:bootcamp][:logo]
    @bootcamp.assign_attributes(bootcamp_permitted)

    # Save bootcamp to Stripe if card change
    if params.key?(:stripe_card_token)
      stripe_cust = @bootcamp.update_stripe_cc_token!(params[:stripe_card_token])
      @credit_card = stripe_cust.cards.data.first
    end

    if @bootcamp.save
      flash[:notice] = "Bootcamp profile changes have been made successfully."
      return redirect_to edit_bootcamp_settings_profile_path(@bootcamp)
    end

    # TODO Uh oh error, return
    render "bootcamps/edit"
  end

  private

    def bootcamp_permitted
      params.require(:bootcamp).permit(
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

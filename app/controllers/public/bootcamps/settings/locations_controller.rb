class Public::Bootcamps::Settings::LocationsController < Public::BootcampsController

  before_filter :current_bootcamp_admin_or_super_admin_only, only: [:edit, :update]

  def edit
    @bootcamp = Bootcamp.find_by_id(params[:bootcamp_id])

    # Build locations if it does not exist
    if @bootcamp.locations.empty?
      @bootcamp.locations.build
    end
  end

  def update
    @bootcamp = Bootcamp.find_by_id(params[:bootcamp_id])
    @bootcamp.assign_attributes(bootcamp_location_permitted)

    if @bootcamp.save
      flash[:notice] = "Bootcamp locations have been saved successfully."
      return redirect_to edit_bootcamp_settings_locations_path(@bootcamp)
    end

    # TODO Uh oh error, return
    render "bootcamps/locations/edit"
  end

  private
    def bootcamp_location_permitted
      params.require(:bootcamp).permit(
        :locations_attributes => [
          :street,
          :city,
          :state,
          :zip
        ]
      )
    end
    
end

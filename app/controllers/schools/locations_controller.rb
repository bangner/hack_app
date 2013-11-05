class Schools::LocationsController < ApplicationController
  
  def edit
    @school = School.find_by_id(params[:school_id])

    # Build locations if it does not exist
    if @school.locations.empty?
      @school.locations.build
    end
  end

  def update
    @school = School.find_by_id(params[:school_id])
    @school.assign_attributes(school_location_permitted)

    if @school.save
      flash[:notice] = "School locations have been saved successfully."
      return redirect_to edit_school_locations_path(@school)
    end

    # TODO Uh oh error, return
    render "schools/locations/edit"
  end

  private
    def school_location_permitted
      params.require(:school).permit(
        :locations_attributes => [
          :street,
          :city,
          :state,
          :zip
        ]
      )
    end

end

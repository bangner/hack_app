class Applicants::ApplicationsController < ApplicationController

  def show
    unless @application = current_application
      return render :json => { :error => "We need you to create an applicant profile first." }
    end
    render :json => @application, :include => :school_selections
  end

  def update
    unless @application = current_application
      return render :json => { :error => "We need you to create an applicant profile first." }
    end

    @application.school_selections = []
    if params[:school_selections]
      already_selected = []
      params[:school_selections].each do |key, school_selection|
        next if already_selected.include? school_selection[:school_id]
        
        @school_selection = SchoolSelection.new
        @school_selection.priority = school_selection[:priority]
        @school_selection.school_id = school_selection[:school_id]
        @application.school_selections << @school_selection
        already_selected << school_selection[:school_id]
      end
    end

    return render :json => { :error => false } if @application.save
      
    render :json => { :error => "Error occurred saving the application." }
  end

  private
    def current_application
      @applicant = current_account

      @applicant_profile = ApplicantProfile.find_by_account_id(@applicant.id)
      return nil unless @applicant_profile

      @application = Application.where(submitted_at: nil, applicant_profile_id: @applicant_profile.id).first
      unless @application
        @application = Application.new
        @application.applicant_profile_id = @applicant_profile.id
        @application.school_selections = []
        @application.save
      end

      @application
    end

end

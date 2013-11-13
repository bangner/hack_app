class Application < ActiveRecord::Base
  belongs_to :applicant_profile
  has_many :bootcamp_selections

  accepts_nested_attributes_for :bootcamp_selections

  def self.find_active_by_applicant applicant
    self
      .includes(bootcamp_selections: [:bootcamp])
      .where(
        submitted_at: nil,
        applicant_profile_id: ApplicantProfile.find_by_account_id(applicant))
      .first
  end

  def self.find_last_active_by_applicant applicant
    self
      .includes(bootcamp_selections: [:bootcamp])
      .where.not(submitted_at: nil)
      .where(applicant_profile_id: ApplicantProfile.find_by_account_id(applicant))
      .order(submitted_at: :desc)
      .first
  end

  def self.find_active_by_profile applicant_profile
    self
      .includes(bootcamp_selections: [:bootcamp])
      .where(
        submitted_at: nil,
        applicant_profile_id: applicant_profile)
      .first
  end

  def self.init_for_applicant_profile applicant_profile
    application = self.find_active_by_profile(applicant_profile)
    return application if application
    Application.create(:applicant_profile_id => applicant_profile.id)
  end

  def update_selections selections
    self.bootcamp_selections.destroy_all
    selections.each do |key, selection|
      next unless selection.key?(:priority) and selection.key?(:bootcamp_id)
      self.bootcamp_selections << BootcampSelection.new(
        priority: selection[:priority],
        bootcamp_id: selection[:bootcamp_id])
    end
    self.save
  end

  def detect_selection b_id
    self.bootcamp_selections.detect { |s| s.bootcamp_id.to_s == b_id.to_s }
  end

  def prioritized_selections
    self.bootcamp_selections.sort_by { |s| s.priority }
  end

  def send_selections
    # Email each selection with the applicant's profile
    self.bootcamp_selections.each do |selection|
      selection.send_applicant_profile(self.applicant_profile)
    end

    # Update submitted time and save
    self.update_attributes(:submitted_at => DateTime.now)

    # Automatically create new active application for user
    Application.init_for_applicant_profile(self.applicant_profile)
  end

end

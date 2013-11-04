class ApplicantProfileAnswer < ActiveRecord::Base
  self.table_name = "applicant_profile_answers"
  
  has_and_belongs_to_many :applicant_profiles
  belongs_to :question
end

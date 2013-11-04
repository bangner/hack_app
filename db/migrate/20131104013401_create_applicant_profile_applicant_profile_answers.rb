class CreateApplicantProfileApplicantProfileAnswers < ActiveRecord::Migration
  def change
    create_table :applicant_profiles_applicant_profile_answers do |t|
      t.belongs_to :applicant_profile
      t.belongs_to :applicant_profile_answer
    end
  end
end

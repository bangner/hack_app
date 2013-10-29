class CreateApplicantProfilesQuestions < ActiveRecord::Migration
  def change
    create_table :applicant_profiles_questions do |t|
      t.belongs_to :applicant_profile
      t.belongs_to :question
    end
  end
end

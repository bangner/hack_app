class CreateApplicantProfileAnswers < ActiveRecord::Migration
  def change
    create_table :applicant_profile_answers do |t|
      t.text :answer
      t.belongs_to :question

      t.timestamps
    end
  end
end

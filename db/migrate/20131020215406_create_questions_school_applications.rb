class CreateQuestionsSchoolApplications < ActiveRecord::Migration
  def change
    create_table :questions_school_applications do |t|
      t.belongs_to :question
      t.belongs_to :school_application
    end
  end
end

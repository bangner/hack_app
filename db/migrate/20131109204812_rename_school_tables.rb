class RenameSchoolTables < ActiveRecord::Migration
  def change
    rename_table :schools, :bootcamps
    rename_table :accounts_schools, :accounts_bootcamps
    rename_table :questions_school_applications, :bootcamp_applications_questions
    rename_table :school_applications, :bootcamp_applications
    rename_table :school_invitations, :bootcamp_invitations
    rename_table :school_locations, :bootcamp_locations
    rename_table :school_selections, :bootcamp_selections
  end
end

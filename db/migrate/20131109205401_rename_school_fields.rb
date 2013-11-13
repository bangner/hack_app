class RenameSchoolFields < ActiveRecord::Migration
  def change
    rename_column :accounts_bootcamps, :school_id, :bootcamp_id
    rename_column :bootcamp_applications_questions, :school_application_id, :bootcamp_application_id
    rename_column :bootcamp_invitations, :school_id, :bootcamp_id
    rename_column :bootcamp_locations, :school_id, :bootcamp_id
    rename_column :bootcamp_selections, :school_id, :bootcamp_id
  end
end

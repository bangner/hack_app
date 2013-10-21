class CreateSchoolApplications < ActiveRecord::Migration
  def change
    create_table :school_applications do |t|
      t.timestamps
    end
  end
end

class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.belongs_to :applicant_profile

      t.timestamps
    end
  end
end

class CreateApplicantProfiles < ActiveRecord::Migration
  def change
    create_table :applicant_profiles do |t|
      t.belongs_to :account

      t.timestamps
    end
  end
end

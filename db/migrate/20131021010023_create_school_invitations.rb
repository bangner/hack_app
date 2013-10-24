class CreateSchoolInvitations < ActiveRecord::Migration
  def change
    create_table :school_invitations do |t|
      t.belongs_to :school
      t.string :email
      t.string :code
      t.boolean :is_expired, default: false
      
      t.timestamps
    end
  end
end

class CreateSchoolSelections < ActiveRecord::Migration
  def change
    create_table :school_selections do |t|
      t.integer :priority
      t.belongs_to :school
      t.belongs_to :application
      
      t.timestamps
    end
  end
end

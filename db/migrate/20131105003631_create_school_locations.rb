class CreateSchoolLocations < ActiveRecord::Migration
  def change
    create_table :school_locations do |t|
      t.string :street
      t.string :city
      t.string :state
      t.string :zip
      t.belongs_to :school

      t.timestamps
    end
  end
end

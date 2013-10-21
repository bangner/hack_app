class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.references :primary_application
      t.references :secondary_application

      t.string :name
      t.string :stripe_customer_id

      t.timestamps
    end
  end
end

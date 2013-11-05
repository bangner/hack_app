class AddCourseInfoToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :focus, :string
    add_column :schools, :price, :decimal
    add_column :schools, :stack, :string
  end
end

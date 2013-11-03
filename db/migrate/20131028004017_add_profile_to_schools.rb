class AddProfileToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :description, :text
    add_column :schools, :website, :string
    add_column :schools, :email, :string
    add_column :schools, :twitter, :string
    add_column :schools, :facebook, :string
    add_column :schools, :video, :string
    add_column :schools, :logo, :text
  end
end

class AddVideoSourceToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :video_source, :string
  end
end

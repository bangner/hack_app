class AddColumnsToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :submitted_at, :datetime
  end
end

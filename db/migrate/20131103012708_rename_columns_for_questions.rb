class RenameColumnsForQuestions < ActiveRecord::Migration
  def change
    change_table :questions do |t|
      t.rename :filter, :group
      t.rename :extra, :helper
    end
  end
end

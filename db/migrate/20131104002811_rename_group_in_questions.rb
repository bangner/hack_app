class RenameGroupInQuestions < ActiveRecord::Migration
  def change
    change_table :questions do |t|
      t.rename :group, :field_set
    end
  end
end

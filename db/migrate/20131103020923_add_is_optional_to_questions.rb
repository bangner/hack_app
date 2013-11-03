class AddIsOptionalToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :is_optional, :boolean, :default => false
  end
end

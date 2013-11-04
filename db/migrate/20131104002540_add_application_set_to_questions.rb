class AddApplicationSetToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :application_set, :string
  end
end

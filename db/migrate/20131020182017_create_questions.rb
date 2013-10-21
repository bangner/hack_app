class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :name
      t.text :label
      t.string :filter
      t.string :question_type
      t.text :extra

      t.timestamps
    end
  end
end

class CreateAccountsSchools < ActiveRecord::Migration
  def change
    create_table :accounts_schools do |t|
      t.belongs_to :account
      t.belongs_to :school
    end
  end
end

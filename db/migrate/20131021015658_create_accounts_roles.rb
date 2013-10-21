class CreateAccountsRoles < ActiveRecord::Migration
  def change
    create_table :accounts_roles do |t|
      t.belongs_to :account
      t.belongs_to :role
    end
  end
end

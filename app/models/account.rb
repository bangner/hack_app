class Account < ActiveRecord::Base
  validates_presence_of :name, :email, :password_hash

  has_and_belongs_to_many :schools
  has_and_belongs_to_many :roles

  accepts_nested_attributes_for :roles
end

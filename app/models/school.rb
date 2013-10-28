class School < ActiveRecord::Base
  validates_presence_of :name, :description, :duration, :stack, :website, :email, :street, :city, :state, :price, :zip, :logo

  has_and_belongs_to_many :accounts
  has_many :school_invitations

  belongs_to :primary_application,
    class_name: "SchoolApplication",
    :foreign_key => 'primary_application_id',
    dependent: :destroy

  belongs_to :secondary_application,
    class_name: "SchoolApplication",
    :foreign_key => 'secondary_application_id',
    dependent: :destroy

  accepts_nested_attributes_for :accounts
end

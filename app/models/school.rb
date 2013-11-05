class School < ActiveRecord::Base
  validates_presence_of :name, :description, :website, :email, :logo

  has_and_belongs_to_many :admins, class_name: "Account"
  has_many :school_invitations, :dependent => :destroy
  has_many :locations, class_name: "SchoolLocation"

  belongs_to :primary_application,
    class_name: "SchoolApplication",
    :foreign_key => 'primary_application_id',
    dependent: :destroy

  belongs_to :secondary_application,
    class_name: "SchoolApplication",
    :foreign_key => 'secondary_application_id',
    dependent: :destroy

  accepts_nested_attributes_for :admins, :locations
end

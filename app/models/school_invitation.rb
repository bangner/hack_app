class SchoolInvitation < ActiveRecord::Base
  validates_presence_of :email, :code
  belongs_to :school
end

class SchoolInvitation < ActiveRecord::Base
  validates_presence_of :email, :code
  belongs_to :school
  
  def expire!
    self.is_expired = true
    self.save
  end
end

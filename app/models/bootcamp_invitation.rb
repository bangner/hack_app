class BootcampInvitation < ActiveRecord::Base
  validates_presence_of :email, :code
  belongs_to :bootcamp
  
  def expire!
    self.is_expired = true
    self.save
  end

end

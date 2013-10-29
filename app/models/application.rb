class Application < ActiveRecord::Base
  has_one :applicant_profile
  has_many :school_selections
end

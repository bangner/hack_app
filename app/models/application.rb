class Application < ActiveRecord::Base
  has_one :applicant_profile
  has_many :school_selections

  accepts_nested_attributes_for :school_selections
end

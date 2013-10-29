class SchoolSelection < ActiveRecord::Base
  has_one :school
  belongs_to :application
end

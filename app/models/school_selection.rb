class SchoolSelection < ActiveRecord::Base
  belongs_to :school
  belongs_to :application
end

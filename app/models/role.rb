class Role < ActiveRecord::Base
  SUPER_ADMIN = "SuperAdmin"
  SCHOOL_ADMIN = "SchoolAdmin"
  APPLICANT = "Applicant"

  has_and_belongs_to_many :accounts
end

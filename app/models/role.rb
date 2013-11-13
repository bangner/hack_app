class Role < ActiveRecord::Base
  SUPER_ADMIN = "SuperAdmin"
  BOOTCAMP_ADMIN = "BootcampAdmin"
  APPLICANT = "Applicant"

  has_and_belongs_to_many :accounts
end

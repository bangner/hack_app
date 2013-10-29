class ApplicantProfile < ActiveRecord::Base
  has_and_belongs_to_many :questions
  belongs_to :account
  belongs_to :application
end

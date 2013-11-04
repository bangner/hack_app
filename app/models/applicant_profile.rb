class ApplicantProfile < ActiveRecord::Base
  has_and_belongs_to_many :answers, class_name: "ApplicantProfileAnswer", join_table: "applicant_profiles_applicant_profile_answers"
  belongs_to :account
  belongs_to :application

  accepts_nested_attributes_for :answers
end

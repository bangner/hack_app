class BootcampApplication < ActiveRecord::Base
  has_and_belongs_to_many :questions
  belongs_to :bootcamp
end

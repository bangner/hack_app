class Question < ActiveRecord::Base
  after_create :add_to_applications
  before_destroy :remove_from_applications

  private
    def add_to_applications
      return unless self.application_set.eql? "primary"
      School.all.each do |school|
        school.primary_application.questions << self
        school.primary_application.save
      end
    end
    def remove_from_applications
      return unless self.application_set.eql? "primary"
      School.all.each do |school|
        school.primary_application.questions.delete(self)
        school.primary_application.save
      end
    end
end

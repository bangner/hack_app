class Question < ActiveRecord::Base
  after_create :add_to_applications
  before_destroy :remove_from_applications

  def self.primary
    self.where(:application_set => "primary")
  end

  def self.primary_by_field_set
    self.primary.group_by { |q| q[:field_set] }
  end

  def self.get_by_application_set
    self.all.group_by { |q| q[:application_set] }
  end

  private
    def add_to_applications
      return unless self.application_set.eql? "primary"
      Bootcamp.all.each do |bootcamp|
        bootcamp.primary_application.questions << self
        bootcamp.primary_application.save
      end
    end
    def remove_from_applications
      return unless self.application_set.eql? "primary"
      Bootcamp.all.each do |bootcamp|
        bootcamp.primary_application.questions.delete(self)
        bootcamp.primary_application.save
      end
    end
end

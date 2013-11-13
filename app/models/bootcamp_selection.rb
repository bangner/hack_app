class BootcampSelection < ActiveRecord::Base
  belongs_to :bootcamp
  belongs_to :application

  def bootcamp_interested_in_answer? answer
    self.bootcamp.primary_application.questions.pluck(:id).include? answer.question_id
  end

  def send_applicant_profile applicant_profile
    answers = []
    applicant_profile.answers.each do |profile_answer|
      unless profile_answer.answer.empty?
        if self.bootcamp_interested_in_answer? profile_answer
          answers << profile_answer
        end
      end
    end

    ApplicationMailer.send_profile_to_bootcamp(
      self.bootcamp.admins,
      applicant_profile.account,
      self,
      answers
    ).deliver
  end
end

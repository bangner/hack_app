class ApplicantProfile < ActiveRecord::Base
  has_and_belongs_to_many :answers, class_name: "ApplicantProfileAnswer", join_table: "applicant_profiles_applicant_profile_answers"
  belongs_to :account
  has_one :application

  accepts_nested_attributes_for :answers

  def self.pull_for_applicant applicant
    ApplicantProfile.includes(:answers).find_by_account_id(applicant)
  end

  def self.init_for_applicant account
    applicant_profile = ApplicantProfile.find_by_account_id(account)
    return applicant_profile if applicant_profile
    ApplicantProfile.create(:account => account.id)
  end

  def update_answers answers
    answers.each do |q_id, ans|
      o_ans = self.detect_answer q_id

      # Delete answer if it is empty
      # Otherwise check if empty answer and ignore
      if ans.strip.empty? and o_ans
        self.answers.delete(o_ans)
        next
      elsif ans.strip.empty?
        next
      end

      # Update answer of add new one
      if o_ans
        o_ans.update_attributes(:answer => ans)
      else
        self.answers << ApplicantProfileAnswer.new(question_id: q_id, answer: ans)
      end

    end
    self.save
  end

  def detect_answer q_id
    self.answers.detect { |a| a.question_id.to_s == q_id.to_s }
  end

  def required_answered?
    true
  end
end

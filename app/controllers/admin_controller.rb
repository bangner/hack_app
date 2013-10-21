class AdminController < ActionController::Base
  
  def index
  end

  def questions
    @questions = Question.all
  end

end

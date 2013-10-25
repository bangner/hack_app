class Admin::QuestionsController < Admin::ApplicationController

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def create
    Question.create(question_permitted)
    redirect_to admin_questions_path
  end

  private
    def question_permitted
      params.require(:question).permit(
        :name,
        :label,
        :filter,
        :question_type,
        :extra
      )
    end

end

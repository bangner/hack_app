class Admin::QuestionsController < Admin::FrontController

  def index
    @questions = Question.all
    respond_to do |format|
      format.html { render "admin/questions/index" }
      format.json { render :json => @questions }
    end
  end

  def new
    @question = Question.new
    @existing_types = Question.all.pluck(:question_type).uniq
    @existing_types << "Other"
  end

  def create
    reconcile_question_type
    Question.create(question_permitted)
    redirect_to admin_questions_path
  end

  def edit
    @question = Question.find_by_id(params[:id])
    @existing_types = Question.all.pluck(:question_type).uniq
    @existing_types << "Other"
  end

  def update
    reconcile_question_type
    Question.find_by_id(params[:id]).update_attributes(question_permitted)
    redirect_to admin_questions_path
  end

  def destroy
    Question.destroy(params[:id])
    respond_to do |format|
      response = { :error => false }
      format.json { render :json => response }
    end
  end

  private
    def reconcile_question_type
      params[:question][:question_type] = params[:question_type_other] if params[:question][:question_type].eql? "Other"
    end

    def question_permitted
      params.require(:question).permit(
        :name,
        :label,
        :is_optional,
        :application_set,
        :field_set,
        :question_type,
        :helper
      )
    end

end

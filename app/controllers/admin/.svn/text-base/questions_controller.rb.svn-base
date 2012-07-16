#@Author = Tarek Mehrez
#@Author = Nada Nasr
class Admin::QuestionsController < AdminsController

  # @Author: Nada Nasr
  # @Summary: creates a new question with the passed parameters
  # @paramName: params[:question] => content submitted in the form
  def create
    @new_question = Question.new(params[:question])
    respond_to do |format|
      if  @new_question.save
        format.html { redirect_to admin_questions_path, :notice => "question successfully added" }
      else
        @questions = Question.all
        format.html { render action: "index" }
        format.json { render json: @new_question.errors, status: :unprocessable_entity }
      end
    end
  end

  #@Author: Tarek Mehrez, Nada Nasr
  #@Summary: Get all questions and pass them through the object @questions to the view 
  def index
    @questions = Question.all
    @new_question = Question.new
  end
end

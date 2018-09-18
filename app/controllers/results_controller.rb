class ResultsController < ApplicationController
  before_action :find_result, only: [:show, :destroy, :edit, :update, :technical_answers]
  http_basic_authenticate_with name: Password::USERNAME, password: Password::PASSWORD

  require 'csv'

  def index
    if(params[:search] || params[:collage_name])
      @results =  Result.joins(:student).where('students.email ilike ? and students.collage_name ilike ?', "%#{params[:search]}%", "%#{params[:collage_name]}%")
    else
      @results = Result.all
    end
    if params[:format] == 'csv'
      respond_to do |format|
        format.html
        format.csv { send_data @results.to_csv }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    if params[:sum].present?
      @result.update_attributes(technical_marks: params[:sum])
      redirect_to results_path
    end
  end

  def destroy
    @result.destroy
    redirect_to results_path
  end

  def technical_answers
    @student = @result.student
    @answers = @student.answers
  end

  private

  def find_result
    @result = Result.find(params[:id])
  end
end

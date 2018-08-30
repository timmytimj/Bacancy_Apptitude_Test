class StudentsController < ApplicationController
  before_action :find_student, only: [:show, :edit, :update, :destroy]

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(student_params)
    @student.test_id = Test.ids.sample
    if @student.save
      redirect_to new_student_answer_path
    else
      render 'new'
    end
    session[:student_id] = @student.id
  end

  def edit
  end

  def existing_user
  end

  def assign_test
    @student = Student.find_by(email: params[:email])
    if @student.present?
      @test_ids = Test.all.ids
      @test_ids.delete(@student.test.id)
      @student.test_id = @test_ids.sample
      @student.save
      session[:student_id] = @student.id
      redirect_to new_student_answer_path
    else
      redirect_to student_existing_user_path
    end
  end

  def update
    if @student.update(student_params)
      redirect_to students_path
    else
      render 'edit'
    end
  end

  def destroy
    @student.destroy
    redirect_to students_path
  end

  def index
    @students = Student.all
  end

  def show
  end

  def logout
    session[:student_id] = nil
    redirect_to root_path
  end

  private

  def student_params
    params.require(:student).permit(:name, :email, :course, :roll_number, :collage_name, :mobile_number, :test_id)
  end

  def find_student
    @student = Student.find(params[:id])
  end
end

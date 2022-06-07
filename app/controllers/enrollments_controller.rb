class EnrollmentsController < ApplicationController
  before_action :validate_enrollment_params, only: :create
  before_action :find_enrollment, only: :destroy

  ALLOWED_ROLE = %w[student teacher]
  
  def create
    new_enrollment = {
      id: Data.enrollments[:id] + 1,
      user_id: enrollment_params[:user_id].to_i,
      course_id: enrollment_params[:course_id].to_i,
      role: enrollment_params[:role]
    }
    Data.enrollments[:data] << new_enrollment
    render json: { data: new_enrollment }, status: :created
  end

  def destroy
    if @enrollment
      Data.enrollments[:data].delete_at(Data.enrollments[:data].index(@enrollment))

      render json: { msg: 'enrollment widhdrawed' }
    else
      render json: { msg: 'enrollment not exist' }, status: :bad_request
    end
  end

  def show
    enrollment = Data.enrollments[:data].find { _1[:id] == params[:id].to_i }
    if enrollment
      render json: { data: enrollment }
    else
      render json: { msg: 'enrollment not exist' }, status: :bad_request
    end
  end

  def search
    case enrollment_params.as_json.symbolize_keys
        in { user_id: , course_id: , role: } => pattern
        in { user_id: , course_id: } => pattern
        in { user_id: , role: } => pattern
        in { course_id: , role: } => pattern
        in { user_id: } => pattern
        in { course_id: } => pattern
        in { role: } => pattern
    else
      return render json: { msg: '' }
    end

    pattern[:user_id] = pattern[:user_id].to_i if pattern[:user_id]
    pattern[:course_id] = pattern[:course_id].to_i if pattern[:course_id]

    enrollments = Data.enrollments[:data].filter do |enrollment|
      pattern.all? { enrollment[_1] == _2 }
    end
    if enrollments.any?
      render json: { data: enrollments }
    else
      render json: { msg: 'enrollment not exist' }, status: :bad_request
    end
  end

  private

  def validate_enrollment_params
    case enrollment_params.as_json.symbolize_keys
        in { user_id: , course_id: , role: }
        return bad_create_response unless Data.users[:data].any? { _1[:id] == user_id.to_i }
        return bad_create_response unless Data.courses[:data].any? { _1[:id] == course_id.to_i }
        return bad_create_response unless ALLOWED_ROLE.include?(role)
    else
      return bad_create_response
    end
  end

  def bad_create_response
    render json: { msg: 'user, course, or role not allowed' }, status: :bad_request
  end

  def enrollment_params
    params.permit(:user_id, :course_id, :role)
  end

  def find_enrollment
    @enrollment = Data.enrollments[:data].find { _1[:id] == params[:id].to_i }
  end
end

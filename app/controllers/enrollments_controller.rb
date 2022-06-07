class EnrollmentsController < ApplicationController
  before_action :validate_create_params, only: :create
  before_action :find_enrollment, only: :destroy

  ALLOWED_ROLE = %w[student teacher]
  
  def create
    new_enrollment = {
      id: Data.enrollments[:id] + 1,
      user_id: create_params[:user_id].to_i,
      course_id: create_params[:course_id].to_i,
      role: create_params[:role]
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

  private

  def validate_create_params
    case create_params.as_json.symbolize_keys
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

  def create_params
    params.permit(:user_id, :course_id, :role)
  end

  def find_enrollment
    @enrollment = Data.enrollments[:data].find { _1[:id] == params[:id].to_i }
  end
end

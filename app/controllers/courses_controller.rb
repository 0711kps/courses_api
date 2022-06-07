class CoursesController < ApplicationController
  before_action :find_course, only: %i[show]
  def users
    user_ids = Data.enrollments[:data].filter { |enrollment| enrollment[:id] == params[:id].to_i }.uniq
    return render json: { msg: 'no users matched' }, status: :bad_request unless user_ids.any?
    
    users = Data.users[:data].filter { |user| user_ids.include?(user[:id]) }
    render json: { data: users }
  end

  def show
    if @course
      render json: { data: @course }
    else
      render json: { msg: 'course not exist' }, status: :bad_request
    end
  end

  private

  def find_course
    @course = Data.courses[:data].find { _1[:id] == params[:id].to_i }
  end
end

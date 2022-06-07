class UsersController < ApplicationController
  before_action :validate_email, only: %i[create search update]
  before_action :find_user, only: %i[show update destroy]

  def create
    Data.users[:data] << {
      id: Data.users[:id] + 1,
      name: user_params[:name],
      email: user_params[:email]
    }
    Data.users[:id] += 1
    render json: { msg: 'user created' }, status: :created
  end

  def update
    @user.merge!(user_params.as_json.symbolize_keys)
    render json: { data: @user }
  end

  def destroy
    Data.users[:data].delete_at(Data.users[:data].index(@user))
    render json: { msg: 'user deleted '}
  end

  def show
    return render json: { msg: 'user not exist' }, status: :bad_request unless @user

    render json: { data: @user }
  end

  def search
    case user_params.as_json.symbolize_keys
        in { email: , name: } => pattern
        in { email: } => pattern
        in { name: } => pattern
    else
      return render json: { msg: 'email or name not given' }, status: :bad_request
    end
    user = Data.users[:data].find do |user|
      pattern.all? { user[_1] == _2 }
    end
    if user
      render json: { data: user }
    else
      render json: { msg: 'user not exist' }, status: :bad_request
    end
  end

  def courses
    course_ids = Data.enrollments[:data].filter { _1[:user_id] == params[:id].to_i }.map { _1[:course_id] }
    if course_ids.any?
      courses = Data.courses[:data].filter { course_ids.include?(_1[:id]) }
      render json: { data: courses }
    else
      render json: { msg: 'user not exist' }, status: :bad_request
    end
  end

  private

  def user_params
    params.permit(:email, :name)
  end

  def validate_email
    if params[:email] && !params[:email].match?(/^\S+@\S+$/)
      return render json: { msg: 'email not allowed' }, status: :bad_request
    end
  end

  def find_user
    @user = Data.users[:data].find { |user| user[:id] == params[:id].to_i }
    render json: { msg: 'user not exist' }, status: :bad_request unless @user
  end
end

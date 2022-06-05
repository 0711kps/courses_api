class UsersController < ApplicationController
  before_action :validate_email, only: %i[create search]
  def create
    Data.users[:data] << {
      id: Data.users[:id] + 1,
      name: user_params[:name],
      email: user_params[:email]
    }
    Data.users[:id] += 1
    render json: { msg: 'user created' }, status: :created
  end

  def show
    user = Data.users[:data].find { |user|  user[:id] == params[:id].to_i }
    return render json: { msg: 'user not exist' }, status: :bad_request unless user

    render json: { data: user }
  end

  def search
    case user_params.as_json.symbolize_keys
        in { email: , name: } => pattern
        in { email: } => pattern
        in { name: } => pattern
    else
      return render json: { msg: 'email or name not given' }, status: :bad_request
    end
    user = Data.users[:data].find { |user| user in pattern }
    if user
      render json: { data: user }
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
end

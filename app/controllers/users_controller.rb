class UsersController < ApplicationController
  def create
    if !create_params[:email].match?(/^\S+@\S+$/)
      return render json: { msg: 'email not allowed' }, status: :bad_request
    end

    Data.users[:data] << {
      id: Data.users[:id] + 1,
      name: create_params[:name],
      email: create_params[:email]
    }
    Data.users[:id] += 1
    render json: { msg: 'user created' }, status: :created
  end

  def show
    user = Data.users[:data].find { |user|  user[:id] == params[:id].to_i }
    return render json: { msg: 'user not exist' }, status: :bad_request unless user

    render json: { data: user }
  end


  private

  def create_params
    params.permit(:email, :name)
  end
end

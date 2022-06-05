require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "POST /users" do
    let(:path) { '/users' }
    context 'When email not match regexp' do
      let(:sending_data) { { email: 'wrong-params' } }
      it 'Response with 400' do
        post path, params: sending_data
        expect(response).to have_http_status(400)
      end
    end

    context 'When email match regexp' do
      let(:sending_data) { { email: 'user@correct.mail.com', name: 'username' } }
      it 'Response with 201 and user created' do
        post path, params: sending_data
        expect(response).to have_http_status(201)
        expect(Data.users[:id]).to eq(1)
        expect(Data.users[:data]).to eq(
                                       [
                                         {
                                           id: 1,
                                           name: 'username',
                                           email: 'user@correct.mail.com'
                                          }
                                       ])
      end
    end
  end

  describe 'GET /user/{:id}' do
    let(:path) { '/users/1' }
    context 'When user with target ID exist' do
      let(:user_data) do
        {
          id: 1,
          name: 'first user',
          email: 'first-user@mail.com'
        }
        end
      it 'Response with user data and 200' do
        Data.users[:data] << user_data
        get path
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['data'].symbolize_keys).to eq(user_data)
      end
    end

    context 'When user with target ID does not exist' do
      it 'Response with 400' do
        get path
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'GET /users/search' do
    let(:user_data) do
      {
        id: 1,
        name: 'user',
        email: 'user@mail.com'
      }
    end
    
    context 'When email given' do
      let(:path) { '/users/search?email=user@mail.com' }

      context 'When user exist' do
        it 'Response with user data and 200' do
          Data.users[:data] << user_data
          get path
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body)['data'].symbolize_keys).to eq(user_data)
        end
      end

      context 'When user does not exist' do
        it 'Response with 400' do
          get path
          expect(response).to have_http_status(400)
        end
      end
    end
    
    context 'When name given' do
      let(:path) { '/users/search?name=user' }

      context 'When user exist' do
        it 'Response with user data and 200' do
          Data.users[:data] << user_data
          get path
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body)['data'].symbolize_keys).to eq(user_data)
        end
      end

      context 'When user does not exist' do
        it 'Response with 400' do
          get path
          expect(response).to have_http_status(400)
        end
      end
    end
    
    context 'When both given' do
      let(:path) { '/users/search?email=user@mail.com&name=user' }

      context 'When user exist' do
        it 'Response with user data and 200' do
          Data.users[:data] << user_data
          get path
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body)['data'].symbolize_keys).to eq(user_data)
        end
      end

      context 'When user does not exist' do
        it 'Response with 400' do
          get path
          expect(response).to have_http_status(400)
        end
      end
    end
  end
end

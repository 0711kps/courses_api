require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:header_with_token) do
    {
      'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoid29vbCIsImV4cGlyZWRfYXQiOiIyMDIyLTA2LTA3IDE2OjIwOjQ3ICswODAwIn0.KPokejZb4V5DvvDN_KB4q8ZSOa5xIgBbSMcl69Xe8a4'
    }
  end
  describe "POST /users" do
    let(:path) { '/users' }
    
    context 'When legal token is not contained in header' do
      let(:sending_data) { { email: 'user@correct.mail.com', name: 'username' } }
      it 'Response with 401' do
        post path, params: sending_data
        expect(response).to have_http_status(401)
      end
    end
    
    context 'When email not match regexp' do
      let(:sending_data) { { email: 'wrong-params' } }
      it 'Response with 400' do
        post path, params: sending_data, headers: header_with_token
        expect(response).to have_http_status(400)
      end
    end

    context 'When email match regexp' do
      let(:sending_data) { { email: 'user@correct.mail.com', name: 'username' } }
      it 'Response with 201 and user created' do
        post path, params: sending_data, headers: header_with_token
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

  describe 'PUT /users/1' do
    let(:path) { '/users/1' }

    context 'When legal token is not contained in header' do
      it 'Response with 401' do
        put path
        expect(response).to have_http_status(401)
      end
    end

    context 'When user exist' do
      let(:user_data) do
        {
          name: 'user',
          email: 'user@mail.com'
        }
      end
      let(:updated_user_data) do
        {
          name: 'user-x',
          email: 'user-x@mail.com'
        }
      end

      it 'Response with 200 and updated data' do
        Data.users[:data] << user_data.merge(id: 1)
        put path, params: updated_user_data, headers: header_with_token
        expect(response).to have_http_status(200)
        expect(Data.users[:data]).to eq([{id: 1, name: 'user-x', email: 'user-x@mail.com'}])
        expect(JSON.parse(response.body)['data'].symbolize_keys).to eq(updated_user_data.merge(id: 1))
      end
    end

    context 'When user not exist' do
      it 'Response with 400' do
        put path, headers: header_with_token
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'DELETE /users/1' do
    let(:path) { '/users/1' }

    context 'When legal token is not contained in header' do
      it 'Response with 401' do
        delete path
        expect(response).to have_http_status(401)
      end
    end
    
    context 'user exist' do
      it 'Response with 200 and user deleted' do
        Data.users[:data] << {
          id: 1,
          name: 'victim',
          email: 'victim@mail.com'
        }

        delete path, headers: header_with_token
        expect(response).to have_http_status(200)
        expect(Data.users[:data]).to eq([])
      end
    end

    context 'user not exist' do
      it 'Response with 400' do
        delete path, headers: header_with_token
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'GET /courses/{:id}/users' do
    let(:path) { '/courses/1/users' }

    context 'When users of that course exist' do
      let(:enrollment) do
        {
          id: 1,
          user_id: 1,
          course_id: 1,
          role: 'student'
        }
      end

      let(:user_data) do
        {
          id: 1,
          name: 'a student',
          email: 'stu@mail.com'
        }
      end

      it 'Response with 200 and users data' do
        Data.users[:data] << user_data
        Data.enrollments[:data] << enrollment
        get path
        expect(response).to have_http_status(200)
        expect(
          JSON
            .parse(response.body)['data']
            .map { |user| user.symbolize_keys }
        )
      end
    end

    context 'When users of that course does not exist' do
      it 'Response with 400' do
        get path
        expect(response).to have_http_status(400)
      end
    end
  end
end

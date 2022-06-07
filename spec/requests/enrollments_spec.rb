require 'rails_helper'

RSpec.describe "Enrollments", type: :request do
 let(:header_with_token) do
    {
      'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoid29vbCIsImV4cGlyZWRfYXQiOiIyMDIyLTA2LTA3IDE2OjIwOjQ3ICswODAwIn0.KPokejZb4V5DvvDN_KB4q8ZSOa5xIgBbSMcl69Xe8a4'
    }
 end
 
  describe "POST /enrollments" do
    let(:path) { '/enrollments' }
    let(:user) do
      {
        id: 1,
        name: 'studentA',
        email: 'student-a@mail.com'
      }
    end

    let(:correct_role) { 'student'}
    let(:wrong_role) { 'vendor' }

    context 'When auth token not legal' do
      it 'Response with 401' do
        post path
        expect(response).to have_http_status(401)
      end
    end
    
    context 'When user not exist' do
      it 'Response with 400' do
        Data.users[:data] << user
        post path, params: {
               user_id: 2,
               course_id: 2,
               role: correct_role
             }, headers: header_with_token
        expect(response).to have_http_status(400)
      end
    end

    context 'When course not exist' do
      it 'Response with 400' do
        Data.users[:data] << user
        post path, params: {
               user_id: 1,
               course_id: 99,
               role: correct_role
             }, headers: header_with_token
        expect(response).to have_http_status(400)
      end
    end

    context 'When role not exist' do
      it 'Response with 400' do
        Data.users[:data] << user
        post path, params: {
               user_id: 1,
               course_id: 2,
               role: wrong_role
             }, headers: header_with_token
        expect(response).to have_http_status(400)
      end
    end

    context 'When all params are legal' do
      it 'Response with 201 and enrollment created' do
        Data.users[:data] << user
        post path, params: {
               user_id: 1,
               course_id: 2,
               role: correct_role
             }, headers: header_with_token
        expect(response).to have_http_status(201)
        expect(
          JSON.parse(response.body)['data'].symbolize_keys
        ).to eq({
                  user_id: 1,
                  course_id: 2,
                  role: 'student',
                  id: 1
                })
      end
    end
  end

  describe 'DELETE /enrollments/{:id}' do
    let(:path) { '/enrollments/1' }
    let(:enrollment) do
      {
        id: 1,
        user_id: 1,
        course_id: 1,
        role: 'student'
      }
    end

    context 'When auth token not legal' do
      it 'Response with 401' do
        delete path
        expect(response).to have_http_status(401)
      end
    end

    context 'When enrollment not exist' do
      it 'Response with 400' do
        delete path, headers: header_with_token
        expect(response).to have_http_status(400)
      end
    end

    context 'When enrollment exist' do
      before do
        Data.enrollments[:data] << enrollment
      end

      it 'Response with 200' do
        delete path, headers: header_with_token
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'get /enrollments/{:id}' do
    let(:path) { '/enrollments/1' }
    context 'When enrollment exist' do
      let(:enrollment) do
        {
          id: 1,
          user_id: 1,
          course_id: 1,
          role: 'student'
        }
      end
      it 'Response with enrollment data and 200' do
        Data.enrollments[:data] << enrollment
        get path
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['data'].symbolize_keys).to eq(enrollment)
      end
    end

    context 'When enrollment does not exist' do
      it 'Response with 400' do
        get path
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'get /enrollments/search' do
    let(:path1) { '/enrollments/search?user_id=1' }
    let(:path2) { '/enrollments/search?course_id=1' }
    let(:path3) { '/enrollments/search?role=student' }
    let(:enrollment1) do
      {
        id: 1,
        user_id: 1,
        course_id: 2,
        role: 'teacher'
      }
    end
    let(:enrollment2) do
      {
        id: 2,
        user_id: 1,
        course_id: 1,
        role: 'student'
      }
    end
    let(:enrollment3) do
      {
        id: 3,
        user_id: 2,
        course_id: 2,
        role: 'student'
      }
    end
    before do
      Data.enrollments[:data] << enrollment1
      Data.enrollments[:data] << enrollment2
      Data.enrollments[:data] << enrollment3
    end

    context 'When query with user_id' do
      it 'Response with correct enrollments data and 200' do
        get path1
        expect(response).to have_http_status(200)
        expect(
          JSON.parse(response.body)['data'].map(&:symbolize_keys)
        ).to eq([enrollment1, enrollment2])
      end
    end

    context 'When query with course_id' do
      it 'Response with correct enrollments data and 200' do
        get path2
        expect(response).to have_http_status(200)
        expect(
          JSON.parse(response.body)['data'].map(&:symbolize_keys)
        ).to eq([enrollment2])
      end
    end

    context 'When query with role' do
      it 'Response with correct enrollments data and 200' do
        get path3
        expect(response).to have_http_status(200)
        expect(
          JSON.parse(response.body)['data'].map(&:symbolize_keys)
        ).to eq([enrollment2, enrollment3])
      end
    end
  end
end

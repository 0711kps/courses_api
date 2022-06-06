require 'rails_helper'

RSpec.describe "Enrollments", type: :request do
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
    context 'When user not exist' do
      it 'Response with 400' do
        Data.users[:data] << user
        post path, params: {
               user_id: 2,
               course_id: 2,
               role: correct_role
             }
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
             }
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
             }
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
             }
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

    context 'When enrollment not exist' do
      it 'Response with 400' do
        delete path
        expect(response).to have_http_status(400)
      end
    end

    context 'When enrollment exist' do
      before do
        Data.enrollments[:data] << enrollment
      end

      it 'Response with 200' do
        delete path
        expect(response).to have_http_status(200)
      end
    end
  end
end

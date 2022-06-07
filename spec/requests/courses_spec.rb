require 'rails_helper'

RSpec.describe "Courses", type: :request do
  describe "GET /courses/{:id}" do
    let(:path1) { '/courses/1' }
    let(:path2) { '/courses/99' }
    
    context 'When course exist' do
      it 'Response with 200 and course data' do
        get path1
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['data'].symbolize_keys).to eq(Data.courses[:data][0])
      end
    end

    context 'When course does not exist' do
      it 'Response with 400' do
        get path2
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'GET /users/{:id}/courses' do
    let(:user) do
      {
        id: 1,
        name: 'student',
        email: 'stu@mail.com'
      }
    end
    
    let(:enrollment1) do
      {
        id: 1,
        user_id: 1,
        course_id: 1,
        role: 'student'
      }
    end
    
    let(:enrollment2) do
      {
        id: 2,
        user_id: 1,
        course_id: 2,
        role: 'student'
      }
    end

    let(:path1) { '/users/1/courses' }
    let(:path2) { '/users/2/courses' }

    before do
      Data.users[:data] << user
      Data.enrollments[:data] << enrollment1
      Data.enrollments[:data] << enrollment2
    end

    context 'When user exist' do
      it 'Response with 200 and courses data' do
        get path1
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['data'].map(&:symbolize_keys)).to eq(Data.courses[:data][0..1])
      end
    end

    context 'When user does not exist' do
      it 'Response with 400' do
        get path2
        expect(response).to have_http_status(400)
      end
    end
  end
end

require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "POST /users" do
    context 'When email not match regexp' do
      let(:sending_data) { { email: 'wrong-params' } }
      it 'Response with 400' do
        post '/users', params: sending_data
        expect(response).to have_http_status(400)
      end
    end

    context 'When email match regexp' do
      let(:sending_data) { { email: 'user@correct.mail.com' } }
      it 'Response with 201' do
        post '/users', params: sending_data
        expect(response).to have_http_status(201)
      end
    end
  end
end

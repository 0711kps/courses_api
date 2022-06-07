class TokensController < ApplicationController
  def make_me_wool
    token = encode_token({ user: 'wool', expired_at: Time.now + 1.hour })
    render json: { token: token }
  end
end

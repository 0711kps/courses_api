class ApplicationController < ActionController::API
  JWT_KEY = 'somesupersecretkey'

  private

  def encode_token(content)
    JWT.encode(content, JWT_KEY, 'HS256')
  end

  def decode_token(token)
    JWT.decode(token, JWT_KEY, 'HS256')
  rescue ArgumentError => e
    return [{'user' => nil}]
  end

  def validate_admin
    return render json: { msg: 'auth failed' }, status: :unauthorized unless (matching=request.headers['Authorization']&.match(/^Bearer (?<token>.+)$/))
    token = matching['token']
    user = decode_token(token)[0]['user']

    return render json: { msg: 'admin-only action' }, status: :unauthorized unless user == 'wool'
  end
end

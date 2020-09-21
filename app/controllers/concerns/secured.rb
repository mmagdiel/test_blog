module Secured
  def authenticate_user!
    token_regex = /Bearer (\w+)/
    # (): group capture of regex expression
    headers = request.headers
    if headers['Authorization'].present? && headers['Authorization'].match(token_regex)
      token = headers['Authorization'].match(token_regex)[1]
      if(Current.user = User.find_by_auth_token(token))
        # if assignate is truthy
        return 
      end
    end
    render json: {error: 'Unauthorized'}, status: :unauthorized
  end
end
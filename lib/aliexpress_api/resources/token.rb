# frozen_string_literal: true

module AliexpressAPI
  class AccessToken < Base
    class << self
      def refresh(refresh_token)
        params = {
          client_id: app_key,
          client_secret: app_secret,
          refresh_token: refresh_token,
          grant_type: 'refresh_token'
        }
        response = connection.post('https://oauth.aliexpress.com/token', params: params)
        raise ResultError, response if response['error_code'].present?

        response
      end
    end
  end
end

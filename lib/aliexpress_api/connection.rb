# frozen_string_literal: true

require 'http'

module AliexpressAPI
  class Connection
    def get(path, params: {})
      handle_request { HTTP.get(path, params: params) }
    end

    def post(path, params: {})
      handle_request { HTTP.post(path, form: params) }
    end

    private

    def handle_request
      response = yield
      handle_response response
    rescue HTTP::ConnectionError => e
      raise ConnectionError, e.message
    rescue HTTP::RequestError => e
      raise RequestError, e.message
    rescue HTTP::TimeoutError => e
      raise TimeoutError, e.message
    rescue HTTP::HeaderError => e
      raise HeaderError, e.message
    rescue HTTP::Error => e
      raise Error, e.message
    end

    def handle_response(response)
      case response.code.to_i
      when 301
        raise RedirectionError, response
      when 200
        response.parse(:json)
      when 400
        raise BadRequestError, response
      when 401
        raise UnauthorizedAccessError, response
      when 403
        raise ForbiddenAccessError, response
      when 404
        raise ResourceNotFoundError, response
      when 422
        raise ResourceInvalidError, response
      when 429
        raise TooManyRequestsError, response
      when 500
        raise ServerError, response
      else
        raise ResponseError.new(response, "Unknown response code: #{response.code}")
      end
    end
  end
end

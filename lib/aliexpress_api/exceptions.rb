# frozen_string_literal: true

module AliexpressAPI
  class Error < StandardError; end
  class RequestError < Error; end
  class ConnectionError < Error; end
  class StateError < Error; end
  class TimeoutError < Error; end
  class HeaderError < Error; end

  class ResponseError < Error
    attr_reader :response

    def initialize(response, message = nil)
      @response = response
      @message  = message
    end

    def to_s
      message = +'Failed.'
      if response.respond_to?(:code)
        message << "  Response code = #{response.code}."
      end
      if response.respond_to?(:to_s)
        message << "  Response message = #{response}."
      end
      message
    end
  end
  class RedirectionError < ResponseError
    def to_s
      response['Location'] ? "#{super} => #{response['Location']}" : super
    end
  end
  class BadRequestError < ResponseError; end
  class UnauthorizedAccessError < ResponseError; end
  class ResourceNotFoundError < ResponseError; end
  class ForbiddenAccessError < ResponseError; end
  class ResourceInvalidError < ResponseError; end
  class TooManyRequestsError < ResponseError; end
  class ServerError < ResponseError; end

  class AppKeyNotSetError < StandardError; end
  class AppSecretNotSetError < StandardError; end

  class ResultError < Error
    attr_reader :result

    def initialize(result, message: nil)
      @result = result
      @message = message
    end

    def message
      @message.present? ? @message : to_s
    end

    def to_s
      return "Failed. #{@result.to_json}." if @result.respond_to?(:to_json)

      "Failed. #{@result}."
    end
  end
end

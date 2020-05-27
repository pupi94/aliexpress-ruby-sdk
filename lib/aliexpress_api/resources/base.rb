# frozen_string_literal: true

require 'active_support/core_ext/time/zones'
require 'active_support/time_with_zone'
require 'active_support/core_ext/hash'
require 'active_support/hash_with_indifferent_access'
require 'aliexpress_api/threadsafe_attributes'

module AliexpressAPI
  class Base
    class << self
      include ThreadsafeAttributes

      threadsafe_attribute :_session

      %i[get post].each do |method|
        define_method method do |url, params = {}|
          response = connection.send(method, url, params: generate_request_params(params))

          error_response = response['error_response']
          if error_response.present?
            message = [error_response['msg'], error_response['sub_msg']].select(&:present?).join(': ')
            raise ResultError.new(error_response, message: message)
          end

          response
        end
      end

      def activate_session(session)
        self.session = session
        self
      end

      def connection
        @connection ||= Connection.new
      end

      def app_key
        return AliexpressAPI.app_key if AliexpressAPI.app_key

        raise AppKeyNotSetError, 'You must set AliexpressAPI::Base.app_key before making a request.'
      end

      def app_secret
        return AliexpressAPI.app_secret if AliexpressAPI.app_secret

        raise AppSecretNotSetError, 'You must set AliexpressAPI::Base.app_secret before making a request.'
      end

      def service_endpoint
        return AliexpressAPI.service_endpoint if AliexpressAPI.service_endpoint

        raise AppSecretNotSetError, 'You must set AliexpressAPI::Base.service_endpoint before making a request.'
      end

      def session=(session)
        self._session = session
      end

      def session
        if _session_defined?
          _session
        elsif superclass != Object
          superclass.session
        end
      end

      private

      def flatten_params(params)
        params.each_pair do |key, value|
          if value.present? && (value.is_a?(Hash) || value.is_a?(Array))
            params[key] = value.to_json
            end
        end
        params
      end

      def common_params
        {
          app_key: app_key,
          sign_method: 'md5',
          timestamp: Time.now.in_time_zone("Asia/Shanghai").strftime('%Y-%m-%d %H:%M:%S'),
          format: 'json',
          v: '2.0',
          session: session
        }
      end

      def generate_request_params(params)
        request_params = flatten_params(common_params.merge(params))
        request_params[:sign] = calculated_signature(request_params)
        request_params
      end

      def calculated_signature(params)
        encoded_params = app_secret.dup.concat(hash_to_string(params), app_secret)
        Digest::MD5.hexdigest(encoded_params).upcase
      end

      def hash_to_string(hash)
        hash.keys.sort.map { |key| "#{key}#{hash[key]}" }.join
      end
    end

    attr_reader :attributes

    def initialize(attributes = {})
      @attributes = attributes.with_indifferent_access
    end

    def [](key)
      attributes[key.to_s]
    end

    def []=(key, value)
      attributes[key.to_s] = value
    end

    def to_hash
      attributes.to_h
    end
    alias to_h to_hash

    def as_json(*_args)
      attributes.as_json
    end

    def to_json(*_args)
      attributes.to_json
    end

    def respond_to_missing?(method, *args)
      if attributes.nil?
        super
      elsif attributes.include?(method.to_s)
        true
      else
        super
      end
    end

    private

    def method_missing(method_symbol, *_arguments) #:nodoc:
      method_name = method_symbol.to_s
      attributes[method_name] if attributes.include?(method_name)
    end
  end
end

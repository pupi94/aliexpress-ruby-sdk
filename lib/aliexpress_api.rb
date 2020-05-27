# frozen_string_literal: true

require 'active_support/core_ext/module/attribute_accessors'
require 'aliexpress_api/version'
require 'aliexpress_api/connection'
require 'aliexpress_api/resources'
require 'aliexpress_api/exceptions'
require 'aliexpress_api/threadsafe_attributes'

module AliexpressAPI
  mattr_accessor :app_key
  @@app_key = nil

  mattr_accessor :app_secret
  @@app_secret = nil

  mattr_accessor :service_endpoint
  @@service_endpoint = nil

  def self.configure
    yield self
  end
end

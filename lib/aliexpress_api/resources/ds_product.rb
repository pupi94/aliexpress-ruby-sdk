# frozen_string_literal: true

module AliexpressAPI
  class DsProduct < Base
    class << self
      def find(id, options = {})
        params = options.symbolize_keys
        params[:product_id] = id
        params[:method] = 'aliexpress.postproduct.redefining.findaeproductbyidfordropshipper'

        response = post(service_endpoint, params)
        result = response['aliexpress_postproduct_redefining_findaeproductbyidfordropshipper_response']['result']

        if result['error_code'].present?
          raise ResultError.new(result, message: result['error_message'])
        end

        new(result)
      end

      def simple_find(id, options = {})
        params = options.symbolize_keys
        params[:product_id] = id
        params[:method] = 'aliexpress.offer.ds.product.simplequery'

        response = post(service_endpoint, params)
        result = response['aliexpress_offer_ds_product_simplequery_response']
        new(result)
      end
    end
  end
end

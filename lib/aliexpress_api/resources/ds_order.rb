# frozen_string_literal: true

module AliexpressAPI
  class DsOrder < Base
    class << self
      def create!(attributes = {})
        params = {
          method: 'aliexpress.trade.buy.placeorder',
          param_place_order_request4_open_api_d_t_o: attributes
        }
        response = post(service_endpoint, params)
        result = response['aliexpress_trade_buy_placeorder_response']['result']

        unless result['is_success']
          raise ResultError.new(result, message: result['error_msg'] || result['error_code'])
        end

        result['order_list']
      end

      def find(id)
        params = {
          method: 'aliexpress.trade.ds.order.get',
          single_order_query: { order_id: id }
        }
        response = post(service_endpoint, params)
        result = response['aliexpress_trade_ds_order_get_response']['result']
        new(result)
      end
    end
  end
end
